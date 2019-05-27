import {defer} from "rxjs";
import {truncate} from '../utils/strings'
import {map} from 'rxjs/operators';

const express = require('express');
const router = express.Router();
const Client = require('instagram-private-api').V1;

let messagesThread;

router.get('/all', (req, res) => {

    defer(function getChatList() {
        return new Promise((resolve, reject) => {
            let session = req.session;
            const feed = new Client.Feed.Inbox(session, 10);
            feed.all().then(resolve).catch(reject)
        })
    }).pipe(map(list => {
        return renderChatList(list)
    }))
        .subscribe(
            function (list) {
                res.status(200).send(list)
            },
            function (err) {
                res.status(400).send({
                    errorType: err.name,
                    message: err.message
                })
            }
        );

});

router.get('/search', (req, res) => {

    let keyword = req.query.keyword;

    defer(function searchChat() {
        return new Promise((resolve, reject) => {
            let session = req.session;
            return Client.Account.search(session, keyword).then(resolve).catch(reject)
        });
    }).pipe(map(list => {
        return renderSearchResult(list)
    }))
        .subscribe(
            function (users) {
                res.status(200).send(users)
            },
            function (err) {
                res.status(400).send({
                    errorType: err.name,
                    message: err.message
                })
            }
        );


});

router.get('/:id', (req, res) => {

    let chatId = req.params.id;

    // client select new chat
    if (messagesThread && messagesThread.threadId !== chatId) {
        messagesThread = null
    }

    defer(function getChat() {
        return new Promise((resolve, reject) => {
            let session = req.session;
            Client.Thread.getById(session, chatId).then(resolve).catch(reject)
        })
    }).pipe(map(detail => {
        return renderChat(detail, detail.items, req.user)
    }))
        .subscribe(
            function (list) {

                res.status(200).send(list)
            },
            function (err) {
                res.status(400).send({
                    errorType: err.name,
                    message: err.message
                })
            }
        );
});


router.get('/older/:id', (req, res) => {

    let chatId = req.params.id;
    defer(function getChat() {
        return new Promise((resolve, reject) => {
            let session = req.session;
            let currentClientThread = messagesThread;
            const needsNewThread = !currentClientThread || currentClientThread.threadId !== chatId;

            if (needsNewThread) {
                currentClientThread = new Client.Feed.ThreadItems(session, chatId)
            }

            if (!needsNewThread && !currentClientThread.isMoreAvailable()) {
                // there aren't any older messages
                resolve({currentClientThread, messages: []})
            }

            currentClientThread.get().then((messages) => {
                if (needsNewThread) {
                    if (currentClientThread.isMoreAvailable()) {
                        // get the next 20 because the first 20 messages already were fetched with #getChat
                        return currentClientThread.get().then((messages) => resolve({currentClientThread, messages}))
                    }
                    // there aren't any older messages
                    messages = []
                }
                resolve({currentClientThread, messages})
            }).catch(reject)
        })
    }).pipe(map(data => {
        messagesThread = data.currentClientThread;
        return renderChat(null, data.messages, null)
    }))
        .subscribe(
            function (list) {
                res.status(200).send(list)
            },
            function (err) {
                res.status(400).send({
                    errorType: err.name,
                    message: err.message
                })
            }
        );
});

function renderSearchResult(users) {
    return users.map((user) => {
        return user._params

    })
}

function renderChat(detail, list, user) {
    let messages = list.slice().reverse().map((message) => {

        let type = message._params.type;
        let payload;
        switch (type) {
            case "text":
                payload = {
                    text: message._params.text
                };
                break;
            case "media":
                payload = {
                    mediaUrl: message._params.media[0].url
                };
                break;
            case "link":
                const {link} = message.link._params;
                let mediaUrl = null;
                if (link.image && link.image.url) {
                    mediaUrl = link.image.url
                }
                payload = {
                    mediaUrl,
                    text: message.link._params.text,
                    title: link.title,
                    summary: link.summary
                };
                break;
            case "placeholder":
                break;
        }
        return {
            id: message._params.id,
            senderId: message._params.accountId,
            createdAt: message._params.created,
            type: message._params.type,
            payload,
        }
    });

    let isSeen = getIsSeenText(detail, user);

    if (isSeen.length !== 0) {

        let message = {
            id: Number.MIN_SAFE_INTEGER.toString(),
            senderId: 0,
            createdAt: 0,
            type: "seen",
            payload: {
                text: isSeen
            }
        };
        messages.push(message)
    }
    return messages

}

function getIsSeenText(chat, user) {
    if (chat == null || user == null) { //load more
        return ""
    }

    let text = "";

    if (!chat.items || !chat.items.length || chat.items[0]._params.accountId !== user.userId) {
        return "";
    }

    let seenBy = chat.accounts.filter((account) => {
        return (
            chat._params.itemsSeenAt[account.id] &&
            chat._params.itemsSeenAt[account.id].itemId === chat.items[0].id
        )
    });

    if (seenBy.length === chat.accounts.length) {
        text = "seen"
    } else if (seenBy.length) {
        text = `👁 ${getUserNames({accounts: seenBy})}`
    }
    return text;
}

function getUserNames(chat_) {
    return chat_.accounts.map((acc) => acc._params.username).join(', ');
}

function renderChatList(list) {

    return list.map(item => {
        let msgPreview = getMsgPreview(item);
        let account = getAccount(item, true);
        return {
            id: item.id,
            msgPreview,
            account
        }
    })

}

function getAccount(chat) {
    return chat.accounts.map((acc) => {
        return acc._params
    });
}


function getMsgPreview(chat) {
    let msgPreview = chat.items[0]._params.text || 'Media message';
    return truncate(msgPreview, 25);
}

module.exports = router;
