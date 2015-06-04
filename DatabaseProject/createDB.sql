SPOOL project.out
SET ECHO ON
/*
CIS 353 - Database Design Project
Brendan Murray
Tyler Stout
Jared Hayward
Steven Miesch 
*/
-- CREATING THE TABLES
-- -----------------------------------------------------------------
CREATE TABLE  Product
(
pNum     INTEGER,
Price    INTEGER   NOT NULL, 
Condition  CHAR(15)     NOT NULL,
Type     CHAR(15) NOT NULL,
-- Contraints go here.
CONSTRAINT pIC1 PRIMARY KEY (pNum),
CONSTRAINT pIC2 CHECK(Condition IN ('New', 'Used', 'Refurbished'))
);
-- ---------------------------------------------------------------
CREATE TABLE  Store
(
sNum     INTEGER,
Location    CHAR(20)   NOT NULL, 
Hours     INTEGER NOT NULL,
-- Contraints go here.
CONSTRAINT sIC1 PRIMARY KEY (sNum),
CONSTRAINT sIC2 CHECK(hours <= 24)
);
-- ---------------------------------------------------------------
CREATE TABLE  Workers
(
eNum    INTEGER,
sNum    INTEGER   NOT NULL, 
Name  CHAR(15)     NOT NULL,
Age   INTEGER   NOT NULL,
JobTitle     CHAR(15) NOT NULL,
-- Contraints go here.
CONSTRAINT wIC1 PRIMARY KEY (eNum),
CONSTRAINT wIC2 FOREIGN KEY(sNum) REFERENCES Store(sNum) ON DELETE SET NULL,
CONSTRAINT wIC3 CHECK(NOT (Age <= 18 AND JobTitle = 'Manager'))
);
--
---------------------------------------------------------------

CREATE TABLE  Orders
(
OrderNum INTEGER,
Enum INTEGER NOT NULL, 
oDate DATE NOT NULL,
SNum     INTEGER NOT NULL,
Type	CHAR(15)	NOT NULL,
Total INTEGER NOT NULL,	
-- Contraints go here.
CONSTRAINT oIC1 PRIMARY KEY (OrderNum),
CONSTRAINT oIC2 FOREIGN KEY(Enum) REFERENCES Workers(eNum) ON DELETE SET NULL,
CONSTRAINT oIC3 FOREIGN KEY(SNum) REFERENCES Store(sNum) ON DELETE SET NULL
);
-- ---------------------------------------------------------------

CREATE TABLE  CD
(
Title CHAR(40),
pNum  INTEGER,
trackNum INTEGER NOT NULL,
-- Contraints go here.
CONSTRAINT cIC1 PRIMARY KEY (Title, pNum)
);
-- ---------------------------------------------------------------
CREATE TABLE CD_genre
(
Genre CHAR(40),
Title    CHAR(50),
-- Contraints go here.
CONSTRAINT gIC1 PRIMARY KEY (Genre, Title)
);
--
---------------------------------------------------------------
CREATE TABLE CD_artist
(
Artist CHAR(40),
Title    CHAR(50),
-- Contraints go here.
CONSTRAINT aIC1 PRIMARY KEY (Artist, Title)
);
--
---------------------------------------------------------------
CREATE TABLE  SellsA
(
sNum     INTEGER,
pNum     INTEGER,
-- Contraints go here.
CONSTRAINT saIC1 PRIMARY KEY (sNum, pNum)
);
--
---------------------------------------------------------------
CREATE TABLE  Contains
(
pNum    INTEGER,
oNum    INTEGER, 
Quantity  INTEGER   NOT NULL,
-- Contraints go here.
CONSTRAINT coIC1 PRIMARY KEY (pNum, oNum),
CONSTRAINT coIC2 CHECK(Quantity <= 5)
);
--
-- ------------------------------------------------------------------
-- POPULATING THE DATABASE INSTANCE
-- --------------------------------------------------------------------
SET FEEDBACK OFF;

