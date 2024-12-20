create database cdkey_db;
use cdkey_db; -- use the database

-- Disable foreign key checks to allow dropping tables with dependencies
SET FOREIGN_KEY_CHECKS = 0;

-- Drop tables if they exist
drop table if exists transactions;
drop table if exists cd_keys;
drop table if exists promotions;
drop table if exists games;
drop table if exists users;
drop table if exists cart;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- Create the tables
create table games (
    game_id int auto_increment primary key,
    game_title varchar(255) not null,
    game_platform varchar(255) not null,
    cover_art varchar(255) not null,
    genre varchar(255)
);

create table promotions (
    promotion_id int auto_increment primary key,
    game_id int,
    discount_percent decimal(5, 2),
    start_date date,
    end_date date,
    foreign key (game_id) references games(game_id)
);

create table users (
    user_id int auto_increment primary key,
    username varchar(255) not null unique,
    email varchar(255) not null unique,
    password varchar(255) not null,
    user_type enum('buyer', 'seller') not null
);

CREATE TABLE cd_keys (
    key_id INT AUTO_INCREMENT PRIMARY KEY,
    cd_key VARCHAR(255) UNIQUE, -- Each key is unique
    game_id INT NOT NULL,
    seller_id INT,
    buyer_id INT DEFAULT NULL, -- Tracks the user who purchased the key
    price DECIMAL(10, 2) NOT NULL,
    status ENUM('available', 'sold') DEFAULT 'available', -- Tracks availability
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (seller_id) REFERENCES users(user_id),
    FOREIGN KEY (buyer_id) REFERENCES users(user_id) -- Tracks the buyer
);

create table transactions (
    transaction_id int auto_increment primary key,
    buyer_id int not null,
    seller_id int not null,
    cdkey_id int not null,
    game_id int not null,
    price decimal(10, 2),
    transaction_date datetime,
    foreign key (buyer_id) references users(user_id),
    foreign key (seller_id) references users(user_id),
    foreign key (cdkey_id) references cd_keys(key_id),
    foreign key (game_id) references games(game_id)
);

create table cart (
    cart_id int auto_increment primary key,
    user_id int not null,
    cdkey_id int not null,
    quantity int default 1,
    added_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id),
    foreign key (cdkey_id) references cd_keys(key_id)
);

-- Insert data into games
INSERT INTO games (game_title, game_platform, cover_art, genre) 
VALUES 
('Baltro', 'pc', 'baltro.jpg', 'rpg'),
('Days Gone', 'pc', 'days_gone.jpg', 'action rpg'),
('Farming Simulator', 'xbox', 'farming.jpg', 'sandbox'),
('Grand Theft Auto 5', 'ps5', 'gta5.jpg', 'action'),
('Spiderman', 'ps5', 'spider-man.jpg', 'action adventure'),
('Minecraft', 'pc', 'minecraft.jpg', 'sandbox'),
('Stalker 2', 'pc', 'heart_of_chornobyl.jpg', 'survival horror'),
('High on Life', 'xbox', 'high-on-life.jpg', 'shooter'),
('Helldivers 2', 'pc', 'helldivers2.jpg', 'action'),
('Indiana Jones and the Great Circle', 'pc', 'indiana_jones.jpg', 'adventure'),
('Space Marines 2', 'pc', 'space_marines2.jpg', 'action rpg'),
('Hogwarts Legacy', 'ps5', 'hogwarts_legacy.jpg', 'rpg'),
('Cyberpunk 2077', 'pc', 'cyberpunk2077.jpg', 'rpg'),
('Detroit Become Human', 'ps4', 'detroit_become_human.jpg', 'interactive drama'),
('Cities Skylines 2', 'pc', 'cities_skylines2.jpg', 'simulation'),
('Manor Lords', 'pc', 'manor_lords.jpg', 'strategy'),
('Last of Us Part 1', 'pc', 'last_of_us_part1.jpg', 'action adventure'),
('Skyrim Special Edition', 'pc', 'skyrim_special_edition.jpg', 'rpg'),
('Red Dead Redemption 2', 'pc', 'red_dead_redemption2.jpg', 'action adventure'),
('Ready or Not', 'pc', 'ready_or_not.jpg', 'shooter'),
('No Man\'s Sky', 'pc', 'no_mans_sky.jpg', 'exploration');

-- Insert data into users
-- The password is the same as the username for testing purposes
INSERT INTO users (username, email, password, user_type) VALUES ('buyer', 'buyer@example.com', '$2y$10$XUOaR3bQJ5y2cij6bCT0HunA4x.m0QZiDniK4IoRJ8Yk1fcbunIFu', 'buyer');
INSERT INTO users (username, email, password, user_type) VALUES ('seller', 'seller@example.com', '$2y$10$BJz0yVdnGSCqX9jRMA8HSuwcTW3Fv7uVTuYwrjat/KTCi9OZkivyq', 'seller');

-- Insert data into promotions
INSERT INTO promotions (game_id, discount_percent, start_date, end_date) 
VALUES 
(1, 20.00, '2024-12-01', '2024-12-15'),
(2, 15.00, '2024-12-10', '2024-12-25'),
(4, 10.00, '2024-12-20', '2024-12-31');

-- Insert data that is available
INSERT INTO cd_keys (cd_key, game_id, seller_id, price, status) 
VALUES 
('abcd1234', 1, 2, 49.99, 'available'),
('efgh5678', 2, 2, 39.99, 'available'),
('ijkl9101', 3, 2, 29.99, 'available'),
('mnop1121', 4, 2, 19.99, 'available'),
('qrst3141', 5, 2, 59.99, 'available'),
('uvwx5161', 6, 2, 26.99, 'available'),
('yzab7181', 7, 2, 44.99, 'available'),
('cdef9201', 8, 2, 34.99, 'available'),
('ghij1221', 9, 2, 24.99, 'available'),
('klmn3241', 10, 2, 49.99, 'available'),
('opqr5261', 11, 2, 54.99, 'available'),
('stuv7281', 12, 2, 39.99, 'available'),
('wxyz9301', 13, 2, 59.99, 'available'),
('abcd1345', 14, 2, 45.99, 'available'),
('efgh2467', 15, 2, 39.99, 'available');

-- insert data that is sold
INSERT INTO cd_keys (cd_key, game_id, seller_id, buyer_id, price, status)
VALUES
('kzxz1200', 16, 2, 1, 19.99, 'sold'),
('dwcj8347', 17, 2, 1, 19.99, 'sold'),
('sadn8238', 18, 2, 1, 19.99, 'sold'),
('ercl8744', 19, 2, 1, 19.99, 'sold'),
('sdsd1139', 20, 2, 1, 19.99, 'sold'),
('lowm9145', 21, 2, 1, 19.99, 'sold');

INSERT INTO transactions (buyer_id, seller_id, cdkey_id, game_id, price, transaction_date)
VALUES
(1, 2, 1, 16, 19.99, '2024-12-01 10:00:00'),
(1, 2, 2, 17, 19.99, '2024-12-02 11:30:00'),
(1, 2, 3, 18, 19.99, '2024-12-03 12:45:00'),
(1, 2, 4, 19, 19.99, '2024-12-04 14:15:00'),
(1, 2, 5, 20, 19.99, '2024-12-05 15:30:00'),
(1, 2, 6, 21, 19.99, '2024-12-06 16:45:00');

INSERT INTO cart (user_id, cdkey_id, quantity, added_at)
VALUES
(1, 7, 1, '2024-12-01 09:00:00'); -- buyer added cdkey for game 7 to cart