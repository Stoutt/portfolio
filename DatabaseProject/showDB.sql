-- File: show.sql 
-- Queries the data dictionary to display the sailorsDB schema objects
-- Author: JRA
-- 
SET ECHO ON
--
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
SET ECHO OFF