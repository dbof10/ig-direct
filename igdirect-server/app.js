import express from 'express';
import {interval, Observable, throwError, defer} from 'rxjs';
import {switchMap} from 'rxjs/operators';

var Client = require('instagram-private-api').V1;

const PORT = 5000;
const POLLING_INTERVAL = 1000;

interval(POLLING_INTERVAL).pipe(
    switchMap(() => isParentRunning())
).subscribe(
    function (isRunning) {
        console.log("server status isRunning " + isRunning);

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
// get all todos
app.get('/api/v1/todos', (req, res) => {
    res.status(200).send({
        success: 'true',
        message: 'todos retrieved successfully',
    })
});

const server = app.listen(PORT, () => {
    console.log(`server running on port ${PORT}`)
});

function isParentRunning() {

    if (process.argv.length < 3) {
        return throwError("Node is run without parentId argument")
    } else {
        return defer( async function() {
            let parentProcessId = process.argv[2];
            return require('is-running')(parentProcessId)
        })
    }

}

function shutdown() {
    console.log("server shut down");
    server.close();
    process.exit(1);
}