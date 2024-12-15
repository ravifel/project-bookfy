require('dotenv').config();

const Sequelize = require('sequelize');
module.exports = new Sequelize(
    'bookfy-project-01',
    process.env.DATABASE_USER,
    process.env.DATABASE_PASSWORD,
    {
        host: 'localhost',
        dialect: 'postgres'
    });