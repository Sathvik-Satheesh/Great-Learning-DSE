USE ORDERS;

# 1.Write a Query to display the  product id, product description and product  price of products whose product id less than 1000 and that have the same price more than once. (USE SUB-QUERY)(15 ROWS)[NOTE:PRODUCT TABLE]

SELECT 
    PRODUCT_ID, PRODUCT_DESC, PRODUCT_PRICE
FROM
    PRODUCT
WHERE
    PRODUCT_ID IN (SELECT 
            PRODUCT_ID
        FROM
            PRODUCT
        WHERE
            PRODUCT_ID < 1000)
        AND PRODUCT_PRICE IN (SELECT 
            PRODUCT_PRICE
        FROM
            PRODUCT
        WHERE
            PRODUCT_ID < 1000
        GROUP BY PRODUCT_PRICE
        HAVING COUNT(*) > 1);
        
# 2.Write a query to display product class description ,total quantity(sum(product_quantity),
# Total value (product_quantity * product price) and show which class of products have been shipped highest to countries outside India other than USA? Also show the total value of those items.
# (1 ROWS)[NOTE:PRODUCT TABLE,ADDRESS TABLE,ONLINE_CUSTOMER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT_CLASS TABLE]

select PRODUCT_CLASS_DESC, sum(product_quantity) as total_quantity, product_quantity*product_price as total_value,pc.product_class_code
from online_customer c
join address a
on c.address_id = a.address_id
join order_header h 
on h.customer_id = c.customer_id
join order_items o
on  o.order_id = h.order_id
join product p
on p.product_id = o.product_id
join product_class pc
on pc.product_class_code = p.product_class_code
where country not in ('India','USA') and order_status like 'shipped'
group by pc.product_class_code,(product_quantity*product_price)
order by total_quantity desc limit 1;

# 3.Write a query to display the customer id, customer first name, address line 2,city  total sales(sum(product quantity * product price (0 if they haven't purchased any item)) made by customers who stay in the same locality (i.e. same address_line2 & city). (USE SUB-QUERY)(4 ROWS)[NOTE : ADDRESS,ONLINE_CUSTOMER,ORDER_HEADER,ORDER_ITEMS,PRODUCT]

SELECT DISTINCT
A.CUSTOMER_ID,
A.CUSTOMER_FNAME,
B.ADDRESS_LINE2,
B.CITY,
IFNULL(SUM(D.PRODUCT_QUANTITY * E.PRODUCT_PRICE),0) TOTAL_SALES
FROM ORDERS.ONLINE_CUSTOMER A
LEFT JOIN ORDERS.ADDRESS B ON A.ADDRESS_ID=B.ADDRESS_ID
LEFT JOIN ORDERS.ORDER_HEADER C ON A.CUSTOMER_ID=C.CUSTOMER_ID
LEFT JOIN ORDERS.ORDER_ITEMS D ON C.ORDER_ID=D.ORDER_ID
LEFT JOIN ORDERS.PRODUCT E ON D.PRODUCT_ID=E.PRODUCT_ID
LEFT JOIN ORDERS.PRODUCT_CLASS F ON E.PRODUCT_CLASS_CODE=F.PRODUCT_CLASS_CODE
WHERE (B.ADDRESS_LINE2,B.CITY) IN
(
SELECT DISTINCT
ADDRESS_LINE2,
CITY FROM
ORDERS.ADDRESS  
GROUP BY ADDRESS_LINE2,CITY HAVING COUNT(*)>1
) GROUP BY A.CUSTOMER_ID;

# 4.Write a Query to display product id,product description,totalquantity(sum(product quantity) For a given item whose product id is 201 and which item has been bought along with it maximum no. of times.(USE SUB-QUERY)(1 ROW)[NOTE : ORDER_ITEMS TABLE,PRODUCT TABLE]

select product_id, product_desc,(select sum(product_quantity) as totalquantity from order_items) from product
where product_id = (select product_id from product where product_id =201);

# 5.Write a Query to display the month,total quantity(sum(product quantity)) and show during which month of the year do foreign customers tend to buy max. no. of products.(USE-SUB-QUERY)(1ROW)[NOTE:ORDER_ITEMSTABLE,ORDER_HEADERTABLE,ONLINE_CUSTOMER TABLE,ADDRESS TABLE]

SELECT 
MONTH(C.ORDER_DATE),
SUM(D.PRODUCT_QUANTITY)
FROM ORDERS.ONLINE_CUSTOMER A
INNER JOIN ORDERS.ADDRESS B ON A.ADDRESS_ID=B.ADDRESS_ID AND B.COUNTRY !='INDIA'
INNER JOIN ORDERS.ORDER_HEADER C ON A.CUSTOMER_ID=C.CUSTOMER_ID
INNER JOIN ORDERS.ORDER_ITEMS D ON C.ORDER_ID=D.ORDER_ID
GROUP BY MONTH(C.ORDER_DATE) HAVING SUM(D.PRODUCT_QUANTITY) = 
(
SELECT DISTINCT MAX(SUB.TOTAL) FROM 
(
SELECT
SUM(D.PRODUCT_QUANTITY) TOTAL
FROM ORDERS.ONLINE_CUSTOMER A
INNER JOIN ORDERS.ADDRESS B ON A.ADDRESS_ID=B.ADDRESS_ID AND B.COUNTRY !='INDIA'
INNER JOIN ORDERS.ORDER_HEADER C ON A.CUSTOMER_ID=C.CUSTOMER_ID
INNER JOIN ORDERS.ORDER_ITEMS D ON C.ORDER_ID=D.ORDER_ID
GROUP BY MONTH(C.ORDER_DATE) 
) SUB
)
;

