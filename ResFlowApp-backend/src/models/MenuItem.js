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
        }
}, {
    timestamps: true,
    paranoid: true, // Enable soft deletes
});

MenuItem.associate = (models) => {
    MenuItem.belongsToMany(models.Order, {
        through: 'OrderItems',
        foreignKey: 'menuItemId',
        as: 'orders',
    });
};

module.exports = MenuItem;

module.exports = MenuItem;
