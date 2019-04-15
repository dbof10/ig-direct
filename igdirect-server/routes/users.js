import {clearCookieFiles, encodeBase64, getCookieStorage, getDevice} from "../utils";
import {defer} from "rxjs";

const express = require('express');
const router = express.Router();
const Client = require('instagram-private-api').V1;

router.post('/login', (req, res) => {

  let userName = req.body.userName;
  let password = req.body.password;
  let encodedUserName = encodeBase64(userName);
  defer(async function login() {
    const device = getDevice(encodedUserName);
    const storage = getCookieStorage(`${encodedUserName}.json`);
    return Client.Session.create(device, storage, userName, password)
  })
      .subscribe(
          function () {
            res.status(200).send({
              success: 'true'
            })
          },
          function (err) {
            res.status(401).send({
              error: err
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
            res.status(404).send({
              error: err
            })
          }
      );


});

module.exports = router;
