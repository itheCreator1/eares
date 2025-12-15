# ΕΑΡΕΣ Website Setup Guide

Complete setup instructions for the EARES Alumni Association website.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Node.js** (v14 or higher) - [Download](https://nodejs.org/)
- **MySQL** (v5.7 or higher) - [Download](https://dev.mysql.com/downloads/mysql/)
- **Git** (for version control)

## Installation Steps

### 1. Install Dependencies

```bash
npm install
```

This will install all required packages:
- express
- mysql2
- dotenv
- cors
- body-parser
- nodemon (dev dependency)

### 2. Configure Environment Variables

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Edit `.env` and update with your MySQL credentials:
   ```env
   PORT=3000
   NODE_ENV=development
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_actual_mysql_password
   DB_NAME=eares_db
   ```

### 3. Setup MySQL Database

#### Option A: Using MySQL Command Line

1. Log into MySQL:
   ```bash
   mysql -u root -p
   ```

2. Run the schema file:
   ```bash
   source db/schema.sql
   ```

3. Verify the database was created:
   ```sql
   USE eares_db;
   SHOW TABLES;
   SELECT * FROM news;
   ```

#### Option B: Using npm Script

```bash
npm run init-db
```

This will prompt for your MySQL password and execute the schema.

### 4. Verify Database Setup

The database should now contain:
- Database: `eares_db`
- Table: `news` with 6 sample news items in Greek

Sample news includes:
- Εγκαίνια νέων γραφείων στον Πειραιά
- 180 χρόνια Ριζάρειου Σχολής
- Κοπή Βασιλόπιτας 2025
- Εκλογές Διοικητικού Συμβουλίου
- Γενική Συνέλευση Μελών
- Υποτροφίες για φοιτητές 2025

## Running the Application

### Development Mode (with auto-restart)

```bash
npm run dev
```

This uses nodemon to automatically restart the server when files change.

### Production Mode

```bash
npm start
```

### Expected Output

```
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║            ΕΑΡΕΣ Website Server                            ║
║   Ένωση Αποφοίτων Ριζαρείου Εκκλησιαστικής Σχολής        ║
║                                                            ║
║   Server running on: http://localhost:3000                ║
║   Environment: development                                 ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

✅ Database connected successfully
```

## Testing the Application

### 1. Open Your Browser

Navigate to: **http://localhost:3000**

### 2. Test API Endpoints

#### Get all news:
```bash
curl http://localhost:3000/api/news
```

#### Get recent 3 news items:
```bash
curl http://localhost:3000/api/news/recent/3
```

#### Get specific news item:
```bash
curl http://localhost:3000/api/news/1
```

#### Health check:
```bash
curl http://localhost:3000/api/health
```

### 3. Verify News Section

On the homepage:
- Navigate to "Νέα & Ανακοινώσεις" section
- You should see 6 news cards displaying
- Each card should show: image, date, title, summary, and "Διαβάστε περισσότερα" link

## Project Structure

```
/eares
├── server.js                 # Express server entry point
├── package.json              # Dependencies and scripts
├── .env                      # Environment variables (not in git)
├── .env.example              # Template for .env
├── README.md                 # Project overview
├── SETUP.md                  # This file
│
├── public/                   # Static assets served by Express
│   ├── index.html           # Main HTML page
│   ├── css/                 # Stylesheets
│   │   ├── bootstrap.min.css
│   │   └── tooplate-infinite-loop.css  (with news styles)
│   ├── js/                  # JavaScript files
│   │   ├── jquery-1.9.1.min.js
│   │   ├── bootstrap.min.js
│   │   └── news.js          # News API integration
│   ├── img/                 # Images
│   ├── fontawesome-5.5/     # Icons
│   ├── magnific-popup/      # Image lightbox
│   └── slick/               # Carousel library
│
├── routes/
│   └── api.js               # API route definitions
│
├── controllers/
│   └── newsController.js    # News CRUD operations
│
└── db/
    ├── connection.js        # MySQL connection pool
    └── schema.sql           # Database schema & sample data
```

## Troubleshooting

### Database Connection Failed

**Error:** `❌ Database connection failed: Access denied`

**Solution:**
1. Verify MySQL is running: `sudo systemctl status mysql` (Linux) or check Services (Windows)
2. Check `.env` credentials match your MySQL user
3. Grant privileges: `GRANT ALL PRIVILEGES ON eares_db.* TO 'root'@'localhost';`

### Port Already in Use

**Error:** `EADDRINUSE: address already in use :::3000`

**Solution:**
1. Change PORT in `.env` to 3001 or another available port
2. Or kill the process using port 3000:
   ```bash
   # Find process
   lsof -i :3000
   # Kill it
   kill -9 <PID>
   ```

### News Not Loading

**Error:** News section shows "Φόρτωση νέων..." indefinitely

**Solution:**
1. Open browser console (F12) to check for errors
2. Verify API is working: `curl http://localhost:3000/api/news/recent/6`
3. Check database has data: `SELECT COUNT(*) FROM eares_db.news;`
4. Ensure `news.js` is loaded (check Network tab in browser)

### MySQL "Unknown database" Error

**Error:** `ER_BAD_DB_ERROR: Unknown database 'eares_db'`

**Solution:**
Re-run the database initialization:
```bash
mysql -u root -p < db/schema.sql
```

## Next Steps

### Customization

1. **Replace Images:**
   - Update `/public/img/` folder with EARES photos
   - Update image URLs in database news items

2. **Update Contact Info:**
   - Edit contact section in `/public/index.html` (lines 307-362)
   - Replace placeholder email, phone, address

3. **Add More News:**
   - Insert directly into MySQL:
     ```sql
     INSERT INTO news (title_el, content_el, summary_el, published_date, priority)
     VALUES ('Νέο Τίτλος', 'Περιεχόμενο...', 'Περίληψη...', '2025-01-20', 5);
     ```

4. **Styling Adjustments:**
   - Modify colors in `/public/css/tooplate-infinite-loop.css`
   - EARES primary color: `#369`

### Future Enhancements

- **Admin Panel:** Add interface to manage news without SQL
- **Member Login:** Implement authentication system
- **News Detail Page:** Create modal or separate page for full articles
- **Pagination:** Add "Load More" for news section
- **Search:** Implement news search functionality
- **Multilingual:** Add English/Greek language toggle

## Support

For issues or questions:
- Check this guide first
- Review error messages in console
- Contact the development team

---

**Built with:**
- Node.js + Express
- MySQL
- Bootstrap 4
- Vanilla JavaScript

**For:** Ένωση Αποφοίτων Ριζαρείου Εκκλησιαστικής Σχολής (ΕΑΡΕΣ)
