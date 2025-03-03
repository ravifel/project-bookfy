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
            response.send('users', {
                users
            })
        })
        .catch(err => console.log(err)
        ));

// Get user by 'id'
// Waiting for the implementation

// Add a user
router.get('/add', (request, response) => {
    const data = {
        name: 'Thales tESTE',
        cpf: '20427978799',
        email: 'thalesteste@transtelli.com.br',
        telephone: '2128900795',
        birthday: moment('02/04/1984', 'DD/MM/YYYY').format('YYYY-MM-DD'),
        password: 'X65o1U7dXa',
        user_type: 'seller',
        profile_picture: 'thales-porto.jpg'
    }

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

// Updating User
router.get('/update/:id', (request, response) => {
    const data = {
        name: 'Marcel McElroy',
        cpf: '71013103203',
        email: 'marcelmcelroy@mcelroy.com.br',
        telephone: '639427635',
        birthday: moment('01/01/1949', 'DD/MM/YYYY').format('YYYY-MM-DD'),
        password: ']hmh3E9=qL2',
        user_type: 'buyer',
        profile_picture: 'marcel-mcelroy.jpg'
    }

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

    const userId = request.params.id; // Getting the ID from the URL

    // Update in table
    Users.update({
        name,
        cpf,
        email,
        telephone,
        birthday,
        password,
        user_type,
        profile_picture
    }, {
        where: { id: userId } // Specifying the record to be updated
    })
        .then(() => response.redirect('/users'))
        .catch(err => console.log(err));
});

// Delete User
// Waiting for the implementation

module.exports = router;