INSERT INTO Product VALUES (17652987, 85, 'New', 'Amp');
INSERT INTO Product VALUES (86753098, 150, 'New', 'Guitar');
INSERT INTO Product VALUES (98766665, 340, 'Used', 'Keyboard');
INSERT INTO Product VALUES (88740157, 500, 'Refurbished', 'Guitar');
INSERT INTO Product VALUES (88102385, 10, 'New', 'CD');
INSERT INTO Product VALUES (55201823, 5, 'Used', 'CD');
INSERT INTO Product VALUES (78336924, 18, 'New', 'CD');
INSERT INTO Product VALUES (67942066, 6, 'Used', 'CD');
INSERT INTO Product VALUES (59623748, 22, 'New', 'Merch');
INSERT INTO Product VALUES (18919726, 3, 'New', 'Merch');
-- --------------------------------------------------------------------
INSERT INTO Store VALUES (46874343, 'Grand Rapids', 12);
INSERT INTO Store VALUES (39739739, 'Saint Clair Shores', 10);
INSERT INTO Store VALUES (37287273, 'Saint Clair Shores', 10);
INSERT INTO Store VALUES (67787987, 'Lansing', 11);

INSERT INTO Store VALUES (12310846, 'Grosse Pointe', 9);
INSERT INTO Store VALUES (32133466, 'Saint Clair Shores', 2);
INSERT INTO Store VALUES (40775460, 'Grand Rapids', 8);
INSERT INTO Store VALUES (72727500, 'Detroit', 12);
-- --------------------------------------------------------------------
INSERT INTO Workers VALUES (10234190, 46874343,'Bob',30,'Janitor');
INSERT INTO Workers VALUES (18923719, 39739739, 'Mary', 28, 'Cashier');
INSERT INTO Workers VALUES (63789357, 32133466, 'John', 42, 'Manager');
INSERT INTO Workers VALUES (78934373, 12310846, 'Jane', 23, 'Stocking');
INSERT INTO Workers VALUES (67893345, 40775460, 'Rick', 18, 'Stocking');
INSERT INTO Workers VALUES (23987349, 37287273, 'Joe', 38, 'Manager');
INSERT INTO Workers VALUES (34796932, 67787987, 'Holly', 21, 'Cashier');
INSERT INTO Workers VALUES (87394572, 72727500, 'Nick', 16, 'Cashier');
INSERT INTO Workers VALUES (82348791, 40775460, 'Adam', 35, 'Janitor');
-- --------------------------------------------------------------------
INSERT INTO Orders VALUES (27389239, 18923719, '19-APR-2012', 39739739, 'Purchase', 170);
INSERT INTO Orders VALUES (63458973, 34796932, '12-MAR-2010', 67787987, 'Return', 150);
INSERT INTO Orders VALUES (15728312, 87394572, '02-FEB-2007', 72727500, 'Purchase', 1020);
INSERT INTO Orders VALUES (78956789, 18923719, '08-MAY-2011', 39739739, 'Reserve', 2000);
INSERT INTO Orders VALUES (67728647, 34796932, '29-NOV-2012', 67787987, 'Return', 20);
INSERT INTO Orders VALUES (36751237, 87394572, '10-DEC-2010', 72727500, 'Purchase', 5);
INSERT INTO Orders VALUES (67347893, 87394572, '30-JAN-2007', 72727500, 'Purchase', 54);
INSERT INTO Orders VALUES (92382762, 34796932, '07-SEP-2008', 67787987, 'Reserve', 24);
INSERT INTO Orders VALUES (65748367, 18923719, '11-JUN-2009', 39739739, 'Purchase', 22);
INSERT INTO Orders VALUES (63978367, 18923719, '21-JUL-2011', 39739739, 'Reserve', 6);
INSERT INTO Orders VALUES (76934578, 87394572, '14-AUG-2012', 72727500, 'Purchase', 170);
INSERT INTO Orders VALUES (37286237, 34796932, '22-OCT-2009', 67787987, 'Return', 450);
-- --------------------------------------------------------------------
INSERT INTO CD VALUES ('Toeachizown', 86999333, 22);
INSERT INTO CD VALUES ('DJ Fizzy Fats Greatest Hits', 22765480, 13);
INSERT INTO CD VALUES ('Slimi Island', 88102385, 11);
INSERT INTO CD VALUES ('Flood', 55201823, 15);
INSERT INTO CD VALUES ('800 Cherries', 78336924, 10);
INSERT INTO CD VALUES ('Gymnopedies and Other Satie Classics', 67942066, 17);
INSERT INTO CD VALUES ('Rose Quartz', 50238875, 19);
INSERT INTO CD VALUES ('Jazz et Ragas', 30540054, 5);
INSERT INTO CD VALUES ('Government Alpha', 61472084, 8);
INSERT INTO CD VALUES ('Magic City', 72472358, 3);
-- --------------------------------------------------------------------
INSERT INTO CD_genre VALUES ('Toeachizown', 'Electronic');
INSERT INTO CD_genre VALUES ('DJ Fizzy Fats Greatest Hits', 'Hip-hop');
INSERT INTO CD_genre VALUES ('Slimi Island', 'Rock/Indie');
INSERT INTO CD_genre VALUES ('Flood', 'Metal');
INSERT INTO CD_genre VALUES ('800 Cherries', 'Pop');
INSERT INTO CD_genre VALUES ('Gymnopedies and Other Satie Classics', 'Classical');
INSERT INTO CD_genre VALUES ('Rose Quartz', 'Electronic');
INSERT INTO CD_genre VALUES ('Jazz Et Ragas', 'World/Folk');
INSERT INTO CD_genre VALUES ('Government Alpha', 'Other');
INSERT INTO CD_genre VALUES ('Magic City', 'Jazz');
-- --------------------------------------------------------------------
INSERT INTO CD_artist VALUES ('Toeachizown', 'Dam-Funk');
INSERT INTO CD_artist VALUES ('DJ Fizzy Fats Greatest Hits', 'DJ Fizzy Fats');
INSERT INTO CD_artist VALUES ('Slimi Island', 'Pia Fraus');
INSERT INTO CD_artist VALUES ('Flood', 'Boris');
INSERT INTO CD_artist VALUES ('800 Cherries', '800 Cherries');
INSERT INTO CD_artist VALUES ('Gymnopedies and Other Satie Classics', 'Erik Satei');
INSERT INTO CD_artist VALUES ('Rose Quartz', 'luxury elite');
INSERT INTO CD_artist VALUES ('Jazz Et Ragas', 'Ravi Shankar');
INSERT INTO CD_artist VALUES ('Government Alpha', 'Government Alpha');
INSERT INTO CD_artist VALUES ('Magic City', 'Sun Ra');
-- --------------------------------------------------------------------
INSERT INTO SellsA VALUES (46874343, 86753098);
INSERT INTO SellsA VALUES (46874343, 98766665);
INSERT INTO SellsA VALUES (46874343, 88740157);
INSERT INTO SellsA VALUES (46874343, 88102385);
INSERT INTO SellsA VALUES (46874343, 55201823);
INSERT INTO SellsA VALUES (46874343, 78336924);
INSERT INTO SellsA VALUES (46874343, 67942066);
INSERT INTO SellsA VALUES (46874343, 59623748);
INSERT INTO SellsA VALUES (46874343, 18919726);
--
INSERT INTO SellsA VALUES (39739739, 17652987);
INSERT INTO SellsA VALUES (39739739, 86753098);
INSERT INTO SellsA VALUES (39739739, 98766665);
INSERT INTO SellsA VALUES (39739739, 88740157);
INSERT INTO SellsA VALUES (39739739, 88102385);
INSERT INTO SellsA VALUES (39739739, 55201823);
INSERT INTO SellsA VALUES (39739739, 78336924);
INSERT INTO SellsA VALUES (39739739, 67942066);
INSERT INTO SellsA VALUES (39739739, 59623748);

