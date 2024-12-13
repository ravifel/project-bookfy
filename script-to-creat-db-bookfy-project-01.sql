-- Database Creation Script
-- Database Name: bookfy-project-01

-- Step 1: Create the Database
CREATE DATABASE bookfy-project-01;

-- Step 2: Connect to the Database
\c bookfy-project-01;

-- PostgreSQL database dump
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET default_tablespace = '';
SET default_with_oids = false;

--- Step 3: drop tables if exists
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS store;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS subcategory;

-- Step 4: Create main tables

-- Table: category
CREATE TABLE category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
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
    profile_picture VARCHAR
);

-- Table: address
CREATE TABLE address (
    id SERIAL PRIMARY KEY,
    street VARCHAR,
    district VARCHAR,
    city VARCHAR,
    state VARCHAR(50),
    zip_code VARCHAR(10),
    user_id INTEGER REFERENCES users(id)
);

-- Table: store
CREATE TABLE store (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    biography TEXT,
    profile_picture VARCHAR,
    user_id INTEGER REFERENCES users(id)
);

-- Table: products
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC(10,2),
    description TEXT,
    sub_category_id INTEGER REFERENCES subcategory(id),
    store_id INTEGER REFERENCES store(id)
);

-- Inserting Data into Tables

-- Data for the users table
INSERT INTO users (name, cpf, email, telephone, birthday, password, user_type, profile_picture) VALUES
('Oliver Jackson', '12345678901', 'oliver.jackson@example.co.uk', '+44 20 7946 0958', '1985-06-15', 'password123', 'admin', 'oliver.jpg'),
('Amelia Wilson', '98765432100', 'amelia.wilson@example.co.uk', '+44 20 7946 0959', '1990-04-20', 'password456', 'seller', 'amelia.jpg'),
('James Taylor', '19283746500', 'james.taylor@example.co.uk', '+44 20 7946 0960', '1995-12-10', 'password789', 'buyer', 'james.jpg'),
('Isla Moore', '56473829100', 'isla.moore@example.co.uk', '+44 20 7946 0961', '1988-11-05', 'password321', 'buyer', 'isla.jpg'),
('Emily Brown', '10293847560', 'emily.brown@example.co.uk', '+44 20 7946 0962', '1992-09-25', 'password654', 'seller', 'emily.jpg');

-- Data for the address table
INSERT INTO address (street, district, city, state, zip_code, user_id) VALUES
('10 Downing Street', 'Westminster', 'London', 'Greater London', 'SW1A 2AA', 1),
('221B Baker Street', 'Marylebone', 'London', 'Greater London', 'NW1 6XE', 2),
('30 St Mary Axe', 'City of London', 'London', 'Greater London', 'EC3A 8BF', 3),
('1600 Penn Road', 'Reading', 'Reading', 'Berkshire', 'RG1 8AE', 4),
('1 Infinite Loop', 'Cambridge', 'Cambridge', 'Cambridgeshire', 'CB2 1TN', 5);

-- Data for the store table
INSERT INTO store (name, biography, profile_picture, user_id) VALUES
('Book Haven', 'Your destination for literary treasures.', 'book_haven.jpg', 1),
('Readers Paradise', 'A paradise for book enthusiasts.', 'readers_paradise.jpg', 2),
('Storytellers Hub', 'Where stories come to life.', 'storytellers_hub.jpg', 3),
('Page Turners', 'Unveiling the magic of every page.', 'page_turners.jpg', 4),
('Literary Escape', 'Escape into the world of books.', 'literary_escape.jpg', 5);

-- Data for the category table
INSERT INTO category (name) VALUES
('Fiction'),
('Non-Fiction'),
('Science'),
('History'),
('Children');

-- Data for the subcategory table
INSERT INTO subcategory (name, category_id) VALUES
('Fantasy', 1),
('Biography', 2),
('Physics', 3),
('World Wars', 4),
('Picture Books', 5);

-- Data for the products table
INSERT INTO products (name, price, description, sub_category_id, store_id) VALUES
('The Great Adventure', 15.99, 'An epic fantasy journey through mystical lands.', 1, 1),
('Life of a Genius', 20.99, 'An inspiring biography of a world-renowned scientist.', 2, 2),
('Quantum Mechanics Simplified', 35.50, 'A comprehensive guide to understanding quantum mechanics.', 3, 3),
('The Second World War', 25.75, 'A detailed account of World War II.', 4, 4),
('My First ABC', 10.99, 'A colorful picture book for young learners.', 5, 5);