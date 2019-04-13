import express from 'express';
var Client = require('instagram-private-api').V1;



// Set up the express app
const app = express();
// get all todos
app.get('/api/v1/todos', (req, res) => {
    res.status(200).send({
        success: 'true',
        message: 'todos retrieved successfully',
        todos: {

        }
    })
});
const PORT = 5000;

app.listen(PORT, () => {
    console.log(`server running on port ${PORT}`)
});