INSERT INTO SellsA VALUES (39739739, 18919726);
--
INSERT INTO SellsA VALUES (37287273, 17652987);
INSERT INTO SellsA VALUES (37287273, 86753098);
INSERT INTO SellsA VALUES (37287273, 98766665);
INSERT INTO SellsA VALUES (37287273, 88740157);
INSERT INTO SellsA VALUES (37287273, 88102385);
INSERT INTO SellsA VALUES (37287273, 55201823);
INSERT INTO SellsA VALUES (37287273, 78336924);
INSERT INTO SellsA VALUES (37287273, 67942066);
INSERT INTO SellsA VALUES (37287273, 59623748);
INSERT INTO SellsA VALUES (37287273, 18919726);
--
INSERT INTO SellsA VALUES (67787987, 17652987);
INSERT INTO SellsA VALUES (67787987, 86753098);
INSERT INTO SellsA VALUES (67787987, 98766665);
INSERT INTO SellsA VALUES (67787987, 88740157);
INSERT INTO SellsA VALUES (67787987, 88102385);
INSERT INTO SellsA VALUES (67787987, 55201823);
INSERT INTO SellsA VALUES (67787987, 78336924);
INSERT INTO SellsA VALUES (67787987, 67942066);
INSERT INTO SellsA VALUES (67787987, 59623748);
INSERT INTO SellsA VALUES (67787987, 18919726);
--
INSERT INTO SellsA VALUES (12310846, 17652987);
INSERT INTO SellsA VALUES (12310846, 86753098);
INSERT INTO SellsA VALUES (12310846, 98766665);
INSERT INTO SellsA VALUES (12310846, 88740157);
INSERT INTO SellsA VALUES (12310846, 88102385);
INSERT INTO SellsA VALUES (12310846, 55201823);
INSERT INTO SellsA VALUES (12310846, 78336924);
INSERT INTO SellsA VALUES (12310846, 67942066);
INSERT INTO SellsA VALUES (12310846, 59623748);
INSERT INTO SellsA VALUES (12310846, 18919726);
--
INSERT INTO SellsA VALUES (32133466, 17652987);
INSERT INTO SellsA VALUES (32133466, 86753098);
INSERT INTO SellsA VALUES (32133466, 98766665);
INSERT INTO SellsA VALUES (32133466, 88740157);
INSERT INTO SellsA VALUES (32133466, 88102385);
INSERT INTO SellsA VALUES (32133466, 55201823);
INSERT INTO SellsA VALUES (32133466, 78336924);
INSERT INTO SellsA VALUES (32133466, 67942066);
INSERT INTO SellsA VALUES (32133466, 59623748);
INSERT INTO SellsA VALUES (32133466, 18919726);
--
INSERT INTO SellsA VALUES (40775460, 17652987);
INSERT INTO SellsA VALUES (40775460, 86753098);
INSERT INTO SellsA VALUES (40775460, 98766665);
INSERT INTO SellsA VALUES (40775460, 88740157);
INSERT INTO SellsA VALUES (40775460, 88102385);
INSERT INTO SellsA VALUES (40775460, 55201823);
INSERT INTO SellsA VALUES (40775460, 78336924);
INSERT INTO SellsA VALUES (40775460, 67942066);
INSERT INTO SellsA VALUES (40775460, 59623748);
INSERT INTO SellsA VALUES (40775460, 18919726);
--
INSERT INTO SellsA VALUES (72727500, 17652987);
INSERT INTO SellsA VALUES (72727500, 86753098);
INSERT INTO SellsA VALUES (72727500, 98766665);
INSERT INTO SellsA VALUES (72727500, 88740157);
INSERT INTO SellsA VALUES (72727500, 88102385);
INSERT INTO SellsA VALUES (72727500, 55201823);
INSERT INTO SellsA VALUES (72727500, 78336924);
INSERT INTO SellsA VALUES (72727500, 67942066);
INSERT INTO SellsA VALUES (72727500, 59623748);
INSERT INTO SellsA VALUES (72727500, 18919726);
-- --------------------------------------------------------------------
INSERT INTO Contains VALUES (17652987, 27389239, 2);
INSERT INTO Contains VALUES (86753098, 63458973, 1);
INSERT INTO Contains VALUES (98766665, 15728312, 3);
INSERT INTO Contains VALUES (88740157, 78956789, 4);
INSERT INTO Contains VALUES (88102385, 67728647, 2);
INSERT INTO Contains VALUES (55201823, 36751237, 1);
INSERT INTO Contains VALUES (78336924, 67347893, 3);
INSERT INTO Contains VALUES (67942066, 92382762, 4);
INSERT INTO Contains VALUES (59623748, 65748367, 1);
INSERT INTO Contains VALUES (18919726, 63978367, 2);
INSERT INTO Contains VALUES (17652987, 76934578, 2);
INSERT INTO Contains VALUES (86753098, 37286237, 3);

