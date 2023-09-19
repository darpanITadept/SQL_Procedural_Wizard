--SETTING THE SERVEROUTPUT ON.
set 
  serveroutput on;
--STORED PROCEDURES:
--------------------
--PROCEDURE 1. TO CHECK IF THE CUSTOMER EXISTS USING THE CUSTOMER ID.
CREATE 
OR replace PROCEDURE find_customer (
  customer_id IN NUMBER, found OUT NUMBER
) AS localCustID NUMBER := 0;
BEGIN localCustID := customer_id;
SELECT 
  COUNT(*) INTO found 
FROM 
  customers 
WHERE 
  customer_id = localCustID;
IF (found > 0) THEN dbms_output.put_line(
  'The customer with the id ' || localCustID || ' exists'
);
elsif(found = 0) THEN dbms_output.put_line(
  'The customer with the id ' || localCustID || ' does not exists'
);
END IF;
EXCEPTION WHEN no_data_found THEN dbms_output.put_line('NO DATA FOUND!! TRY AGIAN');
WHEN others THEN dbms_output.put_line('AN UNKNOWN ERROR OCCUR!!');
END;
--------------------------------------------------------------------------------
--PROCEDURE 2. TO CHECK IF THE PRODUCT EXISTS USING THE PRODUCT ID.
CREATE 
OR replace PROCEDURE find_product (
  product_id IN NUMBER, price OUT products.list_price % TYPE
) AS localProductID NUMBER := 0;
BEGIN localProductID := product_id;
price := 0;
SELECT 
  list_price INTO price 
FROM 
  products 
WHERE 
  PRODUCT_ID = localProductID;
dbms_output.put_line('Product Price is: ' || price);
EXCEPTION WHEN no_data_found THEN dbms_output.put_line(
  'SORRY NO DATA FOUND!!! FOR THE PRODUCT ID ' || localproductid
);
END;
--------------------------------------------------------------------------------
--PROCEDURE 3. TO ADD ORDER ID FOR THE CUSTOMER USING THE CUSTOMER ID.
CREATE 
OR replace PROCEDURE add_order (
  customer_id IN NUMBER, new_order_id OUT NUMBER
) AS greatestOrderID number := 0;
BEGIN --DETERMINING THE MAX ORDER ID YET.
SELECT 
  MAX(order_id) INTO greatestOrderID 
FROM 
  orders;
--CREATING A VALUE FOR THE NEW ORDER ID BY ADDED ONE TO THE BIGGEST ONE.
new_order_id := greatestOrderID + 1;
--INSERTING THE DATA INTO THE TABLE.
INSERT INTO orders 
VALUES 
  (
    new_order_id, customer_id, 'Shipped', 
    56, SYSDATE
  );
--PRINTING OUT THE DETAILS OF THE NEW ORDER ID.
dbms_output.put_line(
  '==> ***Order successfully added for the customer ID: ' || customer_id || '***'
);
dbms_output.put_line('--------------');
dbms_output.put_line('ORDER DETAILS-->');
dbms_output.put_line('--------------');
dbms_output.put_line(
  'NEW ORDER ID       : ' || new_order_id
);
dbms_output.put_line('STATUS             : Shipped');
dbms_output.put_line('SALES PERSON ID is : 56');
dbms_output.put_line(
  'DATE               : ' || SYSDATE
);
dbms_output.put_line(' ');
EXCEPTION WHEN NO_DATA_FOUND THEN dbms_output.put_line(
  'ERROR NO DATA FOUND OF CUSTOMER ID '
);
WHEN OTHERS THEN dbms_output.put_line(
  'ERROR NO DATA FOUND OF CUSTOMER ID '
);
END;
--------------------------------------------------------------------------------
--PROCEDURE 4. TO STORE THE PARAMETERS TO THE ORDER ITEMS TABLE.
CREATE 
OR replace PROCEDURE add_order_item (
  orderId IN order_items.order_id % type, 
  itemId IN order_items.item_id % type, 
  productId IN order_items.product_id % type, 
  quantity IN order_items.quantity % type, 
  price IN order_items.unit_price % type
) AS BEGIN INSERT INTO order_items 
VALUES 
  (
    orderId, itemId, productId, quantity, 
    price
  );
