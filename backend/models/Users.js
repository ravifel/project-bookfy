const Sequelize = require('sequelize');
const db = require('../config/database');

const Users = db.define('user', {
    name: {
        type: Sequelize.STRING
    },
    cpf: {
        type: Sequelize.STRING
    },
    email: {
        type: Sequelize.STRING
    },
    telephone: {
        type: Sequelize.STRING
    },
    birthday: {
        type: Sequelize.DATE
    },
    password: {
        type: Sequelize.STRING
    },
    user_type: {
        type: Sequelize.STRING
    },
    profile_picture: {
        type: Sequelize.STRING
    },
    createdAt: {
        type: Sequelize.DATE
    }
}, {
    timestamps: false // Desativa timestamps automáticos
});

module.exports = Users;