SET FEEDBACK ON;
COMMIT

-- Database instance
SELECT * FROM Product;
SELECT * FROM Store;
SELECT * FROM Workers;
SELECT * FROM Orders;
SELECT * FROM CD;
SELECT * FROM CD_genre;
SELECT * FROM CD_artist;
SELECT * FROM SellsA;
SELECT * FROM Contains;

-- --------------------------------------------------------------------
-- Queries
-- --------------------------------------------------------------------

-- This is a query that joins 5 tables. The purpose is to find every order which contains only a single item. 
-- From there we want to find the number of that order, the product that was sold in the order, the employee
-- who processed that order, the store where that order was made, and the quantity of items in the order. 
--
-- Q1 - 4 Join
SELECT o.OrderNum, p.pNum, s.sNum, w.eNum, c.Quantity
FROM Product p, Store s, Workers w, Orders o, Contains c
WHERE p.price = o.Total AND
s.sNum = w.sNum AND 
s.sNum = o.SNum AND
w.eNum = o.Enum AND
c.pNum = p.pNum AND
c.oNum = o.OrderNum AND
c.Quantity = 1
ORDER BY o.OrderNum;

-- This is a self-join where we check to see if two different employees have the 
-- same job title, and from there we collect both employee's numbers, names, and 
-- job titles. 
--
-- Q2 - Self-join
SELECT DISTINCT w1.eNum, w1.Name, w1.JobTitle, w2.eNum, w2.Name, w2.JobTitle
FROM Workers w1, Workers w2
WHERE w1.JobTitle = w2.JobTitle AND
w1.eNum < w2.eNum;


