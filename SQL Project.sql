/*
SQL Mini Project
Part - A	
ICC Test Cricket
Dataset: ICC Test Batting Figures.csv
Test cricket is the form of the sport of cricket with the longest match duration and is considered the game's highest standard. Test matches are played between national representative teams that have been granted ‘Test status’, as determined and conferred by the International Cricket Council (ICC). The term Test stems from the fact that the long, gruelling matches are mentally and physically testing. Two teams of 11 players each play a four-innings match, which may last up to five days (or longer in some historical cases). It is generally considered the most complete examination of a team's endurance and ability.
The Data consists of runs scored by the batsmen from 1877 to 2019 December.
Data Dictionary:
Sl No	Column Name  	 Column Description
1	    Player	         Name of the player and country the player belongs to
2	    Span	         The duration of years between which the player was active 
3	    Mat	             No of matches played by the player
4	    Inn	             No of innings played by the player
5	    NO	             No of matches the player was NOT OUT by the end of the match.
6	    Runs	         Total number of runs scored by the player
7	    HS	             Highest Score of the player
8	    Avg              Average runs scored by the player in all the matches
9	    100          	 No of centuries scored by the player
10	    50           	 No of fifties scored by the player
11	    0	             No of Duck outs of the player
12	    Player Profile	 Link to the profiles of the players


Tasks to be performed: */

set sql_safe_updates=0;
Create database mp;
use mp;
select * from icctest;

#1.	Import the csv file to a table in the database.
#Soln:  Imported using the table data import wizard and named the table as 'icctest'

#2.	Remove the column 'Player Profile' from the table.
alter table icctest
drop column `Player Profile`;

select * from icctest;

#3.	Extract the country name and player names from the given data and store it in separate columns for further usage.

alter table icctest
add (Player_name text(10),Country_name text(10));
update icctest
set Player_name=(select trim(substring_index(Player,'(',1)));
update icctest
set Country_name=replace(substring(player, instr(trim(player),'(')+1) , ')','');
select * from icctest;

#4.	From the column 'Span' extract the start_year and end_year and store them in separate columns for further usage.

alter table icctest
add (start_year text(10),end_year text(10));

update icctest
set start_year=substring(span,1,4),
end_year=substring(span,6,4);

select * from icctest;

#5.	The column 'HS' has the highest score scored by the player so far in any given match. The column also has details if the player had completed the match in a NOT OUT status. Extract the data and store the highest runs and the NOT OUT status in different columns.

alter table icctest
add (highest_runs text(10),not_out text(10));
update icctest
set highest_runs=(select trim(substring_index(HS,'*',1)));
update icctest
set not_out=(select HS where HS like '%*');
select * from icctest;


#6.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for India.

update icctest
set average= null where average='-' ;
alter table icctest
modify average double;
select player,average,span from icctest where player like '%INDIA)' and  end_year>=2019 order by average desc limit 6;

#7.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have the highest number of 100s across all matches for India.

update icctest
set hundred= null where hundred='-' ;
alter table icctest
modify hundred int;
select player,hundred,span from icctest where player like '%INDIA)' and  end_year>=2019 order by hundred desc limit 6;

#8.	Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using 2 selection criteria of your own for India.

select player,hundred,average,span,mat from icctest where player like '%INDIA)' and  end_year>=2019  and average>30 and mat>35 order by hundred  desc limit 6;

#9.	Create a View named ‘Batting_Order_GoodAvgScorers_SA’ using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have a good average score across all matches for South Africa.

create view Batting_Order_GoodAvgScorers_SA as select player,average,span from icctest where player like '%SA)' and  end_year>=2019 order by average desc limit 6;
select * from Batting_Order_GoodAvgScorers_SA;

#10.Create a View named ‘Batting_Order_HighestCenturyScorers_SA’ Using the data given, considering the players who were active in the year of 2019, create a set of batting order of best 6 players using the selection criteria of those who have highest number of 100s across all matches for South Africa.

create view Batting_Order_HighestCenturyScorers_SA as select player,hundred,span from icctest where player like '%SA)' and  end_year>=2019 order by hundred desc limit 6;
select * from Batting_Order_HighestCenturyScorers_SA;

#11.Using the data given, Give the number of players played for each country.
select country_name,count(*) as No_of_players from icctest group by country_name;

#12.Using the data given, Give the number of player_played for Asian and Non-Asian continent

