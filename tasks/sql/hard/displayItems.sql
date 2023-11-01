-- SQL - Hard

-- Consider the following relational database schema:

-- SELLER (S_id, Name, Bank_acc_no, Email, Phone)
-- STOCKS (S_id, Prod_id, S_Date)
-- PRODUCT (Prod_id, Prod_name, Description, Price, Expiry_date)

-- Create the Following Tables:

CREATE TABLE SELLER (
    -- TODO: Add all the requested fields (S_id, Name, Bank_acc_no, Email, Phone)
    S_id int PRIMARY KEY,
    Name varchar(255) not null,
    Bank_acc_no varchar(50) not null,
    Email varchar(255) not null,
    Phone varchar(100) not null
);

CREATE TABLE PRODUCT (
    -- TODO: Add all the requested fields (Prod_id, Prod_name, Description, Price, Expiry_date)
    Prod_id int PRIMARY KEY,
    Prod_name varchar(255) not null,
    Description varchar(255),
    Price float not null,
    Expiry_date date,
);

CREATE TABLE STOCKS (
    -- TODO: Add all the requested fields (S_id, Prod_id, S_Date)
    S_id int, 
    Prod_id int,
    S_Date date,
    PRIMARY KEY (S_id, Prod_id),
    foreign key (S_id) references SELLER(S_id),
    foreign key (Prod_id) references PRODUCT(Prod_id)
);


-- Insert values into the SELLER table
INSERT INTO SELLER (S_id, Name, Bank_acc_no, Email, Phone)
VALUES
    (1, 'John Doe', '1234567890', 'johndoe@email.com', '555-123-4567'),
    (2, 'Jane Smith', '9876543210', 'janesmith@email.com', '555-987-6543');


-- Insert values into the PRODUCT table
INSERT INTO PRODUCT (Prod_id, Prod_name, Description, Price, Expiry_date)
VALUES
    (101, 'Product A', 'Description for Product A', 25.99, '2023-12-31'),
    (102, 'Product B', 'Description for Product B', 19.99, '2023-11-30'),
    (103, 'Product C', 'Description for Product C', 39.99, '2023-10-15');


-- Insert values into the STOCKS table
INSERT INTO STOCKS (S_id, Prod_id, S_Date)
VALUES
    (1, 101, '2023-01-15'),
    (1, 102, '2023-02-20'),
    (2, 103, '2023-03-10');

-- Display the following :

-- (a) Display name of the sellers and their bank account number who stocked at least 24 different products with price higher than 1000 rupees in the last one year
SELECT S.Name, S.Bank_acc_no
FROM SELLER S
INNER JOIN STOCKS ST ON S.S_id = ST.S_id
INNER JOIN PRODUCT P ON ST.Prod_id = P.Prod_id
WHERE P.Price > 1000 and P.Expiry_date > CURDATE() - INTERVAL 1 YEAR
GROUP BY S.S_id
HAVING COUNT(DISTINCT P.Prod_id) >= 24;

-- (b) Use nested query to display name of the sellers and their email address; who have in stock products with expiry date past today’s date
SELECT S.Name, S.Email
FROM SELLER S
WHERE EXISTS (
    SELECT 1
    FROM STOCKS
    INNER JOIN PRODUCT P ON ST.Prod_id = P.Prod_id
    WHERE ST.S_id = S.S_id AND P.Expiry_date > CURDATE()
);

-- (c) Display the name of the products that are in stock by at least one seller and also those that are not in stock by any of the sellers
SELECT P.Prod_name,
    CASE
        WHEN ST.Prod_id is not null then 'In Stock'
        ELSE 'Not In Stock'
    END AS StockStatus
FROM PRODUCT
LEFT JOIN STOCKS ST ON P.Prod_id = SR.Prod_id;

-- (d) Use join query to display name of the sellers and name of the products stocked by them during March 23, 2020 and June 30, 2020.
SELECT S.Name, S.Prod_name
FROM SELLER S
INNER JOIN STOCKS ST ON S.S_id = ST.S_id
INNER JOIN PRODUCT P ON ST.Prod_id = P.Prod_id
WHERE ST.S_Date BETWEEN '2020-03-23' and '2020-06-30';

-- (e) Display name of sellers who have in stock maximum number of different products and minimum number of different products
SELECT S.Name AS MaxStockedSeller
FROM SELLER S
JOIN STOCKS ST ON S.S_id = ST.S_id
GROUP BY S.S_id
ORDER BY COUNT(DISTINCT ST.Prod_id) DESC
LIMIT 1;

SELECT S.Name AS MinStockedSeller
FROM SELLER S
JOIN STOCKS ST ON S.S_id = ST.S_id
GROUP BY S.S_id
ORDER BY COUNT(DISTINCT ST.Prod_id)
LIMIT 1;


