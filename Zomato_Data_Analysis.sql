drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);


select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

--1  What is the total amount each customer spent on Zomato

SELECT USERID,SUM(PRICE) AS TOTAL_AMNT_SPENT
FROM sales JOIN PRODUCT 
ON sales.product_id = product.product_id
GROUP BY USERID 

--2 How many days has each custumer visited zomato?

SELECT USERID,COUNT(DISTINCT CREATED_DATE) AS NUMBER_OF_DAYS_VISITED
FROM sales JOIN PRODUCT 
ON sales.product_id = product.product_id
GROUP BY USERID 

--3 What was the first product purchased by each customer

SELECT * FROM
(SELECT *,RANK() OVER (PARTITION BY USERID ORDER BY CREATED_DATE) AS RNK
FROM sales) A
WHERE RNK=1


--4 What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT USERID,COUNT(PRODUCT_ID) CNT FROM SALES WHERE product_id=
(SELECT TOP 1 product_id
FROM SALES 
GROUP BY product_id
ORDER BY COUNT(PRODUCT_ID) DESC) 
GROUP BY USERID


--5 Which item was most popular among each customer?
SELECT * FROM
(SELECT *,RANK() OVER (PARTITION BY USERID ORDER BY CNT DESC) RNK FROM
(SELECT USERID,product_id,COUNT(product_id) CNT
FROM sales
GROUP BY USERID,product_id) A)B
WHERE RNK=1