select player_name, country_name,
case
when country_name = 'INDIA'  then 'Asian continent'
when country_name = 'PAK'  then 'Asian continent'
when country_name = 'SL'  then 'Asian continent'
when country_name = 'AFG'  then 'Asian continent'
when country_name = 'BDESH'  then 'Asian continent'
when country_name = 'ICC/INDIA'  then 'Asian continent'
when country_name = 'ICC/PAK'  then 'Asian continent'
when country_name = 'ICC/SL'  then 'Asian continent'
else 'Non-Asian continent'
end as 'Asian/Non-Asian'
from icctest;

/* Part – B

“Richard’s Supply” is a company which deals with different food products. 
The company is associated with a pool of suppliers. Every Supplier supplies different types of food products
to Richard’s supply. This company also receives orders for the food products from various customers. 
Each order may have multiple products mentioned along with the quantity. The company has been maintaining the 
database for 2 years. */

## Tasks to be performed:

/*1.Company sells the product at different discounted rates. Refer actual product price in product table and selling price in the order 
item table. Write a query to find out total amount saved in each order then display the orders from highest to lowest amount saved. */

select o.Id as Order_Id, p.Id as Product_Id, o.TotalAmount, p.Unitprice, oi.Quantity, o.TotalAmount - (p.Unitprice * oi.Quantity) as SavedAmount 
from product p
join orderitem oi on oi.ProductId = p.Id
join orders o on oi.orderid = o.id
order by o.Id;


/*2.	Mr. Kavin want to become a supplier. He got the database of "Richard's Supply" for reference. Help him to pick: 
a. List few products that he should choose based on demand.
b. Who will be the competitors for him for the products suggested in above questions.*/

#a. List few products that he should choose based on demand.

SELECT ProductName, SUM(Quantity) AS TotalQuantity
FROM orderitem oi
JOIN product p ON oi.ProductId = p.Id
where IsDiscontinued=0
GROUP BY ProductName
ORDER BY TotalQuantity DESC
LIMIT 5;

#b. Who will be the competitors for him for the products suggested in above questions.

SELECT CompanyName
FROM supplier s
JOIN (
    SELECT p.SupplierId, SUM(oi.Quantity) AS TotalQuantity
    FROM orderitem oi
    JOIN product p ON oi.ProductId = p.Id
    WHERE p.IsDiscontinued = 0
    GROUP BY p.SupplierId
    ORDER BY TotalQuantity DESC
    LIMIT 5
) top_products ON s.Id = top_products.SupplierId;

/*3.	Create a combined list to display customers and suppliers details considering the following criteria 
●	Both customer and supplier belong to the same country
●	Customer who does not have supplier in their country
●	Supplier who does not have customer in their country*/

SELECT 'Customer' AS Type, c.Id, c.FirstName, c.LastName, c.City, c.Country, c.Phone
FROM customer c
WHERE c.Country NOT IN (
    SELECT DISTINCT s.Country
    FROM supplier s
) 

UNION

SELECT 'Supplier' AS Type, s.Id, s.CompanyName, NULL, s.City, s.Country, s.Phone
FROM supplier s
WHERE s.Country NOT IN (
    SELECT DISTINCT c.Country
    FROM customer c
);

/*4.	Every supplier supplies specific products to the customers. Create a view of suppliers and total sales made by their products and 
write a query on this view to find out top 2 suppliers (using windows function) in each country by total sales done by the products.*/

CREATE VIEW supplier_sales_view AS
SELECT s.Id AS SupplierId, s.CompanyName, s.Country, SUM(oi.UnitPrice * oi.Quantity) AS TotalSales
FROM supplier s
JOIN product p ON s.Id = p.SupplierId
JOIN orderitem oi ON p.Id = oi.ProductId
GROUP BY s.Id, s.CompanyName, s.Country;
SELECT SupplierId, CompanyName, Country, TotalSales
FROM (
    SELECT SupplierId, CompanyName, Country, TotalSales,
        ROW_NUMBER() OVER (PARTITION BY Country ORDER BY TotalSales DESC) AS rn
    FROM supplier_sales_view
) subquery
WHERE rn <= 2;

/*5.	Find out for which products, UK is dependent on other countries for the supply. List the countries which are supplying these 
products in the same list.*/

select productname, s.country as supplying_country from product p join supplier s 
on s.id=p.id join customer c on c.id=s.id where c.country='UK' and s.country!='UK';
