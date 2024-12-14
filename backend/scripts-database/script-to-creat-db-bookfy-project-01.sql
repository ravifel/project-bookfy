-- PostgreSQL database dump
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET default_tablespace = '';
SET default_with_oids = false;

-- Step 3: drop tables if exists
DROP TABLE IF EXISTS transaction_log;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS credit_card;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS subcategory;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS product_reviews;
DROP TABLE IF EXISTS store_reviews;
DROP TABLE IF EXISTS product_comments;
DROP TABLE IF EXISTS store_comments;
DROP TABLE IF EXISTS likes;


-- Step 4: Create main tables

-- Table: category
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR
);

-- Table: subcategory
CREATE TABLE subcategory (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    category_id INTEGER REFERENCES category(id)
);

-- Table: users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    cpf VARCHAR(11) UNIQUE,
    email VARCHAR(255) UNIQUE,
    telephone VARCHAR(20),
    birthday DATE,
    password VARCHAR,
    user_type VARCHAR(20),
    profile_picture VARCHAR,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: address
CREATE TABLE address (
    id SERIAL PRIMARY KEY,
    street VARCHAR,
    district VARCHAR,
    city VARCHAR,
    state VARCHAR(50),
    zip_code VARCHAR(10),
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: store
CREATE TABLE store (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    biography TEXT,
    profile_picture VARCHAR,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: products
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    stock_quantity INT,
    description TEXT,
    sub_category_id INTEGER REFERENCES subcategory(id),
    store_id INTEGER REFERENCES store(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,
    cart_id INTEGER REFERENCES cart(id),
    product_id INTEGER REFERENCES products(id),
    quantity INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    total_price NUMERIC(10,2),
    status VARCHAR(20),  -- "pending", "completed", "shipped", etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    quantity INT,
    price NUMERIC(10,2)
);

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    payment_method VARCHAR(50),  -- "credit_card", "debit_card", "pix", etc.
    payment_status VARCHAR(20),  -- "pending", "paid", "failed"
    amount NUMERIC(10,2),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE credit_card (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    card_number VARCHAR(20),
    expiration_date DATE,
    cardholder_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE services (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price NUMERIC(10,2)
);

CREATE TABLE subscriptions (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    service_id INTEGER REFERENCES services(id),  -- Reference to the service the user is subscribing to
    start_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    end_date TIMESTAMP,
    status VARCHAR(20)  -- "active", "inactive", "cancelled"
);

CREATE TABLE transaction_log (
    id SERIAL PRIMARY KEY,
    payment_id INTEGER REFERENCES payments(id),
    transaction_type VARCHAR(50),  -- "charge", "refund", "dispute"
    amount NUMERIC(10,2),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: product_reviews
CREATE TABLE product_reviews (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    user_id INTEGER REFERENCES users(id),
    rating NUMERIC(2,1) CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: store_reviews
CREATE TABLE store_reviews (
    id SERIAL PRIMARY KEY,
    store_id INTEGER REFERENCES store(id),
    user_id INTEGER REFERENCES users(id),
    rating NUMERIC(2,1) CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: product_comments
CREATE TABLE product_comments (
    id SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(id),
    user_id INTEGER REFERENCES users(id),
    comment_text TEXT,
    parent_comment_id INTEGER REFERENCES product_comments(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: store_comments
CREATE TABLE store_comments (
    id SERIAL PRIMARY KEY,
    store_id INTEGER REFERENCES store(id),
    user_id INTEGER REFERENCES users(id),
    comment_text TEXT,
    parent_comment_id INTEGER REFERENCES store_comments(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: likes
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    entity_type VARCHAR(20) CHECK (entity_type IN ('product_review', 'store_review', 'product_comment', 'store_comment')),
    entity_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);





-- Data Insertion

-- Inserting into category
INSERT INTO category (name, description) VALUES
('Fiction', 'Novels and stories from various genres'),
('Non-Fiction', 'Educational and informational books'),
('Science', 'Books about scientific topics and discoveries'),
('Fantasy', 'Books featuring magical and fantastical elements'),
('Mystery', 'Thrilling stories with suspense and intrigue');

-- Inserting into subcategory
INSERT INTO subcategory (name, category_id) VALUES
('Classic Literature', 1),
('Biographies', 2),
('Physics', 3),
('Epic Fantasy', 4),
('Detective Novels', 5);

-- Inserting into users
INSERT INTO users (name, cpf, email, telephone, birthday, password, user_type, profile_picture) VALUES
('Arthur Clark', '12345678901', 'arthur.clark@example.com', '+44 20 7946 1111', '1978-02-15', 'password123', 'buyer', 'arthur_clark.jpg'),
('Diana Evans', '23456789012', 'diana.evans@example.com', '+44 20 7946 1112', '1985-05-20', 'password456', 'seller', 'diana_evans.jpg'),
('Edward Green', '34567890123', 'edward.green@example.com', '+44 20 7946 1113', '1990-08-25', 'password789', 'buyer', 'edward_green.jpg'),
('Fiona Harris', '45678901234', 'fiona.harris@example.com', '+44 20 7946 1114', '1982-10-30', 'password321', 'admin', 'fiona_harris.jpg'),
('George Martin', '56789012345', 'george.martin@example.com', '+44 20 7946 1115', '1995-12-10', 'password654', 'seller', 'george_martin.jpg');

-- Inserting into address
INSERT INTO address (street, district, city, state, zip_code, user_id) VALUES
('10 Oxford Street', 'Westminster', 'London', 'Greater London', 'W1D 1NB', 1),
('25 Piccadilly', 'Mayfair', 'London', 'Greater London', 'W1J 0BF', 2),
('50 Kings Road', 'Chelsea', 'London', 'Greater London', 'SW3 4UD', 3),
('75 Baker Street', 'Marylebone', 'London', 'Greater London', 'NW1 5RT', 4),
('100 Fleet Street', 'City of London', 'London', 'Greater London', 'EC4A 2AE', 5);

-- Inserting into store
INSERT INTO store (name, biography, profile_picture, user_id) VALUES
('Classic Reads', 'A collection of timeless literary classics.', 'classic_reads.jpg', 2),
('Biographical Corner', 'Explore the lives of extraordinary individuals.', 'biographical_corner.jpg', 5),
('Scientific Insights', 'Your source for science and discovery.', 'scientific_insights.jpg', 4),
('Fantasy Worlds', 'Dive into magical and epic adventures.', 'fantasy_worlds.jpg', 2),
('Mystery Haven', 'Suspenseful tales to keep you on edge.', 'mystery_haven.jpg', 5);

-- Inserting into products
INSERT INTO products (name, price, stock_quantity, description, sub_category_id, store_id) VALUES
('Pride and Prejudice', 9.99, 50, 'A classic romance novel by Jane Austen.', 1, 1),
('The Diary of Anne Frank', 14.99, 40, 'A touching account of a young girls life during WWII.', 2, 2),
('A Brief History of Time', 19.99, 30, 'Stephen Hawkings exploration of the universe.', 3, 3),
('The Hobbit', 12.99, 25, 'J.R.R. Tolkiens prelude to The Lord of the Rings.', 4, 4),
('Sherlock Holmes: The Complete Stories', 24.99, 20, 'Arthur Conan Doyles iconic detective tales.', 5, 5);

-- Inserting into cart
INSERT INTO cart (user_id) VALUES
(1),
(2),
(3),
(4),
(5);

-- Inserting into cart_items
INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 2),
(1, 3, 1),
(2, 2, 1),
(3, 5, 1),
(4, 4, 1);

-- Inserting into orders
INSERT INTO orders (user_id, total_price, status) VALUES
(1, 29.97, 'completed'),
(2, 14.99, 'pending'),
(3, 24.99, 'completed'),
(4, 12.99, 'shipped'),
(5, 19.99, 'completed');

-- Inserting into order_items
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 9.99),
(1, 3, 1, 19.99),
(2, 2, 1, 14.99),
(3, 5, 1, 24.99),
(4, 4, 1, 12.99);

-- Inserting into payments
INSERT INTO payments (order_id, payment_method, payment_status, amount) VALUES
(1, 'credit_card', 'paid', 29.97),
(2, 'paypal', 'pending', 14.99),
(3, 'debit_card', 'paid', 24.99),
(4, 'credit_card', 'paid', 12.99),
(5, 'paypal', 'paid', 19.99);

-- Inserting into credit_card
INSERT INTO credit_card (user_id, card_number, expiration_date, cardholder_name) VALUES
(1, '1111222233334444', '2025-05-01', 'Arthur Clark'),
(2, '5555666677778888', '2026-07-01', 'Diana Evans'),
(3, '9999000011112222', '2024-11-01', 'Edward Green'),
(4, '3333444455556666', '2025-12-01', 'Fiona Harris'),
(5, '7777888899990000', '2026-03-01', 'George Martin');

-- Inserting into services
INSERT INTO services (name, description, price) VALUES
('Monthly Classics', 'Access to a new classic book every month.', 9.99),
('Biography Bundle', 'Weekly biographies delivered to your inbox.', 14.99),
('Science Starter Pack', 'A selection of popular science books.', 19.99),
('Fantasy Favourites', 'Handpicked epic fantasy novels.', 12.99),
('Mystery Masterpieces', 'The best of detective and mystery fiction.', 24.99);

-- Inserting into subscriptions
INSERT INTO subscriptions (user_id, service_id, start_date, end_date, status) VALUES
(1, 1, '2024-01-01', '2024-12-31', 'active'),
(2, 2, '2024-02-01', '2024-11-30', 'active'),
(3, 3, '2024-03-01', '2024-09-30', 'inactive'),
(4, 4, '2024-04-01', '2024-10-31', 'cancelled'),
(5, 5, '2024-05-01', '2024-12-31', 'active');

-- Inserting into transaction_log
INSERT INTO transaction_log (payment_id, transaction_type, amount) VALUES
(1, 'charge', 29.97),
(2, 'charge', 14.99),
(3, 'charge', 24.99),
(4, 'charge', 12.99),
(5, 'charge', 19.99);

-- Inserting into product_reviews
INSERT INTO product_reviews (product_id, user_id, rating, review_text) VALUES
(1, 1, 4.5, 'An insightful and well-written book.'),
(2, 2, 5.0, 'Absolutely inspiring! Highly recommend.'),
(3, 3, 3.5, 'Interesting read, but a bit complex.'),
(4, 4, 4.0, 'Enjoyable and engaging storyline.'),
(5, 5, 5.0, 'A masterpiece of detective fiction.');

-- Inserting into store_reviews
INSERT INTO store_reviews (store_id, user_id, rating, review_text) VALUES
(1, 2, 4.0, 'A great collection of books and excellent service.'),
(2, 3, 5.0, 'Impressive store with a unique selection.'),
(3, 4, 3.5, 'Good store but could use more variety.'),
(4, 5, 4.5, 'Loved the theme and the organization of the store.'),
(5, 1, 5.0, 'Fantastic store with an amazing atmosphere.');

-- Inserting into product_comments
INSERT INTO product_comments (product_id, user_id, comment_text, parent_comment_id) VALUES
(1, 1, 'This book really changed my perspective.', NULL),
(1, 2, 'I agree, it is a fantastic read.', 1),
(2, 3, 'Very inspiring story. Everyone should read it.', NULL),
(3, 4, 'I found some parts hard to understand, but overall good.', NULL),
(4, 5, 'A classic that everyone should experience.', NULL);

-- Inserting into store_comments
INSERT INTO store_comments (store_id, user_id, comment_text, parent_comment_id) VALUES
(1, 1, 'Great store with a wonderful selection of classics.', NULL),
(1, 2, 'Thanks for the feedback! We are glad you enjoyed it.', 1),
(2, 3, 'I love the biographies they offer here.', NULL),
(3, 4, 'Could use better organization, but the books are good.', NULL),
(5, 5, 'The mystery section is top-notch!', NULL);

-- Inserting into likes
INSERT INTO likes (user_id, entity_type, entity_id) VALUES
(1, 'product_review', 1),
(2, 'store_review', 1),
(3, 'product_comment', 1),
(4, 'store_comment', 2),
(5, 'product_review', 5);