dbms_output.put_line(
  'PARAMETERS SUCCESSFULLY INSERTED INTO THE TABLE!!!'
);
EXCEPTION when no_data_found then DBMS_OUTPUT.PUT_LINE('ERROR!Order ID not valid');
WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERROR!Order ID not valid!');
END;
--------------------------------------------------------------------------------
--PROCEDURE 5. TO DISPLAY THE DETAILS OF THE ORDER USING ORDER ID.
CREATE 
OR replace PROCEDURE display_order (orderId IN NUMBER) IS l_orderId orders.order_id % type;
l_customerId orders.customer_id % type;
l_productId order_items.product_id % type;
l_itemId order_items.item_id % type;
l_quantity order_items.quantity % type;
l_price number;
numProds NUMBER;
totalPrice NUMBER := 0;
BEGIN l_orderId := orderId;
--Counting the number of items in the order.
--Problem can be here..
SELECT 
  COUNT(item_id) INTO numProds 
FROM 
  order_items 
WHERE 
  order_id = l_orderId;
IF numProds = 0 THEN DBMS_OUTPUT.PUT_LINE('ENTER A VALID ORDER ID');
ELSE --PRINTING AND STORING THE DETAILS OF EACH ORDER ITEM ASSOCIATED WITH THE ORDER ID.
FOR i IN 1..numProds LOOP 
SELECT 
  o.customer_id, 
  i.item_id, 
  i.product_id, 
  i.quantity, 
  i.unit_price INTO l_customerId, 
  l_itemId, 
  l_productId, 
  l_quantity, 
  l_price 
FROM 
  orders o 
  INNER JOIN order_items i ON i.order_id = o.order_id 
WHERE 
  o.order_id = l_orderId 
  AND i.item_id = i;
--Finding the total price of all the items purchased by the customer.
totalPrice := totalPrice + l_price;
--Printing the data. Item by Item.
dbms_output.put_line(
  ' ---------          -------------'
);
dbms_output.put_line(
  '|ORDER ID |    ||  | CUSTOMER ID  |'
);
dbms_output.put_line(
  ' ---------           -------------'
);
dbms_output.put_line(
  '  ' || l_orderId || '                       ' || l_customerId
);
dbms_output.put_line(
  '------------------------------'
);
dbms_output.put_line('ITEMID   :' || l_itemId);
dbms_output.put_line('PRODUCTID:' || l_productId);
dbms_output.put_line('QUANTITY :' || l_quantity);
dbms_output.put_line('PRICE    :' || l_price);
dbms_output.put_line(
  '-----------------------------'
);
END loop;
--PRINTING THE TOTAL PRICE.
dbms_output.put_line('*****************');
dbms_output.put_line('TOTAL PRICE: ' || totalPrice);
dbms_output.put_line('*****************');
END IF;
exception WHEN NO_DATA_FOUND THEN dbms_output.put_line('ENTER A VALID ORDER ID');
WHEN others THEN dbms_output.put_line(
  'Error!! TRY ENTERING A VALID ORDER ID'
);
END;
--------------------------------------------------------------------------------
--PROCEDURE 6. THIS IS A MASTER PROCEDURE WHICH CALLS THE PROCEDURES.
--ITS ENTRY POINT OF THE APPLICATION.
CREATE 
OR REPLACE PROCEDURE master_proc(task IN NUMBER, parm1 IN NUMBER) AS found NUMBER := 0;
BEGIN IF (task = 1) THEN find_customer(parm1, found);
elsif (task = 2) THEN find_product(parm1, found);
elsif (task = 3) THEN add_order(parm1, found);
elsif(task = 4) THEN display_order(parm1);
ELSE DBMS_OUTPUT.PUT_LINE(
  'This option is not avaiable yet'
);
END IF;
END;
--------------------------------------------------------------------------------
--CALLING THE FUNCTIONS TO PERFORM SPECIFIC TASKS FOR THE OUTPUT.
BEGIN dbms_output.Put_line(
  '1 � find_customer � with a valid customer ID'
);
Master_proc(1, 180);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '2 � find_customer � with an invalid customer ID'
);
Master_proc(1, 1800);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '3 � find_product � with a valid product ID'
);
Master_proc(2, 208);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '4 � find_product � with an invalid product ID'
);
Master_proc(2, 2008);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '5 � add_order � with a valid customer ID'
);
Master_proc(3, 180);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '6 � add_order � with an invalid customer ID'
);
Master_proc(3, 1800);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '7 � add_order_item � should execute successfully 5 times '
);
FOR i IN 2..6 LOOP Add_order_item(96, i, 208, 128, 8200.82);
END LOOP;
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '8 � add_order_item � should execute with an invalid order ID'
);
Add_order_item(9600, 2, 208, 128, 8200.82);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '9 � display_order � with a valid order ID which has at least 5 order '
);
Master_proc(4, 87);
dbms_output.Put_line(' ');
dbms_output.Put_line(' ');
dbms_output.Put_line(
  '10 � display_order � with an invalid order ID'
);
Master_proc(4, 8700);
END;
