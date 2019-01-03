

use Northwind
/*Opdracht 2.1
 Selecteer alle klanten (CUSTOMERID, COMPANYNAME) die in London wonen 
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

SELECT *,  Quantity *([Order Details].UnitPrice-Discount) as [Sales Result] from [Order Details]
Where [Order Details].ProductID IN 
(Select ProductID from Products where ProductName Like 'Pavlova')
AND ([Order Details].UnitPrice-Discount)*Quantity >=800
ORDER BY [Sales Result] DESC;


/*Opdracht 2.3
Selecteer alle regio’s (REGIONDESCRIPTION) waarin het product “Chocolade” is verkocht.*/

SELECT RegionDescription from Region 
Where RegionID in
(Select RegionID from Territories Where TerritoryID in 
(Select TerritoryId from EmployeeTerritories where EmployeeID in
(Select EmployeeID  from Employees where EmployeeID in
(Select EmployeeID from Orders where OrderID in
(Select OrderID from [Order Details] where ProductID in
(Select ProductID from Products where Productname like 'Chocolade'))))));

/*Opdracht 2.4
Selecteer alle orders (ORDERID, CUSTOMER.COMPANYNAME) voor het product “Tofu” waar de ‘freight’ kosten tussen 25 en 50 waren.*/
Select OrderID, Customers.Companyname, Freight from Orders
inner join Customers on Orders.CustomerId = Customers.CustomerID
where orderID in
(Select OrderID from [Order Details] where ProductID in (Select ProductID from Products where Productname like 'Tofu'))
AND Freight Between 25 AND 50;


/*Opdracht 2.5
Selecteer de plaatsnamen waarin zowel klanten als werknemers wonen. Gebruik een subquery voor deze opdracht.*/

Select distinct City from Customers 
where city in 
(select city from employees);

/*Opdracht 2.6 
Welke producten (PRODUCTID, PRODUCTNAME) zijn het meest verkocht (aantal) voor Duitse klanten, 
en welke werknemers (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) hebben deze producten verkocht? 
Orden het resultaat op aantal. Toon alleen de top 5 resultaten.*/


SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS TotalQuantity,
E.EmployeeID, E.FirstName, E.LastName, E.Title
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
INNER JOIN  Customers C ON C.CustomerID = O.CustomerID
INNER JOIN Employees E ON E.EmployeeID = O.EmployeeID
WHERE C.Country = 'Germany'
AND P.ProductID IN (
SELECT TOP 5 OD.ProductID
FROM [Order Details] OD
INNER JOIN Orders O ON OD.OrderID = O.OrderID
INNER JOIN Customers C ON C.CustomerID = O.CustomerID
WHERE C.Country = 'Germany'
GROUP BY OD.ProductID
ORDER BY SUM(OD.Quantity) DESC
)
GROUP BY P.ProductID, P.ProductName, E.EmployeeID, E.FirstName, E.LastName, E.Title
ORDER BY TotalQuantity DESC;




/*
Opdracht 2.7
Welke producten (PRODUCTID, PRODUCTNAME) zorgden voor de hoogste salesresultaten (SALESRESULT) aan Duitse klanten, 
en welke werknemers (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE) hebben deze producten verkocht. 
Orden op sales resultaat. Toon alleen de top 5 producten.
*/ 

SELECT P.ProductID, P.ProductName, SUM(OD.Quantity *OD.UnitPrice) as SalesResult,
E.EmployeeID, E.FirstName, E.LastName, E.Title
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID = OD.ProductID
INNER JOIN Orders O ON OD.OrderID = O.OrderID
INNER JOIN  Customers C ON C.CustomerID = O.CustomerID
INNER JOIN Employees E ON E.EmployeeID = O.EmployeeID
WHERE C.Country = 'Germany'
AND P.ProductID IN (
	SELECT TOP 5 OD.ProductID
	FROM [Order Details] OD
	INNER JOIN Orders O ON OD.OrderID = O.OrderID
	INNER JOIN Customers C ON C.CustomerID = O.CustomerID
	WHERE C.Country = 'Germany'
	GROUP BY OD.ProductID --OD.Quantity *OD.UnitPrice
	ORDER BY SUM(OD.Quantity *OD.UnitPrice) DESC
	)
GROUP BY P.ProductID, P.ProductName, E.EmployeeID, E.FirstName, E.LastName, E.Title
ORDER BY SalesResult DESC;


 

/*
Opdracht 2.8
Join de tabellen Products en Suppliers. Join de tabellen met:

Inner Join
Left Join
Right Join
Full Join
Verklaar de resultaten van deze joins en teken een plaatje van elke join.
*/
Select * from Products
Inner Join Suppliers ON Products.SupplierID = Suppliers.SupplierID 

Select * from Products
Left Join Suppliers ON Products.SupplierID = Suppliers.SupplierID 

Select * from Products
Right Join Suppliers ON Products.SupplierID = Suppliers.SupplierID 

Select * from Products
full outer Join Suppliers ON Products.SupplierID = Suppliers.SupplierID 

/*
Opdracht 2.9
Geef het gemiddelde salesresultaat van elke werknemer (EMPLOYEEID, LASTNAME, FIRSTNAME, TITLE, AVARAGE_SALESRESULT). Orden op salesresultaat.
*/


Select E.EmployeeID, E.LastName, E.FirstName, E.Title, AVG((OD.Quantity *OD.UnitPrice)) as  AVARAGE_SALESRESULT
 from Employees E
join Orders O ON E.EmployeeID= O.EmployeeID
join [Order Details] OD ON O.OrderID= OD.OrderID
Group By E.EmployeeID, E.LastName, E.FirstName, E.Title
Order by AVARAGE_SALESRESULT DESC;