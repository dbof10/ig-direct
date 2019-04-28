import {defer} from "rxjs";
import {truncate} from '../utils/strings'
import {map, switchMap} from 'rxjs/operators';

const express = require('express');
const router = express.Router();
const Client = require('instagram-private-api').V1;




router.post('/:id', (req, res) => {

    let chatId = req.params.id;

    defer(function getChat() {
        return new Promise((resolve, reject) => {
            let session = req.session;
            let message = req.body.message;
            Client.Thread.getById(session, chatId)
                .then((thread) => {
                    thread.broadcastText(message).then(resolve).catch(reject)
                }).catch(reject)
        })
    }).subscribe(
            function () {
                res.status(201).send({})
            },
            function (err) {
                res.status(400).send({
                    error: err
                })
            }
        );
});






module.exports = router;