# 6.Write a Query to display customer id,customer firstname,lastname,order status,total value(sum(product quantity * product price)) and show who is the most valued customer (customer who made the highest sales)(1 ROW) [NOTE: ONLINE_CUSTOMER TABLE, ORDER_HEADER TABLE, ORDER_ITEMS TABLE, PRODUCT TABLE]

SELECT OC.CUSTOMER_ID,OC.CUSTOMER_FNAME,OC.CUSTOMER_LNAME,OH.ORDER_STATUS,(SUM(OT.PRODUCT_QUANTITY*P.PRODUCT_PRICE)) AS TOTAL_VALUE
FROM ONLINE_CUSTOMER OC
JOIN ORDER_HEADER OH
ON OH.CUSTOMER_ID=OC.CUSTOMER_ID
JOIN ORDER_ITEMS OT
ON OT.ORDER_ID=OH.ORDER_ID
JOIN PRODUCT P
ON P.PRODUCT_ID=OT.PRODUCT_ID
GROUP BY CUSTOMER_ID,ORDER_STATUS
ORDER BY TOTAL_VALUE DESC LIMIT 1;

# 7.Write a query to display product class code,product class desc,product id product description,product price and show the most expensive products in their respective classes.(16 ROWS)[NOTE : PRODUCT TABLE,PRODUCT CLASS TABLE]

SELECT
B.PRODUCT_CLASS_CODE,
B.PRODUCT_CLASS_DESC,
A.PRODUCT_ID,
A.PRODUCT_DESC,
A.PRODUCT_PRICE
FROM PRODUCT A 
JOIN PRODUCT_CLASS B ON A.PRODUCT_CLASS_CODE=B.PRODUCT_CLASS_CODE
WHERE (B.PRODUCT_CLASS_CODE,A.PRODUCT_PRICE) IN 
(
SELECT
B.PRODUCT_CLASS_CODE,
MAX(A.PRODUCT_PRICE)
FROM PRODUCT A 
JOIN PRODUCT_CLASS B ON A.PRODUCT_CLASS_CODE=B.PRODUCT_CLASS_CODE
GROUP BY B.PRODUCT_CLASS_CODE
);

# 8.Write a query to display shipper id,shipper name , (len*width*height*product_quantity) as total volume shipped and show Which shipper has shipped highest volume of items.(1 ROW) [NOTE : SHIPPER TABLE,ORDER_HEADER TABLE,ORDER_ITEMS TABLE,PRODUCT TABLE]

SELECT S.SHIPPER_ID,S.SHIPPER_NAME, (P.LEN*P.WIDTH*P.HEIGHT*OT.PRODUCT_QUANTITY) AS TOTAL_VOLUME_SHIPPED
FROM SHIPPER S
JOIN ORDER_HEADER OH
ON OH.SHIPPER_ID=S.SHIPPER_ID
JOIN ORDER_ITEMS OT
ON OT.ORDER_ID=OH.ORDER_ID
JOIN PRODUCT P 
ON P.PRODUCT_ID=OT.PRODUCT_ID
ORDER BY TOTAL_VOLUME_SHIPPED DESC LIMIT 1;

# 9.Write a query to display  carton id ,(len*width*height) as carton_vol and identify the optimum carton (carton with the least volume whose volume is greater than the total volume of all items) for a given order whose order id is 10006 , Assume all items of an order are packed into one single carton (box) .(1 ROW)[NOTE : CARTON TABLE]

SELECT CARTON_ID, LEN*WIDTH*HEIGHT as vol
FROM orders.carton
where LEN*WIDTH*HEIGHT>(select T_Volume
from(SELECT  ORDER_ID, sum(ifnull(PRODUCT_QUANTITY*LEN*WIDTH*HEIGHT,0)) as T_Volume
FROM orders.order_items as oi
left join orders.product as op
using(PRODUCT_ID)
group by ORDER_ID
having ORDER_ID=10006
order by ORDER_ID) as v)
order by vol limit 1;

# 10.	Write a query to display product id,product description,total_quantity (sum(order_quantity) ,Provided show the most and least sold products (quantity-wise).(3 ROWS)(USE:SUB-QUERY)

SELECT 
A.PRODUCT_ID,
B.PRODUCT_DESC,
SUM(A.PRODUCT_QUANTITY) TOTAL_QUANTITY
FROM ORDER_ITEMS A
INNER JOIN PRODUCT B ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY B.PRODUCT_ID HAVING SUM(A.PRODUCT_QUANTITY) =
(
SELECT MAX(SUB.TOTAL)FROM 
(
SELECT 
SUM(A.PRODUCT_QUANTITY) TOTAL
FROM ORDER_ITEMS A
INNER JOIN ORDERS.PRODUCT B ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY B.PRODUCT_ID
)SUB
)
OR SUM(A.PRODUCT_QUANTITY)=
(
SELECT MIN(SUB.TOTAL)FROM 
(
SELECT 
SUM(A.PRODUCT_QUANTITY) TOTAL
FROM ORDER_ITEMS A
INNER JOIN PRODUCT B ON A.PRODUCT_ID=B.PRODUCT_ID
GROUP BY B.PRODUCT_ID
) SUB
);

