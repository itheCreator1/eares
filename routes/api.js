// API Routes for EARES
// Defines all API endpoints for the application

const express = require('express');
const router = express.Router();
const newsController = require('../controllers/newsController');

// News routes
router.get('/news', newsController.getAllNews);
router.get('/news/recent/:limit', newsController.getRecentNews);
router.get('/news/:id', newsController.getNewsById);

// Health check endpoint
router.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'EARES API is running' });
});

module.exports = router;
