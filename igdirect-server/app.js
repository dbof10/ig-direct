import express from 'express';
import {interval, throwError, defer, of} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {authenticate} from './middleware/authenticate';

const usersRouter = require('./routes/users');
const chatGetRouter = require('./routes/chatGet');
const chatUpdateRouter = require('./routes/chatUpdate');

const PORT = 5000;
const POLLING_INTERVAL = 1000;
const SERVER_STATUS = 100;

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
app.use(authenticate);
app.use('/users', usersRouter);
app.use('/chats', chatGetRouter);
app.use('/chats', chatUpdateRouter);

const server = app.listen(PORT, () => {
    console.log(SERVER_STATUS);
    console.log(`server running on port ${PORT}`)
});

function isParentRunning() {

    if (process.env.NODE_ENV !== 'production') {
        return of(true)
    } else {
        if (process.argv.length < 4) {
            return throwError("Missing required argument")
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