-- This is a correlated subquery that also implements the MAX function. 
-- It's goal is to find the most expensive product within each product type, 
-- and print that product's number, price, condition, and type.
--
-- Q3 - Correlated subquery
SELECT p1.pNum, p1.Price, p1.Condition, p1.Type
FROM   Product p1
WHERE  p1.Price =
       (SELECT MAX(p2.price)
        FROM   Product p2
        WHERE  p1.Type = p2.Type)
ORDER BY p1.price;


-- This query implements DIVISION and MINUS. 
-- It finds the store number and store location of every store in Grand Rapids 
-- that sells an Amp.
-- 
-- Q4 - Division and Minus
SELECT s.sNum, s.Location
FROM   Store s
WHERE  s.Location = 'Grand Rapids' AND NOT EXISTS (
       (SELECT p.pNum
        FROM   Product p
        WHERE  p.Type = 'Amp')
       MINUS
       (SELECT sa.pNum
        FROM SellsA sa
        WHERE sa.sNum = s.sNum))
ORDER BY s.Location;

-- This non-correlated sub query displays every worker who doesn't work in 
-- Lansing and shows their worker number, name, and the store that they work at.
--
-- Q5 - non-correlated subquery
SELECT W.eNum, W.Name, W.sNum
FROM   Workers W
WHERE  W.eNum NOT IN
       (SELECT W.eNum
        FROM   Workers W, Store S
        WHERE  W.sNum = S.sNum AND S.Location = 'Lansing')
