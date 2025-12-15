// News & Announcements JavaScript for EARES
// Dynamically loads and displays news from the API

document.addEventListener('DOMContentLoaded', async function() {
  await loadNews();
});

/**
 * Fetch and display news items
 */
async function loadNews() {
  const newsContainer = document.getElementById('newsContainer');

  try {
    // Fetch recent 6 news items from API
    const response = await fetch('/api/news/recent/6');

    if (!response.ok) {
      throw new Error('Failed to fetch news');
    }

    const newsItems = await response.json();

    // Clear loading message
    newsContainer.innerHTML = '';

    // Check if there are news items
    if (newsItems.length === 0) {
      newsContainer.innerHTML = '<div class="col-12 text-center"><p>Δεν υπάρχουν διαθέσιμα νέα αυτή τη στιγμή.</p></div>';
      return;
    }

    // Generate and insert news cards
    newsItems.forEach(news => {
      const newsCard = createNewsCard(news);
      newsContainer.innerHTML += newsCard;
    });

  } catch (error) {
    console.error('Error loading news:', error);
    newsContainer.innerHTML = `
      <div class="col-12 text-center">
        <p class="text-danger">Σφάλμα φόρτωσης νέων. Παρακαλώ δοκιμάστε ξανά αργότερα.</p>
      </div>`;
  }
}

/**
 * Create HTML for a single news card
 * @param {Object} news - News object from API
 * @returns {string} HTML string
 */
function createNewsCard(news) {
  const date = formatDate(news.published_date);
  const imageUrl = news.image_url || 'img/gallery-img-01.jpg';
  const title = news.title_el || news.title_en;
  const summary = news.summary_el || news.summary_en || '';

  return `
    <div class="col-lg-4 col-md-6 mb-4">
      <div class="tm-news-card">
        <img src="${imageUrl}" alt="${escapeHtml(title)}" class="img-fluid tm-news-img">
        <div class="tm-news-card-content">
          <span class="tm-news-date">${date}</span>
          <h3 class="tm-news-title">${escapeHtml(title)}</h3>
          <p class="tm-news-summary">${escapeHtml(truncateText(summary, 120))}</p>
          <a href="#" class="tm-news-read-more" onclick="viewNewsDetail(${news.id}); return false;">
            Διαβάστε περισσότερα »
          </a>
        </div>
      </div>
    </div>
  `;
}

/**
 * Format date to Greek locale
 * @param {string} dateString - Date string from database
 * @returns {string} Formatted date
 */
function formatDate(dateString) {
  const options = { year: 'numeric', month: 'long', day: 'numeric' };
  const date = new Date(dateString);
  return date.toLocaleDateString('el-GR', options);
}

/**
 * Truncate text to specified length
 * @param {string} text - Text to truncate
 * @param {number} maxLength - Maximum length
 * @returns {string} Truncated text
 */
function truncateText(text, maxLength) {
  if (!text) return '';
  if (text.length <= maxLength) return text;
  return text.substr(0, maxLength) + '...';
}

/**
 * Escape HTML to prevent XSS
 * @param {string} text - Text to escape
 * @returns {string} Escaped text
 */
function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

/**
 * View detailed news item (to be implemented)
 * @param {number} newsId - ID of the news item
 */
function viewNewsDetail(newsId) {
  // TODO: Implement modal or detail page for news
  console.log('View news detail:', newsId);
  alert('Λειτουργία προβολής λεπτομερειών - θα υλοποιηθεί σύντομα');
}
