const express = require('express');
const router = express.Router();
const db = require('../config/database');
const Users = require('../models/Users');

router.get('/', (request, response) =>
    Users.findAll()
        .then(users => {
            console.log(users);
            response.sendStatus(200);
        })
        .catch(err => console.log(err)
        ));


//router.get('/', (req, res) => res.send("Testando Testando"));

module.exports = router;