# 

# SQL_Procedural_Wizard

## Overview
This project demonstrates various Oracle PL/SQL stored procedures to perform essential database operations. These procedures allow you to interact with a relational database, check customer and product existence, add orders, manage order items, and display order details. The README provides an overview of the project and explains how to use the stored procedures.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Stored Procedures](#stored-procedures)
   - [Procedure 1: find_customer](#procedure-1-find_customer)
   - [Procedure 2: find_product](#procedure-2-find_product)
   - [Procedure 3: add_order](#procedure-3-add_order)
   - [Procedure 4: add_order_item](#procedure-4-add_order_item)
   - [Procedure 5: display_order](#procedure-5-display_order)
   - [Procedure 6: master_proc](#procedure-6-master_proc)
3. [Usage](#usage)
4. [Examples](#examples)
5. [Conclusion](#conclusion)

---

## Prerequisites
Before using the stored procedures, ensure the following prerequisites are met:
- An Oracle database is installed and configured.
- You have appropriate privileges to execute the procedures.

---

## Stored Procedures

### Procedure 1: find_customer
This procedure checks if a customer exists using the customer ID.
```sql
CREATE OR REPLACE PROCEDURE find_customer(customer_id IN NUMBER, found OUT NUMBER) AS
-- ...
```

### Procedure 2: find_product
This procedure checks if a product exists using the product ID.
```sql
CREATE OR REPLACE PROCEDURE find_product(product_id IN NUMBER, price OUT products.list_price % TYPE) AS
-- ...
```

### Procedure 3: add_order
This procedure adds an order for a customer using the customer ID.
```sql
CREATE OR REPLACE PROCEDURE add_order(customer_id IN NUMBER, new_order_id OUT NUMBER) AS
-- ...
```

### Procedure 4: add_order_item
This procedure stores parameters in the order_items table.
```sql
CREATE OR REPLACE PROCEDURE add_order_item(
    orderId IN order_items.order_id % type,
    itemId IN order_items.item_id % type,
    productId IN order_items.product_id % type,
    quantity IN order_items.quantity % type,
    price IN order_items.unit_price % type
) AS
-- ...
```

### Procedure 5: display_order
This procedure displays details of an order using the order ID.
```sql
CREATE OR REPLACE PROCEDURE display_order(orderId IN NUMBER) AS
-- ...
```

### Procedure 6: master_proc
The master_proc serves as the entry point of the application and calls other procedures based on the task.
```sql
CREATE OR REPLACE PROCEDURE master_proc(task IN NUMBER, parm1 IN NUMBER) AS
-- ...
```

---

## Usage
You can use these procedures to perform various database operations. Here's how to use them:

1. **Execute the Master Procedure:** Call the `master_proc` procedure with a task code and relevant parameters to perform specific operations.

2. **View Output:** The procedures use `dbms_output.put_line` to display messages and results in the database console.

---

## Examples
Here are some example use cases of the procedures:

1. Check if a customer exists with a valid customer ID:
   ```sql
   Master_proc(1, 180);
   ```

2. Check if a customer exists with an invalid customer ID:
   ```sql
   Master_proc(1, 1800);
   ```

3. Check if a product exists with a valid product ID:
   ```sql
   Master_proc(2, 208);
   ```

4. Check if a product exists with an invalid product ID:
   ```sql
   Master_proc(2, 2008);
   ```

5. Add an order for a customer with a valid customer ID:
   ```sql
   Master_proc(3, 180);
   ```

6. Add an order for a customer with an invalid customer ID:
   ```sql
   Master_proc(3, 1800);
   ```

7. Add order items (executes successfully 5 times):
   ```sql
   FOR i IN 2..6 LOOP
       Add_order_item(96, i, 208, 128, 8200.82);
   END LOOP;
   ```

8. Add order items with an invalid order ID:
   ```sql
   Add_order_item(9600, 2, 208, 128, 8200.82);
   ```

9. Display order details with a valid order ID that has at least 5 orders:
   ```sql
   Master_proc(4, 87);
   ```

10. Display order details with an invalid order ID:
    ```sql
    Master_proc(4, 8700);
    ```

---

## Conclusion
This project showcases a collection of Oracle PL/SQL stored procedures for interacting with a database. You can use these procedures to perform tasks like checking customer and product existence, adding orders, managing order items, and displaying order details. Follow the provided examples and adapt them to your specific use case. Thank you for exploring this project!

*End of README*