ORDER BY W.Name;

-- This query has GROUP BY, HAVING, and ORDER BY. It finds every store that 
-- has more than 1 employee working at it, and displays the store's number, 
-- location, and the number of employees that work at it.
-- 
-- Q6 - GROUP BY, HAVING, AND ORDER BY
SELECT s.sNum, s.Location, COUNT(*)
FROM   Store s, Workers w
WHERE  w.sNum = s.sNum
GROUP BY s.sNum, s.Location
HAVING COUNT(*) > 1
ORDER BY s.sNum;


-- This is an OUTER JOIN. It displays the employee number, name, order number,
-- and order date. It's purpose is to find every employee that has made an order.
--
-- Q7 - OUTER JOIN
SELECT W.eNum, W.name, O.OrderNum ,O.oDate
FROM Workers W LEFT OUTER JOIN Orders O ON W.eNum = O.eNum



-- --------------------------------------------------------------------
-- Broken Cases for Constraints
-- --------------------------------------------------------------------

-- Testing: pIC1
INSERT INTO Product VALUES (null, 85, 'New', 'Amp');
-- Testing: pIC2
INSERT INTO Product VALUES (27652987, 85, 'Broke', 'Amp');

-- Testing: sIC1
INSERT INTO Store VALUES (null, 'Grand Rapids', 12);
-- Testing: sIC2
INSERT INTO Store VALUES (56874343, 'Grand Rapids', 25);

-- Testing: wIC1
INSERT INTO Workers VALUES (null, 46874343,'Bob',30,'Janitor');
-- Testing: wIC2
INSERT INTO Workers VALUES (30234190, 1,'Bob',30,'Janitor');
-- Testing: wIC3
INSERT INTO Workers VALUES (40234190, 46874343,'Bob',16,'Manager');

-- Testing: oIC1
INSERT INTO Orders VALUES (null, 18923719, '19-APR-2012', 39739739, 'Purchase', 170);
-- Testing: oIC2
INSERT INTO Orders VALUES (37389239, 1, '19-APR-2012', 39739739, 'Purchase', 170);
-- Testing: oIC3
INSERT INTO Orders VALUES (47389239, 18923719, '19-APR-2012', 3, 'Purchase', 170);


-- Testing: cIC1
INSERT INTO CD VALUES (null, 66999333, 22);
-- Testing: cIC1
INSERT INTO CD VALUES ('Roeachizown', null, 22);


-- Testing: gIC1
INSERT INTO CD_genre VALUES (null, 'Plectronic');
-- Testing: gIC1
INSERT INTO CD_genre VALUES ('Xoeachizown', null);

-- Testing: aIC1
INSERT INTO CD_artist VALUES (null, 'Ram-Funk');
-- Testing: aIC1
INSERT INTO CD_artist VALUES ('Goeachizown', null);

-- Testing: saIC1
INSERT INTO SellsA VALUES (null, 37652987);
-- Testing: saIC1
INSERT INTO SellsA VALUES (56874343, null);

-- Testing: coIC1
INSERT INTO Contains VALUES (null, 37389239, 2);
-- Testing: coIC1
INSERT INTO Contains VALUES (27652987, null, 2);
-- Testing: coIC2
INSERT INTO Contains VALUES (37652987, 67389239, 6);
-- --------------------------------------------------------------------
-- Now, if no violations were detected, COMMIT all the commands in this file
COMMIT;
SPOOL OFF
