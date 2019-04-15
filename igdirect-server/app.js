import express from 'express';
import {interval, throwError, defer, of} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {getDevice, getCookieStorage,clearCookieFiles, encodeBase64} from "./utils";

const Client = require('instagram-private-api').V1;

const PORT = 5000;
const POLLING_INTERVAL = 1000;

interval(POLLING_INTERVAL).pipe(
    switchMap(() => isParentRunning())
).subscribe(
    function (isRunning) {
        if (isRunning !== true) {
            shutdown();
        }
    },
    function (err) {
        console.error('Error: ' + err);
        shutdown();
    }
);


// Set up the express app
const app = express();
app.use(express.json());

// get all todos
app.post('/api/v1/login', (req, res) => {

    let userName = req.body.userName;
    let password = req.body.password;
    let encodedUserName = encodeBase64(userName);
    defer(async function login() {
        const device = getDevice(encodedUserName);
        const storage = getCookieStorage(`${encodedUserName}.json`);
        return  Client.Session.create(device, storage, userName, password)
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

app.post('/api/v1/logout', (req, res) => {

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

const server = app.listen(PORT, () => {
    console.log(`server running on port ${PORT}`)
});

function isParentRunning() {

    if (process.env.NODE_ENV !== 'production') {
        return of(true)
    } else {
        if (process.argv.length < 3) {
            return throwError("Node is run without parentId argument")
        } else {
            return defer(async function () {
                let parentProcessId = process.argv[2];
                return require('is-running')(parentProcessId)
            })
        }
    }

}

function shutdown() {
    console.log("server shut down");
    server.close();
    process.exit(1);
}