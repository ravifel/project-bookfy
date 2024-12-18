const express = require('express');
require('dotenv').config();
const bodyParser = require('body-parser');
const path = require('path');

const PORT = process.env.PORT || 3000;
const db = require('./config/database');
const app = express();

// Test db connection
db.authenticate()
    .then(() => console.log('Database connected...'))
    .catch(err => console.log('Erro: ' + err))

// Routes
app.get('/', (request, response) => {
    response.send("It is working...")
})

// Users routes
app.use('/users', require('./routes/users'));
//app.use('/users', (request, response) => { response.send("Route '/users' is working...") });

app.listen(PORT, function () {
    console.log(`O express está rodando na porta ${PORT}`);
});
