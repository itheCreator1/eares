// News Controller for EARES
// Handles all news-related database operations

const db = require('../db/connection');

// Get all active news, ordered by priority and date
const getAllNews = async (req, res) => {
  try {
    const [rows] = await db.query(
      `SELECT id, title_el, title_en, content_el, content_en,
              summary_el, summary_en, image_url, published_date,
              priority, created_at
       FROM news
       WHERE is_active = true
       ORDER BY priority DESC, published_date DESC`
    );

    res.json(rows);
  } catch (error) {
    console.error('Error fetching all news:', error);
    res.status(500).json({ error: 'Failed to fetch news' });
  }
};

// Get recent news with limit
const getRecentNews = async (req, res) => {
  try {
    const limit = parseInt(req.params.limit) || 6;

    const [rows] = await db.query(
      `SELECT id, title_el, title_en, content_el, content_en,
              summary_el, summary_en, image_url, published_date,
              priority, created_at
       FROM news
       WHERE is_active = true
       ORDER BY priority DESC, published_date DESC
       LIMIT ?`,
      [limit]
    );

    res.json(rows);
  } catch (error) {
    console.error('Error fetching recent news:', error);
    res.status(500).json({ error: 'Failed to fetch recent news' });
  }
};

// Get single news item by ID
const getNewsById = async (req, res) => {
  try {
    const id = parseInt(req.params.id);

    const [rows] = await db.query(
      `SELECT id, title_el, title_en, content_el, content_en,
              summary_el, summary_en, image_url, published_date,
              priority, created_at
       FROM news
       WHERE id = ? AND is_active = true`,
      [id]
    );

    if (rows.length === 0) {
      return res.status(404).json({ error: 'News item not found' });
    }

    res.json(rows[0]);
  } catch (error) {
    console.error('Error fetching news by ID:', error);
    res.status(500).json({ error: 'Failed to fetch news item' });
  }
};

module.exports = {
  getAllNews,
  getRecentNews,
  getNewsById
};
