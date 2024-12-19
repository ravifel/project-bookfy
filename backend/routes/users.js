const express = require('express');
const router = express.Router();
const db = require('../config/database');
const Users = require('../models/Users');
const moment = require('moment');


// Get users list
router.get('/', (request, response) =>
    Users.findAll()
        .then(users => {
            console.log(users);
            response.sendStatus(200);
        })
        .catch(err => console.log(err)
        ));

// Add a user
router.get('/add', (request, response) => {
    const data = {
        name: 'Thales Isaac Vinicius Porto',
        cpf: '20427978718',
        email: 'thalesisaacporto@transtelli.com.br',
        telephone: '2128900795',
        birthday: moment('02/04/1984', 'DD/MM/YYYY').format('YYYY-MM-DD'),
        password: 'X65o1U7dXa',
        user_type: 'seller',
        profile_picture: 'thales-porto.jpg'
    }

    profile_picture: 'diego-mendes.jpg'
    let {
        name,
        cpf,
        email,
        telephone,
        birthday,
        password,
        user_type,
        profile_picture
    } = data;

    // Insert into table
    Users.create({
        name,
        cpf,
        email,
        telephone,
        birthday,
        password,
        user_type,
        profile_picture
    })
        .then(user => response.redirect('/users'))
        .catch(err => console.log(err));
});

module.exports = router;