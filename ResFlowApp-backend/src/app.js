// app.js

const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();
const rateLimit = require('express-rate-limit');
const sequelize = require('./config/database');
const routes = require('./routes');

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: 'Too many requests from this IP, please try again later.'
});

// Apply rate limiting to all requests
app.use(limiter);
app.use('/api', routes);

const PORT = process.env.PORT || 5000;

process.on('uncaughtException', (err) => {
    console.error('Uncaught Exception:', err);
    process.exit(1);
});

process.on('unhandledRejection', (err) => {
    console.error('Unhandled Rejection:', err);
    process.exit(1);
});

sequelize.sync().then(() => {
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
}).catch(err => {
    console.error('Database sync failed:', err);
    process.exit(1); // Exit the process if the database sync fails
});
