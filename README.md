# ΕΑΡΕΣ - Ένωση Αποφοίτων Ριζαρείου Εκκλησιαστικής Σχολής

Official website for the Alumni Association of Rizareios Ecclesiastical School.

## Features

- News & Announcements section with MySQL backend
- Responsive Bootstrap 4 design
- Greek language support
- Photo gallery
- Contact information

## Tech Stack

- **Backend**: Node.js + Express
- **Database**: MySQL
- **Frontend**: HTML5, CSS3, JavaScript (Vanilla)
- **Template**: Bootstrap 4.0 (Infinite Loop)

## Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure database:
   - Update `.env` file with your MySQL credentials
   - Create the database:
     ```bash
     npm run init-db
     ```

4. Start the server:
   ```bash
   npm run dev
   ```

5. Open browser at `http://localhost:3000`

## Project Structure

```
/eares
├── server.js              # Express server
├── package.json           # Dependencies
├── .env                   # Environment variables
├── public/                # Static assets
│   ├── index.html        # Main page
│   ├── css/              # Stylesheets
│   ├── js/               # JavaScript files
│   └── img/              # Images
├── routes/
│   └── api.js            # API routes
├── db/
│   ├── connection.js     # MySQL connection
│   └── schema.sql        # Database schema
└── controllers/
    └── newsController.js # News operations
```

## API Endpoints

- `GET /api/news` - Get all active news
- `GET /api/news/recent/:limit` - Get recent news
- `GET /api/news/:id` - Get single news item

## License

MIT
