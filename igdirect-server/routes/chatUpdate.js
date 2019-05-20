import {defer} from "rxjs";

const express = require('express');
const router = express.Router();
const Client = require('instagram-private-api').V1;


router.post('/create', (req, res) => {

    defer(function getChatList() {
        return new Promise((resolve, reject) => {
            let session = req.session;
            let userId = req.body.userId;
            let message = req.body.message;
            Client.Thread.configureText(session, userId, message).then(resolve).catch(reject)
        })
    }).subscribe(
        function (ignored) {
            res.status(204).send({})
        },
        function (err) {
            res.status(401).send({
                error: err.name + " " + err.message
            })
        }
    );

});

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
                    error: err.name + " " + err.message
                })
            }
        );
});





module.exports = router;
