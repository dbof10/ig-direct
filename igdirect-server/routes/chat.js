import {defer} from "rxjs";
import {truncate} from '../utils/strings'
import { map } from 'rxjs/operators';

const express = require('express');
const router = express.Router();
const Client = require('instagram-private-api').V1;

router.get('/list', (req, res) => {


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

function renderChatList(list) {

    return list.map(item => {
        let msgPreview = getMsgPreview(item);
        let userName = getUserName(item, true);
        let thumbnail = '';
        if (item.accounts[0]) {
            thumbnail = item.accounts[0]._params.picture;
        }
        return {
            msgPreview,
            userName,
            thumbnail
        }
    })

}

function getUserName (chat, shouldTruncate) {
    return chat.accounts.map((acc) => acc._params.username).join(', ');
}


function getMsgPreview (chat) {
    let msgPreview = chat.items[0]._params.text || 'Media message';
    return truncate(msgPreview, 25);
}

module.exports = router;
