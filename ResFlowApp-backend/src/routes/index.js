
const express = require('express');
const router = express.Router();
const authRoutes = require('./authroutes');

router.use('/auth', authRoutes);

module.exports = router;
