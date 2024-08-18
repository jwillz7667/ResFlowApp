// src/models/Order.js

const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');
const User = require('./User'); // Make sure the casing matches the actual file name

const Order = sequelize.define('Order', {
    id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
    },
    userId: {
        type: DataTypes.UUID,
        references: {
            model: User, // Ensure this references the correct model
            key: 'id',
        },
    },
    totalPrice: {
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false,
        validate: {
            min: 0,
        },
    },
    status: {
        type: DataTypes.ENUM('pending', 'preparing', 'served', 'completed'),
        defaultValue: 'pending',
    },
}, {
    timestamps: true,
});

module.exports = Order;
