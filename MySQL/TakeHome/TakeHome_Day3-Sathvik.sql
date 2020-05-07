use ORDERS;

# 1.Write a query to Display the product details (product_class_code, product_id, product_desc, product_price,) as per the following criteria and sort them in descending order of category:
# a.	If the category is 2050, increase the price by 2000
# b.	If the category is 2051, increase the price by 500
# c.	If the category is 2052, increase the price by 600.(60 ROWS)[NOTE:PRODUCT TABLE]

SELECT PRODUCT_CLASS_CODE,PRODUCT_ID,PRODUCT_DESC,PRODUCT_PRICE,
case when PRODUCT_CLASS_CODE=2050 then (PRODUCT_PRICE+2000)
     when PRODUCT_CLASS_CODE=2051 then (PRODUCT_PRICE+500)
     when PRODUCT_CLASS_CODE=2052 then (PRODUCT_PRICE+60)
end UPDATED_PRODUCT_PRICE
FROM PRODUCT
order by PRODUCT_CLASS_CODE desc;

# 2.Write a Query to display the product description, product class description and product price of all products which are shipped.(168 rows)[NOTE : TABLE TO BE USED:PRODUCT_CLASS,PRODUCT, ORDER_ITEMS,ORDER_HEADER]

SELECT P.PRODUCT_DESC,PC.PRODUCT_CLASS_DESC,P.PRODUCT_PRICE
FROM PRODUCT P
JOIN PRODUCT_CLASS PC
ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
JOIN ORDER_ITEMS OT
ON OT.PRODUCT_ID=P.PRODUCT_ID
JOIN ORDER_HEADER OH
ON OH.ORDER_ID=OT.ORDER_ID
WHERE ORDER_STATUS='Shipped';

# 3.Write a query to display the  customer_id,customer name, email and order details (order id, product desc,product  qty, subtotal(product_quantity * product_price)) for all customers even if they have not ordered any item.(225 ROWS) [NOTE : TABLE TO BE USED - online_customer, order_header, order_items, product]

SELECT OC.CUSTOMER_ID,OC.CUSTOMER_FNAME,OC.CUSTOMER_LNAME,OC.CUSTOMER_EMAIL,OI.ORDER_ID,P.PRODUCT_DESC,OI.PRODUCT_QUANTITY,(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS SUB_TOTAL
FROM ONLINE_CUSTOMER OC
LEFT JOIN ORDER_HEADER OH
ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
LEFT JOIN ORDER_ITEMS OI
ON OI.ORDER_ID=OH.ORDER_ID
LEFT JOIN PRODUCT P
ON P.PRODUCT_ID=OI.PRODUCT_ID;

# 4.Write a query to display the customer_id,customer full name ,city,pincode,and order details (order id,order date, product class desc, product desc, subtotal(product_quantity * product_price)) for orders shipped to cities whose pin codes do not have any 0s in them. Sort the output on customer name, order date and subtotal.(52 ROWS)

SELECT OC.CUSTOMER_ID,CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME) AS CUSTOMER_FULL_NAME, A.CITY, A.PINCODE, OH.ORDER_ID, OH.ORDER_DATE,PC.PRODUCT_CLASS_DESC,P.PRODUCT_DESC,(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) AS SUB_TOTAL
FROM ONLINE_CUSTOMER OC
JOIN ADDRESS A
ON A.ADDRESS_ID=OC.ADDRESS_ID
JOIN ORDER_HEADER OH
ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
JOIN ORDER_ITEMS OI
ON OI.ORDER_ID=OH.ORDER_ID
JOIN PRODUCT P
ON P.PRODUCT_ID=OI.PRODUCT_ID 
JOIN PRODUCT_CLASS PC
ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
WHERE PINCODE NOT LIKE '%0%' AND ORDER_STATUS='Shipped'
order by CUSTOMER_FULL_NAME,ORDER_DATE,SUB_TOTAL;

# 5.Write a query to display (customer id,customer fullname,city) of customers  from outside ‘Karnataka’ who haven’t bought any toys or books.(19 ROWS)[NOTE : TABLES TO BE USED – online_customer, address, order_header, order_items, product, product_class].

SELECT OC.CUSTOMER_ID,CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME) AS CUSTOMER_FULL_NAME, A.CITY, A.STATE, PC.PRODUCT_CLASS_DESC
FROM ONLINE_CUSTOMER OC
JOIN ADDRESS A
ON A.ADDRESS_ID=OC.ADDRESS_ID
JOIN ORDER_HEADER OH
ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
JOIN ORDER_ITEMS OI
ON OI.ORDER_ID=OH.ORDER_ID
JOIN PRODUCT P
ON P.PRODUCT_ID=OI.PRODUCT_ID 
JOIN PRODUCT_CLASS PC
ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE
WHERE STATE!='KARNATAKA' AND PRODUCT_CLASS_DESC NOT IN ('TOYS','BOOKS')
group by customer_id;

