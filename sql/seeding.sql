PROMPT
PROMPT **** start script ****
PROMPT Drop previous tables
PROMPT

DROP TABLE BOOKINGS CASCADE CONSTRAINTS;
DROP TABLE LISTINGS CASCADE CONSTRAINTS;
DROP TABLE REVIEWS CASCADE CONSTRAINTS;
DROP TABLE USERS CASCADE CONSTRAINTS;

--
-- CREATE TABLES, ADD CONSTRAINTS AND RELATIONS BETWEEN THEM 
--

-- LISTINGS
CREATE TABLE LISTINGS
(
    listing_id NUMBER PRIMARY KEY,
    location VARCHAR(50) NOT NULL,
    price_per_night DECIMAL(6,2) NOT NULL
);

-- USERS
CREATE TABLE USERS (
    user_id NUMBER PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    phone_number VARCHAR(20) NOT NULL
);

-- BOOKINGS
CREATE TABLE BOOKINGS (
    booking_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    listing_id NUMBER NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    
    CONSTRAINT check_dates CHECK (end_date > start_date) -- dates validation
);

-- REVIEWS
CREATE TABLE REVIEWS (
    review_id NUMBER PRIMARY KEY,
    user_id NUMBER NOT NULL,
    listing_id NUMBER NOT NULL,
    rating NUMBER NOT NULL CHECK(rating BETWEEN 1 AND 5),
    review_comment VARCHAR2(500)
);

-- ADD FK CONSTRAINTS
ALTER TABLE BOOKINGS
ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES USERS(user_id);

ALTER TABLE BOOKINGS
ADD CONSTRAINT fk_listing FOREIGN KEY (listing_id) REFERENCES LISTINGS(listing_id);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_user_review FOREIGN KEY (user_id) REFERENCES USERS(user_id);

ALTER TABLE REVIEWS
ADD CONSTRAINT fk_listing_review FOREIGN KEY (listing_id) REFERENCES LISTINGS(listing_id);

PROMPT
PROMPT Done creating tables
PROMPT
PROMPT ------------------------------;
PROMPT

--
--  ADD ENTRIES FOR EACH TABLE
--

PROMPT
PROMPT Add users
PROMPT

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (1, 'Andrei Popescu', 'andrei.popescu@example.com', '+40740000001');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (2, 'Ioana Ionescu', 'ioana.ionescu@example.com', '+40740000002');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (3, 'Mihai Dumitrescu', 'mihai.dumitrescu@example.com', '+40740000003');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (4, 'Ana Georgescu', 'ana.georgescu@example.com', '+40740000004');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (5, 'Raluca Marinescu', 'raluca.marinescu@example.com', '+40740000005');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (6, 'Vlad Stan', 'vlad.stan@example.com', '+40740000006');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (7, 'Elena Petrescu', 'elena.petrescu@example.com', '+40740000007');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (8, 'George Avram', 'george.avram@example.com', '+40740000008');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (9, 'Cătălina Mihailescu', 'catalina.mihailescu@example.com', '+40740000009');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (10, 'Florin Enache', 'florin.enache@example.com', '+40740000010');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (11, 'Alina Dobrescu', 'alina.dobrescu@example.com', '+40740000011');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (12, 'Victor Grigore', 'victor.grigore@example.com', '+40740000012');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (13, 'Oana Neagu', 'oana.neagu@example.com', '+40740000013');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (14, 'Liviu Dobre', 'liviu.dobre@example.com', '+40740000014');

INSERT INTO USERS (user_id, name, email, phone_number)
VALUES (15, 'Gabriela Rusu', 'gabriela.rusu@example.com', '+40740000015');


COMMIT;
PROMPT
PROMPT Done
PROMPT

PROMPT
PROMPT Add listings
PROMPT

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (1, 'București', 150);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (2, 'Brașov', 200);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (3, 'Cluj-Napoca', 180);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (4, 'Sibiu', 170);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (5, 'Timișoara', 160);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (6, 'Iași', 140);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (7, 'Constanța', 210);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (8, 'Oradea', 190);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (9, 'Sinaia', 230);

INSERT INTO LISTINGS (listing_id, location, price_per_night)
VALUES (10, 'Piatra Neamț', 150);

COMMIT;

PROMPT
PROMPT Done
PROMPT

PROMPT
PROMPT Add bookings
PROMPT

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (1, 1, 3, date '2024-12-01', date '2024-12-05', 600);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (2, 3, 1, date '2024-12-10', date '2024-12-15', 900);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (3, 2, 5, date '2024-12-20', date '2024-12-23', 480);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (4, 5, 7, date '2024-12-02', date '2024-12-06', 800);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (5, 6, 4, date '2024-12-08', date '2024-12-12', 1050);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (6, 7, 6, date '2024-12-01', date '2024-12-04', 510);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (7, 4, 8, date '2024-12-15', date '2024-12-20', 950);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (8, 9, 2, date '2024-12-05', date '2024-12-09', 560);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (9, 10, 10, date '2024-12-18', date '2024-12-22', 600);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (10, 11, 3, date '2024-12-14', date '2024-12-16', 460);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (11, 12, 4, date '2024-12-20', date '2024-12-25', 900);

INSERT INTO BOOKINGS (booking_id, user_id, listing_id, start_date, end_date, total_price)
VALUES (12, 13, 9, date '2024-12-27', date '2024-12-31', 1200);

COMMIT;

PROMPT
PROMPT Add done
PROMPT

PROMPT
PROMPT Add reviews
PROMPT

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (1, 3, 1, 5, 'Excelentă locație și servicii.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (2, 2, 4, 4, 'Foarte frumos, dar un pic scump.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (3, 4, 5, 5, 'Un loc minunat pentru relaxare.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (4, 6, 2, 3, 'Locația este ok, dar camerele sunt mici.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (5, 7, 6, 5, 'Vacanță de vis!');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (6, 8, 7, 4, 'Personal amabil și peisaje frumoase.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (7, 10, 8, 5, 'Merită fiecare bănuț.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (8, 9, 3, 4, 'Condiții bune, dar ar putea fi mai curate.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (9, 11, 10, 5, 'Perfect pentru un weekend liniștit.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (10, 12, 9, 3, 'Cam zgomotos.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (11, 13, 2, 5, 'Recomand cu încredere.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (12, 14, 5, 4, 'Un sejur plăcut.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (13, 15, 4, 5, 'Locul nostru preferat.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (14, 5, 6, 4, 'Foarte frumos, dar drumurile până aici sunt proaste.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (15, 3, 7, 4, 'Totul ok, dar mâncarea nu a fost grozavă.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (16, 6, 8, 5, 'Vedere extraordinară.');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (17, 8, 3, 5, 'Superb!');

INSERT INTO REVIEWS (review_id, user_id, listing_id, rating, review_comment)
VALUES (18, 7, 9, 5, 'Ne-a plăcut foarte mult.');

COMMIT;

PROMPT
PROMPT Done
PROMPT

PROMPT
PROMPT Done adding entries
PROMPT
PROMPT ------------------------------;
PROMPT