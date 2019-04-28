import {defer} from "rxjs";
import {truncate} from '../utils/strings'
import {map} from 'rxjs/operators';

const express = require('express');
const router = express.Router();
const Client = require('instagram-private-api').V1;

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
                res.status(401).send({
                    error: err
                })
            }
        );

});

router.get('/:id', (req, res) => {

    let chatId = req.params.id;

    defer(function getChat() {
        return new Promise((resolve, reject) => {
            let session = req.session;
            Client.Thread.getById(session, chatId).then(resolve).catch(reject)
        })
    }).pipe(map(detail => {
        return renderChat(detail)
    }))
        .subscribe(
            function (detail) {
                res.status(200).send(detail)
            },
            function (err) {
                res.status(401).send({
                    error: err
                })
            }
        );
});


function renderChat(detail) {
    let messages = detail.items.slice().reverse();

    messages = messages.map((message) => {

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
            isSeen: getIsSeenText(detail)
        }
    });

    return messages

}

function getIsSeenText(chat) {
    let text = '';
    if (!chat.items || !chat.items.length) {
        return '';
    }

    let seenBy = chat.accounts.filter((account) => {
        return (
            chat._params.itemsSeenAt[account.id] &&
            chat._params.itemsSeenAt[account.id].itemId === chat.items[0].id
        )
    });

    if (seenBy.length === chat.accounts.length) {
        text = 'seen'
    } else if (seenBy.length) {
        text = `👁 ${getUsernames({accounts: seenBy})}`
    }
    return text;
}

function getUsernames(chat_) {
    return chat_.accounts.map((acc) => acc._params.username).join(', ');
}

function renderChatList(list) {

    return list.map(item => {
        let msgPreview = getMsgPreview(item);
        let userName = getUserName(item, true);
        let thumbnail = '';
        if (item.accounts[0]) {
            thumbnail = item.accounts[0]._params.picture;
        }
        return {
            id: item.id,
            msgPreview,
            userName,
            thumbnail
        }
    })

}

function getUserName(chat, shouldTruncate) {
    return chat.accounts.map((acc) => acc._params.username).join(', ');
}


function getMsgPreview(chat) {
    let msgPreview = chat.items[0]._params.text || 'Media message';
    return truncate(msgPreview, 25);
}

module.exports = router;