# 6.Write a query to display  details (customer id,customer fullname,order id,product quantity) of customers who bought more than ten (i.e. total order qty) products per order.(11 ROWS)[NOTE : TABLES TO BE USED - online_customer, order_header, order_items]

SELECT OC.CUSTOMER_ID,CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME),OH.ORDER_ID,OI.PRODUCT_QUANTITY
FROM ONLINE_CUSTOMER OC
JOIN ORDER_HEADER OH
ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
JOIN ORDER_ITEMS OI
ON OI.ORDER_ID=OH.ORDER_ID
where PRODUCT_QUANTITY>=10;

# 7.Write a query to display the customer full name and total order value(product_quantity*product_price) of premium customers (i.e. the customers who bought items total worth > Rs. 1 lakh.)(2 ROWS)[ NOTE : TABLES TO BE USED – ONLINE_CUSTOMER,ORDER_HEADER,ORDER_ITEMS,PRODUCT]

SELECT CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME) AS CUSTOMER_FULL_NAME,(OI.PRODUCT_QUANTITY*P.PRODUCT_PRICE) as Total_Order_Value
FROM ONLINE_CUSTOMER OC
JOIN ORDER_HEADER OH
ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
JOIN ORDER_ITEMS OI
ON OI.ORDER_ID=OH.ORDER_ID
JOIN PRODUCT P
ON P.PRODUCT_ID=OI.PRODUCT_ID
WHERE (PRODUCT_QUANTITY*PRODUCT_PRICE)>100000;

# 8.Write a query to display the customer id and cutomer full name of customers along with (product_quantity) as total quantity of products ordered for order ids > 10060.(6 ROWS)[NOTE : TABLES TO BE USED - online_customer, order_header, order_items]

SELECT OC.CUSTOMER_ID, CONCAT(OC.CUSTOMER_FNAME,' ',OC.CUSTOMER_LNAME) AS CUSTOMER_FULL_NAME, OI.PRODUCT_QUANTITY
FROM ONLINE_CUSTOMER OC
JOIN ORDER_HEADER OH
ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
JOIN ORDER_ITEMS OI
ON OI.ORDER_ID=OH.ORDER_ID
WHERE OI.ORDER_ID>10060
GROUP BY CUSTOMER_ID;

# 9.Write a query to display (product_class_desc, product_id, product_desc, product_quantity_avail ) and Show inventory status of products as below as per their available quantity:
#     a.For Electronics and Computer categories, if available quantity is < 10, show 'Low stock', 11 < qty < 30, show 'In stock', > 31, show 'Enough stock'
#     b.For Stationery and Clothes categories, if qty < 20, show 'Low stock', 21 < qty < 80, show 'In stock', > 81, show 'Enough stock'
#     c.Rest of the categories, if qty < 15 – 'Low Stock', 16 < qty < 50 – 'In Stock', > 51 – 'Enough stock'
#    For all categories, if available quantity is 0, show 'Out of stock'. (60  ROWS)[NOTE : TABLES TO BE USED – product, product_class].

SELECT PC.PRODUCT_CLASS_DESC,P.PRODUCT_ID,P.PRODUCT_DESC,P.PRODUCT_QUANTITY_AVAIL,
CASE WHEN P.PRODUCT_QUANTITY_AVAIL=0 THEN 'Out of stock'
     WHEN PC.PRODUCT_CLASS_DESC IN ('ELECTRONICS','COMPUTER') THEN
														CASE WHEN P.PRODUCT_QUANTITY_AVAIL<10 THEN 'Low stock'
															 WHEN P.PRODUCT_QUANTITY_AVAIL<=30 OR P.PRODUCT_QUANTITY_AVAIL<=11 THEN 'In stock'
                                                             WHEN P.PRODUCT_QUANTITY_AVAIL>31 THEN 'Enough stock'
                                                        END  
      WHEN PC.PRODUCT_CLASS_DESC IN ('STATIONARY','CLOTHES') THEN 
														CASE WHEN P.PRODUCT_QUANTITY_AVAIL<20 THEN 'Low stock'
															 WHEN P.PRODUCT_QUANTITY_AVAIL<=80 OR P.PRODUCT_QUANTITY_AVAIL<=21 THEN 'In stock'
                                                             WHEN P.PRODUCT_QUANTITY_AVAIL>81 THEN 'Enough stock'
                                                        END
      ELSE       
            CASE WHEN P.PRODUCT_QUANTITY_AVAIL<15 THEN 'Low stock'
			     WHEN P.PRODUCT_QUANTITY_AVAIL<=50 OR P.PRODUCT_QUANTITY_AVAIL<=16 THEN 'In stock'
			     WHEN P.PRODUCT_QUANTITY_AVAIL>51 THEN 'Enough stock'
				 END 
END AS FINAL
FROM PRODUCT P
JOIN PRODUCT_CLASS PC
ON PC.PRODUCT_CLASS_CODE=P.PRODUCT_CLASS_CODE;
USE ORDERS;
