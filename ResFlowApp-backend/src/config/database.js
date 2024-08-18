// config/database.js

const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASSWORD,
    {
        host: process.env.DB_HOST,
        dialect: 'postgres',
        port: process.env.DB_PORT,
        logging: false, // Set to true if you want SQL logs
    }
);

sequelize.authenticate()
    .then(() => console.log('PostgreSQL connected...'))
    .catch(err => console.error('Unable to connect to PostgreSQL:', err));

module.exports = sequelize;
