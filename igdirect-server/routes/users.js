import {clearCookieFiles, encodeBase64, getCookieStorage, getDevice} from "../utils";
import {defer} from "rxjs";
import {sign} from "../jwt";
import {switchMap} from 'rxjs/operators';

const express = require('express');
const router = express.Router();
const Client = require('instagram-private-api').V1;

router.post('/login', (req, res) => {

    let userName = req.body.userName;
    let password = req.body.password;
    let encodedUserName = encodeBase64(userName);
    let sessionPath = `${encodedUserName}.json`;
    defer(async function login() {

        const device = getDevice(encodedUserName);
        const storage = getCookieStorage(sessionPath);
        return Client.Session.create(device, storage, userName, password)
    })
        .pipe(
            switchMap((session => {
                return defer(function getChatList() {
                    return new Promise((resolve, reject) => {
                        session.getAccount().then(resolve).catch(reject)
                    })
                })
            }))
        )
        .subscribe(
            function (session) {
                let token = sign({userName, password});
                res.status(200).send({
                    token,
                    user: session.params
                })
            },
            function (err) {
                res.status(401).send({
                    errorType: err.name,
                    message: err.message
                })
            }
        );


});

router.post('/logout', (req, res) => {

    let userName = req.body.userName;
    let encodedUserName = encodeBase64(userName);
    defer(async function logout() {
        return clearCookieFiles(`${encodedUserName}.json`);
    })
        .subscribe(
            function (value) {
                res.status(200).send({
                    success: value
                })
            },
            function (err) {
                res.status(400).send({
                    errorType: err.name,
                    message: err.message
                })
            }
        );


});

module.exports = router;
