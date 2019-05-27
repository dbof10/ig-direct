import {verify} from "../jwt";
import {defer} from "rxjs";
import {encodeBase64, getCookieStorage, getDevice} from "../utils";

const Client = require('instagram-private-api').V1;

export function authenticate(req, res, next) {

    let session =  req.header('x-session');  //login
    let userName = req.body.userName;
    let password = req.body.password;

    if (!session) {
        if (!userName && !password) {
            res.status(401).send({
                error: "Unauthorized request"
            });
        } else {
            next();
        }
    } else {
        let value = verify(session);
        let userName = value.userName;
        let password = value.password;
        let encodedUserName = encodeBase64(userName);
        let sessionPath = `${encodedUserName}.json`;

        defer(async function login() {
            const device = getDevice(encodedUserName);
            const storage = getCookieStorage(sessionPath);
            return Client.Session.create(device, storage, userName, password)
        }).subscribe(
            function (session) {
                req.session = session;
                req.user = value;
                next();
            },
            function (err) {
                res.status(401).send({
                    error: err
                });
            }
        );

    }
}
