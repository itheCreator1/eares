-- EARES Database Schema
-- Ένωση Αποφοίτων Ριζαρείου Εκκλησιαστικής Σχολής

-- Create database
CREATE DATABASE IF NOT EXISTS eares_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE eares_db;

-- News table with bilingual support (Greek/English)
CREATE TABLE news (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title_el VARCHAR(255) NOT NULL COMMENT 'Greek title',
    title_en VARCHAR(255) COMMENT 'English title',
    content_el TEXT NOT NULL COMMENT 'Greek content',
    content_en TEXT COMMENT 'English content',
    summary_el VARCHAR(500) COMMENT 'Greek summary for cards',
    summary_en VARCHAR(500) COMMENT 'English summary for cards',
    image_url VARCHAR(255) COMMENT 'News image path',
    published_date DATE NOT NULL COMMENT 'Publication date',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true COMMENT 'Published status',
    priority INT DEFAULT 0 COMMENT 'Higher priority appears first',
    INDEX idx_published_date (published_date),
    INDEX idx_is_active (is_active),
    INDEX idx_priority (priority)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert sample news data
INSERT INTO news (title_el, title_en, content_el, content_en, summary_el, summary_en, published_date, priority, image_url) VALUES
(
    'Εγκαίνια νέων γραφείων στον Πειραιά',
    'Inauguration of new offices in Piraeus',
    'Η Ένωση Αποφοίτων Ριζαρείου Εκκλησιαστικής Σχολής εγκαινίασε τα νέα της γραφεία στον Πειραιά την 15η Ιανουαρίου 2025. Η εκδήλωση πραγματοποιήθηκε με την παρουσία του Διοικητικού Συμβουλίου και πολλών μελών της ένωσης. Τα νέα γραφεία βρίσκονται σε κεντρικό σημείο και θα φιλοξενούν όλες τις δραστηριότητες της ΕΑΡΕΣ.',
    'The Alumni Association of Rizareios Ecclesiastical School inaugurated its new offices in Piraeus on January 15, 2025. The event was attended by the Board of Directors and many members of the association. The new offices are centrally located and will host all EARES activities.',
    'Πραγματοποιήθηκαν τα εγκαίνια των νέων γραφείων της ΕΑΡΕΣ στον Πειραιά με την παρουσία μελών και του Διοικητικού Συμβουλίου.',
    'EARES inaugurated its new offices in Piraeus with members and the Board of Directors in attendance.',
    '2025-01-15',
    10,
    'img/gallery-img-01.jpg'
),
(
    '180 χρόνια Ριζάρειου Σχολής',
    '180 Years of Rizareios School',
    'Η Ριζάρειος Εκκλησιαστική Σχολή γιορτάζει 180 χρόνια συνεχούς λειτουργίας και προσφοράς στην Ελληνική Παιδεία. Από το 1844 μέχρι σήμερα, η σχολή έχει αναδείξει χιλιάδες απόφοιτους που υπηρετούν την Εκκλησία και την κοινωνία. Η επέτειος θα γιορταστεί με σειρά εκδηλώσεων καθ όλη τη διάρκεια του έτους.',
    'Rizareios Ecclesiastical School celebrates 180 years of continuous operation and contribution to Greek Education. Since 1844 until today, the school has produced thousands of graduates serving the Church and society. The anniversary will be celebrated with a series of events throughout the year.',
    'Εορτασμοί για την 180η επέτειο της Ριζάρειου Εκκλησιαστικής Σχολής με σειρά εκδηλώσεων.',
    'Celebrations for the 180th anniversary of Rizareios Ecclesiastical School with a series of events.',
    '2025-01-10',
    9,
    'img/gallery-img-02.jpg'
),
(
    'Κοπή Βασιλόπιτας 2025',
    'Vasilopita Cutting Ceremony 2025',
    'Η ΕΑΡΕΣ σας προσκαλεί στην ετήσια εκδήλωση κοπής Βασιλόπιτας που θα πραγματοποιηθεί την Κυριακή 5 Ιανουαρίου 2025. Η εκδήλωση θα περιλαμβάνει κοπή πίτας, χαιρετισμούς του προέδρου και μουσική παράσταση. Όλα τα μέλη και οι φίλοι της σχολής είναι ευπρόσδεκτοι.',
    'EARES invites you to the annual Vasilopita (New Year pie) cutting ceremony on Sunday, January 5, 2025. The event will include the pie cutting, greetings from the president, and a musical performance. All members and friends of the school are welcome.',
    'Πρόσκληση για την ετήσια εκδήλωση κοπής Βασιλόπιτας της ΕΑΡΕΣ την Κυριακή 5 Ιανουαρίου.',
    'Invitation to the annual EARES Vasilopita ceremony on Sunday, January 5.',
    '2025-01-05',
    8,
    'img/gallery-img-03.jpg'
),
(
    'Εκλογές Διοικητικού Συμβουλίου',
    'Board Elections',
    'Ανακοινώνεται η διεξαγωγή εκλογών για την ανάδειξη νέου Διοικητικού Συμβουλίου της ΕΑΡΕΣ. Οι εκλογές θα πραγματοποιηθούν στις 20 Φεβρουαρίου 2025. Καλούνται όλα τα τακτικά μέλη να συμμετάσχουν στη διαδικασία. Υποψηφιότητες γίνονται δεκτές μέχρι τις 10 Φεβρουαρίου.',
    'Board elections announcement for EARES. Elections will be held on February 20, 2025. All regular members are invited to participate. Candidacies are accepted until February 10.',
    'Ανακοίνωση για τις εκλογές του νέου Διοικητικού Συμβουλίου την 20η Φεβρουαρίου 2025.',
    'Announcement for Board elections on February 20, 2025.',
    '2025-01-03',
    7,
    'img/gallery-img-04.jpg'
),
(
    'Γενική Συνέλευση Μελών',
    'General Assembly',
    'Πρόσκληση για τη Γενική Συνέλευση των μελών της ΕΑΡΕΣ που θα πραγματοποιηθεί στις 15 Μαρτίου 2025 στα γραφεία της ένωσης. Θέματα ημερήσιας διάταξης: Απολογισμός έτους 2024, οικονομικά στοιχεία, προγραμματισμός δράσεων 2025.',
    'Invitation to the EARES General Assembly on March 15, 2025 at the association offices. Agenda: 2024 report, financial data, 2025 action planning.',
    'Πρόσκληση για Γενική Συνέλευση μελών στις 15 Μαρτίου 2025.',
    'General Assembly invitation for March 15, 2025.',
    '2025-01-02',
    6,
    'img/gallery-img-05.jpg'
),
(
    'Υποτροφίες για φοιτητές 2025',
    'Scholarships for students 2025',
    'Η ΕΑΡΕΣ ανακοινώνει την απονομή υποτροφιών σε σπουδαστές για το ακαδημαϊκό έτος 2025-2026. Δικαίωμα υποβολής αίτησης έχουν απόφοιτοι της Ριζάρειου Σχολής που σπουδάζουν σε ανώτατα εκπαιδευτικά ιδρύματα. Προθεσμία υποβολής: 30 Απριλίου 2025.',
    'EARES announces scholarships for students for the academic year 2025-2026. Rizareios School graduates studying at higher education institutions are eligible. Deadline: April 30, 2025.',
    'Ανακοίνωση απονομής υποτροφιών σε σπουδαστές για το ακαδημαϊκό έτος 2025-2026.',
    'Scholarships announcement for academic year 2025-2026.',
    '2024-12-28',
    5,
    'img/gallery-img-06.jpg'
);
