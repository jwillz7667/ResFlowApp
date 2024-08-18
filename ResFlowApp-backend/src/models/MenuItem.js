// models/MenuItem.js

const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const Order = require('./Order');

const MenuItem = sequelize.define('MenuItem', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
        validate: {
            notEmpty: true,
        },
}, {
    timestamps: true,
});

module.exports = MenuItem;
