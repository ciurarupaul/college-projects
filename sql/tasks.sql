-- 
-- UPDATE ENTRIES
-- 

-- UPDATE
UPDATE LISTINGS
SET price_per_night = 220
WHERE listing_id = 2;

UPDATE USERS
SET phone_number = '+40741112222'
WHERE user_id = 2;

UPDATE REVIEWS
SET rating = 5
WHERE review_id = 2;

-- DELETE
DELETE FROM BOOKINGS
WHERE booking_id = 5;

DELETE FROM REVIEWS
WHERE review_id = 3;

DELETE FROM BOOKINGS
WHERE total_price < 500;

ROLLBACK;


-- 
-- SELECT queries
-- 
-- operatori de comparatie

SELECT * 
FROM bookings 
WHERE end_date - start_date > 3;

SELECT * 
FROM listings 
WHERE price_per_night > 150;

SELECT * 
FROM users 
WHERE (SELECT COUNT(*) FROM reviews WHERE reviews.user_id = users.user_id) > 1;

-- join-uri
SELECT b.booking_id, b.start_date, b.end_date, u.name
FROM bookings b
JOIN users u
ON b.user_id = u.user_id;

SELECT DISTINCT l.listing_id, l.price_per_night, l.location
FROM listings l
JOIN reviews r
ON l.listing_id = r.listing_id;

SELECT r.review_id, r.rating, r.review_comment, l.price_per_night AS listing_price, u.name AS reviewer_name
FROM reviews r
JOIN listings l
ON r.listing_id = l.listing_id
JOIN users u
ON r.user_id = u.user_id;

-- funcții de grup și condiții asupra acestora
-- cazări cu un rating minim de n
SELECT l.listing_id, l.price_per_night, l.location, AVG(r.rating) AS avg_rating, COUNT(r.review_id) AS review_count
FROM listings l
JOIN reviews r
ON l.listing_id = r.listing_id
GROUP BY l.listing_id, l.price_per_night, l.location
HAVING AVG(r.rating) > 4;

-- useri cu minim n rezervări (>= 1 din cauza lipsei datelor)
SELECT u.user_id, u.name, COUNT(b.booking_id) AS total_bookings
FROM users u
JOIN bookings b
ON u.user_id = b.user_id
GROUP BY u.user_id, u.name
HAVING COUNT(b.booking_id) >= 1;

-- locatii cu minim n cazari (>= 1 din cauza lipsei datelor)
SELECT l.location, COUNT(l.listing_id) AS total_listings
FROM listings l
GROUP BY l.location
HAVING COUNT(l.listing_id) >= 1;

-- functii numerice, de tip caracter, pentru dată și timp
-- prețul mediu al unei rezervari
SELECT ROUND(AVG(b.total_price), 2) AS average_revenue_per_booking
FROM bookings b;

-- rezervările cu anul și luna
SELECT b.booking_id, u.name, EXTRACT(YEAR FROM b.start_date) AS booking_year, EXTRACT(MONTH FROM b.start_date) AS booking_month
FROM bookings b
JOIN users u
ON b.user_id = u.user_id;

-- locațiile cu prețul aferent ca și text
SELECT l.listing_id, l.location, TO_CHAR(l.price_per_night, '9999.99') || ' € per night' AS formatted_price
FROM listings l
ORDER BY formatted_price DESC;

-- DECODE și CASE
-- încadrare locație în categorie de preț
SELECT listing_id, 
       CASE 
           WHEN price_per_night < 150 THEN 'Affordable'
           WHEN price_per_night BETWEEN 150 AND 200 THEN 'Moderate'
           ELSE 'Expensive'
       END AS category
FROM listings;

-- clasificare în funcție de dată
SELECT booking_id, end_date,
       CASE 
           WHEN end_date < TO_DATE('2024-12-16', 'YYYY-MM-DD') THEN 'Completed'
           WHEN start_date < TO_DATE('2024-12-16', 'YYYY-MM-DD') AND end_date > TO_DATE('2024-12-16', 'YYYY-MM-DD') THEN 'In progress'
           WHEN start_date > TO_DATE('2024-12-16', 'YYYY-MM-DD') THEN 'Upcoming'
           ELSE 'Unknown'
       END AS status
FROM bookings
ORDER BY status DESC;

-- la fel dar cu DECODE
SELECT booking_id, end_date,
       DECODE(
           SIGN(end_date - TO_DATE('2024-12-16', 'YYYY-MM-DD')), 
           1, 'Completed', 
           0, 'In progress', 
           -1, 'Upcoming', 
           'Unknown') AS status
FROM bookings
WHERE start_date <= TO_DATE('2024-12-16', 'YYYY-MM-DD')
   OR end_date >= TO_DATE('2024-12-16', 'YYYY-MM-DD')
ORDER BY status DESC;

-- UNION, MINUS, INTERSECT
-- useri care au facut rezervări și au lăsat review-uri
SELECT user_id, listing_id
FROM bookings
UNION
SELECT user_id, listing_id
FROM reviews;

-- useri care au făcut rezervări, dar nu au lăsat review-uri
SELECT user_id, listing_id
FROM bookings
MINUS
SELECT user_id, listing_id
FROM reviews;

-- useri care au rezervat și oferit review unei locații
SELECT user_id, listing_id
FROM bookings
INTERSECT
SELECT user_id, listing_id
FROM reviews;

-- cereri imbricate
-- locatii care au review-uri de la userii care le-au rezervat
SELECT listing_id
FROM listings
WHERE listing_id IN (
    SELECT DISTINCT listing_id
    FROM reviews
    WHERE user_id IN (
        SELECT DISTINCT user_id
        FROM bookings
    )
);

-- locațiile cu rating-ul mediu
SELECT listing_id, location,
       (SELECT AVG(rating) 
        FROM reviews 
        WHERE reviews.listing_id = listings.listing_id) AS average_rating
FROM listings;

-- locații cu mai multe review-uri decat media
SELECT listing_id, COUNT(review_id) AS review_count
FROM reviews
GROUP BY listing_id
HAVING COUNT(review_id) > (
    SELECT AVG(review_count)
    FROM (
        SELECT COUNT(review_id) AS review_count
        FROM reviews
        GROUP BY listing_id
    )
);

-- 
-- VIEWS, INDEXES, SYNONYMS, SEQUENCES
-- 
-- views
CREATE VIEW upcoming_bookings AS
SELECT booking_id, user_id, listing_id, start_date, end_date
FROM BOOKINGS
WHERE start_date > SYSDATE;

CREATE VIEW bookings_details AS
SELECT b.booking_id, u.name, l.location, b.start_date, b.end_date
FROM BOOKINGS b
INNER JOIN USERS u ON b.user_id = u.user_id
INNER JOIN LISTINGS l ON b.listing_id = l.listing_id;

-- indexes
CREATE INDEX idx_price
ON LISTINGS(price_per_night);

CREATE INDEX idx_dates
ON BOOKINGS(start_date, end_date);

-- synonyms
CREATE SYNONYM listings_table
FOR listings;

CREATE SYNONYM active_view
FOR upcoming_bookings;

-- sequences
CREATE SEQUENCE booking_sequence
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- drop and restore table
DROP TABLE LISTINGS;
FLASHBACK TABLE LISTINGS TO BEFORE DROP;

