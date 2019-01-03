

use Northwind

/* Selecteer alle klanten (CUSTOMERID, COMPANYNAME) die in London wonen 
en minder dan 5 orders hebben gedaan. Orden het resultaat op aantal geplaatste orders.*/

SELECT  Orders.CustomerID, companyname, count(Orders.CustomerID) as [Order Count] 
FROM Orders
INNER JOIN Customers ON Orders.CustomerID = Customers.CustomerID
WHERE City like 'London'
GROUP BY Orders.CustomerID, CompanyName
HAVING count(Orders.CustomerID)<5 
ORDER BY count(Orders.CustomerID);



/*Opdracht 2.2
Selecteer alle orders voor “Pavlova” met een salesresultaat van minstens 800. */

SELECT ProductID from [Order Details]
Where ProductID IN (Select ProductID from Products where ProductName Like 'Pavlova')
AND;


/*Opdracht 2.3
Selecteer alle regio’s (REGIONDESCRIPTION) waarin het product “Chocolade” is verkocht.*/