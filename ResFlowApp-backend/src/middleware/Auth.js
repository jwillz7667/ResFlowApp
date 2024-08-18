// middleware/auth.js

const jwt = require('jsonwebtoken');
require('dotenv').config();

function authenticateToken(req, res, next) {
    const authHeader = req.header('Authorization');
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
        return res.status(401).send('Access Denied');
    }

    const token = authHeader.split(' ')[1];
    if (!token) return res.status(401).send('Access Denied');

    try {
        const verified = jwt.verify(token, process.env.JWT_SECRET);
        if (Date.now() >= verified.exp * 1000) {
            return res.status(401).send('Token expired');
        }
        req.user = verified;
        next();
    } catch (err) {
        res.status(400).send('Invalid or Expired Token');
    }
}

module.exports = authenticateToken;
