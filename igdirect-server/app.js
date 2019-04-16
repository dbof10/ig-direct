import express from 'express';
import {interval, throwError, defer, of} from 'rxjs';
import {switchMap} from 'rxjs/operators';
import {authenticate} from './middleware/authenticate';

const usersRouter = require('./routes/users');
const chatRouter = require('./routes/chat');

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
app.use(authenticate);
app.use('/users', usersRouter);
app.use('/chat', chatRouter);

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