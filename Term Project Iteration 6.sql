--****
--DROP ALL TABLES
--****
DROP table RECEIPT_REFUND_HISTORY cascade constraints;
DROP table STEP cascade constraints;
DROP table CONTAIN cascade constraints;
DROP table MODIFIER cascade constraints;
DROP table INCLUDE cascade constraints;
DROP table HAS cascade constraints;
DROP table SINGLE_ITEM cascade constraints;
DROP table MODIFIER_ITEM cascade constraints;
DROP table BYO_ITEM cascade constraints;
DROP table PRINTER cascade constraints;
DROP table MENU_ITEM cascade constraints;
DROP table SYSTEM_USER cascade constraints;
DROP table ADMIN_USER cascade constraints;
DROP table RECEIPT cascade constraints;
DROP table STATION cascade constraints;
DROP table STORE cascade constraints;
DROP table USERS cascade constraints;
DROP table SPKS cascade constraints;

--****
--DROP ALL SEQUENCES
--****
DROP SEQUENCE spks_seq;
DROP SEQUENCE store_seq;
DROP SEQUENCE users_seq;
DROP SEQUENCE receipt_seq;
DROP SEQUENCE station_seq;
DROP SEQUENCE printer_seq;
DROP SEQUENCE menu_item_seq;
DROP SEQUENCE step_seq;
DROP SEQUENCE has_seq;
DROP SEQUENCE include_seq;
DROP SEQUENCE contain_seq;
DROP SEQUENCE modifier_seq;
DROP SEQUENCE refund_seq;

--****
--CREATE ALL TABLES
--****

CREATE TABLE SPKS (
system_id DECIMAL (12) NOT NULL PRIMARY KEY
);

CREATE TABLE Store (
store_id DECIMAL(12) NOT NULL PRIMARY KEY,
system_id DECIMAL(12) NOT NULL,
tax_rate DECIMAL(5,3) NOT NULL,
store_name VARCHAR(64) NOT NULL,
foreign key (system_id) references SPKS(system_id)
);

CREATE TABLE Users (
user_id DECIMAL(12) NOT NULL PRIMARY KEY,
user_type CHAR(1) NOT NULL,
user_name VARCHAR(64) NOT NULL
);

CREATE TABLE System_User (
user_id DECIMAL(12) NOT NULL PRIMARY KEY,
system_id DECIMAL(12) NOT NULL,
foreign key (user_id) references Users(user_id),
foreign key (system_id) references SPKS(system_id)
);

CREATE TABLE Admin_User (
user_id DECIMAL(12) NOT NULL PRIMARY KEY,
store_id DECIMAL(12) NOT NULL,
foreign key (user_id) references Users(user_id),
foreign key (store_id) references Store(store_id)
);

CREATE TABLE Receipt (
receipt_id DECIMAL(12) NOT NULL PRIMARY KEY,
store_id DECIMAL(12) NOT NULL,
tran_time TIMESTAMP NOT NULL,
order_num DECIMAL(3) NOT NULL,
pretax_amount DECIMAL(6,2) NOT NULL,
tax_amount DECIMAL(5,2) NOT NULL,
aftertax_amount DECIMAL(6,2) NOT NULL,
foreign key (store_id) references Store(store_id)
);

CREATE TABLE Printer (
printer_id VARCHAR(32) NOT NULL PRIMARY KEY,
printer_model VARCHAR(32) NOT NULL
);

CREATE TABLE Station (
station_id DECIMAL(6) NOT NULL PRIMARY KEY,
station_name varchar(16) NOT NULL,
printer_id varchar(32) NOT NULL,
store_id DECIMAL(12) NOT NULL,
foreign key (printer_id) references Printer(printer_id),
foreign key (store_id) references Store(store_id)
);

CREATE TABLE Menu_Item (
item_id DECIMAL(12) NOT NULL PRIMARY KEY,
item_name VARCHAR(32) NOT NULL,
price DECIMAL(5,2) NOT NULL,
calories DECIMAL(4) NULL,
item_type CHAR(1) NOT NULL,
description VARCHAR(256) NULL
);

CREATE TABLE Modifier_Item (
item_id DECIMAL(12) NOT NULL PRIMARY KEY,
foreign key (item_id) references Menu_Item(item_id)
);

CREATE TABLE Single_Item (
item_id DECIMAL(12) NOT NULL PRIMARY KEY,
foreign key (item_id) references Menu_Item(item_id)
);

CREATE TABLE BYO_Item (
item_id DECIMAL(12) NOT NULL PRIMARY KEY,
foreign key (item_id) references Menu_Item(item_id)
);

CREATE TABLE Step (
step_id DECIMAL(12) NOT NULL PRIMARY KEY,
step_name VARCHAR(64) NOT NULL,
item_id DECIMAL(12) NULL,
foreign key (item_id) references BYO_Item(item_id)
);

--Create Many to Many bridge Entities
CREATE TABLE Contain (
contain_id DECIMAL(12) NOT NULL PRIMARY KEY,
station_id DECIMAL(6) NOT NULL,
item_id DECIMAL(12) NOT NULL,
foreign key (station_id) references Station(station_id),
foreign key (item_id) references Menu_Item(item_id)
);

CREATE TABLE Modifier (
mod_id DECIMAL(12) NOT NULL PRIMARY KEY,
item_id DECIMAL(12) NOT NULL,
modifier_id DECIMAL(12) NOT NULL,
foreign key (modifier_id) references Modifier_Item(item_id),
foreign key (item_id) references Menu_Item(item_id)
);

CREATE TABLE Include (
include_id DECIMAL(12) NOT NULL PRIMARY KEY,
step_id DECIMAL(12) NOT NULL,
item_id DECIMAL(12) NOT NULL,
foreign key (step_id) references Step(step_id),
foreign key (item_id) references Menu_Item(item_id)
);

CREATE TABLE Has (
has_id DECIMAL(12) NOT NULL PRIMARY KEY,
receipt_id DECIMAL(12) NOT NULL,
item_id DECIMAL(12) NOT NULL,
foreign key (receipt_id) references Receipt(receipt_id),
foreign key (item_id) references Menu_Item(item_id)
);

--***************************
--CREATE ALL SEQUENCES
--***************************

CREATE SEQUENCE spks_seq START WITH 100; 
CREATE SEQUENCE store_seq START WITH 1; 
CREATE SEQUENCE users_seq START WITH 10; 
CREATE SEQUENCE receipt_seq START WITH 1; 
CREATE SEQUENCE station_seq START WITH 1; 
CREATE SEQUENCE printer_seq START WITH 1; 
CREATE SEQUENCE menu_item_seq START WITH 1; 
CREATE SEQUENCE step_seq START WITH 1; 
CREATE SEQUENCE has_seq START WITH 1; 
CREATE SEQUENCE include_seq START WITH 1; 
CREATE SEQUENCE contain_seq START WITH 1;
CREATE SEQUENCE modifier_seq START WITH 1; 

--***************************
--CREATE STORED PROCEDURES
--***************************

--PART 1 CREATE STORED PROCEDURES FOR STANDARD ENTITIES
CREATE OR REPLACE PROCEDURE AddSingleItem (
    item_name IN VARCHAR, 
    price IN DECIMAL, 
    calories IN DECIMAL,
    item_type IN CHAR, 
    description IN VARCHAR,
    station_id IN DECIMAL) 
AS
BEGIN
 INSERT INTO Menu_item
 VALUES(menu_item_seq.nextval, item_name, price, calories, item_type, description);

 INSERT INTO single_item
 VALUES(menu_item_seq.currval);
 
 INSERT INTO Contain
 VALUES(contain_seq.nextval, station_id, menu_item_seq.currval);
END; 
/
CREATE OR REPLACE PROCEDURE AddModItem (
    item_name IN VARCHAR, 
    price IN DECIMAL, 
    calories IN DECIMAL,
    item_type IN CHAR, 
    description IN VARCHAR,
    station_id IN DECIMAL) 
AS
BEGIN
 INSERT INTO Menu_Item
 VALUES(menu_item_seq.nextval, item_name, price, calories, item_type, description);

 INSERT INTO Modifier_Item
 VALUES(menu_item_seq.currval);
  
 INSERT INTO Contain
 VALUES(contain_seq.nextval, station_id, menu_item_seq.currval);
END; 
/
CREATE OR REPLACE PROCEDURE AddBYOItem (
    item_name IN VARCHAR, 
    price IN DECIMAL, 
    calories IN DECIMAL,
    item_type IN CHAR, 
    description IN VARCHAR,
    station_id IN DECIMAL) 
AS
BEGIN
 INSERT INTO Menu_Item
 VALUES(menu_item_seq.nextval, item_name, price, calories, item_type, description);

 INSERT INTO BYO_Item
 VALUES(menu_item_seq.currval);
  
 INSERT INTO Contain
 VALUES(contain_seq.nextval, station_id, menu_item_seq.currval);
END; 
/
CREATE OR REPLACE PROCEDURE AddBYOStep (
    step_name IN VARCHAR, 
    item_id IN DECIMAL) 
AS
BEGIN
 INSERT INTO Step
 VALUES(step_seq.nextval, step_name, item_id);
END; 
/
CREATE OR REPLACE PROCEDURE AddStation (
    station_name IN VARCHAR, 
    printer_id IN DECIMAL,
    store_id IN DECIMAL) 
AS
BEGIN
 INSERT INTO Station
 VALUES(station_seq.nextval, station_name, printer_id, store_id);
END; 
/
CREATE OR REPLACE PROCEDURE AddPrinter (
    printer_model IN VARCHAR) 
AS
BEGIN
 INSERT INTO Printer
 VALUES(printer_seq.nextval, printer_model);
END; 
/
CREATE OR REPLACE PROCEDURE AddStore (
     system_id IN DECIMAL, 
     tax_rate IN DECIMAL,
     store_name IN VARCHAR) 
AS
BEGIN
 INSERT INTO Store
 VALUES(store_seq.nextval, system_id, tax_rate, store_name);
END; 
/
CREATE OR REPLACE PROCEDURE AddReceipt (
    store_id IN DECIMAL, 
    tran_time IN TIMESTAMP, 
    order_num IN DECIMAL,
    pretax_amount IN DECIMAL, 
    tax_amount IN DECIMAL,
    aftertax_amount IN DECIMAL) 
AS
BEGIN
 INSERT INTO Receipt
 VALUES(receipt_seq.nextval, store_id, tran_time, order_num, pretax_amount, tax_amount, aftertax_amount);
END; 
/
CREATE OR REPLACE PROCEDURE AddSystemUser (
    user_type IN CHAR, 
    user_name IN VARCHAR,
    system_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Users
 VALUES(users_seq.nextval, user_type, user_name);
 
 INSERT INTO System_user
 VALUES(users_seq.currval, system_id);
END; 
/
CREATE OR REPLACE PROCEDURE AddAdminUser (
    user_type IN CHAR, 
    user_name IN VARCHAR,
    store_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Users
 VALUES(users_seq.nextval, user_type, user_name);
 
 INSERT INTO Admin_User
 VALUES(users_seq.currval, store_id);
END; 
/
CREATE OR REPLACE PROCEDURE AddSPKS
AS
BEGIN
 INSERT INTO SPKS
 VALUES(SPKS_seq.nextval);
END; 
/

--PART 2 HARD CODE A FEW MANY TO MANY TEMPLATES TO SIMULATE REAL WORLD SAMPLES
CREATE OR REPLACE PROCEDURE AddSoupMods (
    item_id IN DECIMAL,
    modifier1_id IN DECIMAL,
    modifier2_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Modifier
 VALUES(modifier_seq.nextval, item_id, modifier1_id);
 
 INSERT INTO Modifier
 VALUES(modifier_seq.nextval, item_id, modifier2_id);
END; 
/
CREATE OR REPLACE PROCEDURE AddTwoIngredientsStep (
    step_id IN DECIMAL, 
    item1_id IN DECIMAL,
    item2_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Include
 VALUES(include_seq.nextval, step_id, item1_id);
 
 INSERT INTO Include
 VALUES(include_seq.nextval, step_id, item2_id);
END; 
/

--PART 3 HARD CODE VARIOUS TYPES OF RECEIPTS
CREATE OR REPLACE PROCEDURE ReceiptHasModItem (
    receipt_id IN DECIMAL,
    item_id IN DECIMAL,
    mod_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, item_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, mod_id);
END; 
/
CREATE OR REPLACE PROCEDURE ReceiptHasSingleItem (
    receipt_id IN DECIMAL,
    item_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, item_id);
END; 
/
CREATE OR REPLACE PROCEDURE ReceiptHasBYOItem (
    receipt_id IN DECIMAL,
    item_id IN DECIMAL,
    byo1_id IN DECIMAL,
    byo2_id IN DECIMAL,
    byo3_id IN DECIMAL,
    byo4_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, item_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo1_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo2_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo3_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo4_id);
END; 
/
CREATE OR REPLACE PROCEDURE ReceiptHasBYOAndSingleItem (
    receipt_id IN DECIMAL,
    byo_id IN DECIMAL,
    byo1_id IN DECIMAL,
    byo2_id IN DECIMAL,
    byo3_id IN DECIMAL,
    byo4_id IN DECIMAL,
    item_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo1_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo2_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo3_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, byo4_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, item_id);
END; 
/
CREATE OR REPLACE PROCEDURE ReceiptHasModAndSingleItem (
    receipt_id IN DECIMAL,
    item1_id IN DECIMAL,
    mod_id IN DECIMAL,
    item2_id IN DECIMAL)
AS
BEGIN
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, item1_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, mod_id);
 
 INSERT INTO Has
 VALUES(has_seq.nextval, receipt_id, item2_id);
END; 
/

--PART 4 CREATE RAISED APPLICATION ERROR TRIGGERS
CREATE OR REPLACE TRIGGER item_price_trg
BEFORE UPDATE OR INSERT ON menu_item
FOR EACH ROW
 
BEGIN
 IF :NEW.price < 0 THEN
 RAISE_APPLICATION_ERROR(-20001,'The price you entered ' || :NEW.price || ', is a negative number.');
 END IF;
 
 IF :NEW.calories < 0 THEN
 RAISE_APPLICATION_ERROR(-20001,'The calories you entered ' || :NEW.calories || ', is a negative number.');
 END IF;
END; 
/

--***************************
--STORED PROCEDURE EXECUTIONS
--***************************

--Begin by adding a SPKS
BEGIN
 AddSPKS();
 COMMIT;
END; 
/
--Then I add a System User, Aidan Chang
BEGIN
 AddSystemUser(0, 'Aidan Chang', 100);
 COMMIT;
END;
/
--Add a store, 'Amazon Lab 126' to SPKS
BEGIN
 AddStore(100, 10, 'Amazon Lab 126');
 COMMIT;
END;
/
--Add admin users to 'Amazon Lab 126'
BEGIN
 AddAdminUser(1, 'Jeremiah Han', 1);
 COMMIT;
END;
/
--Create 3 printers
BEGIN
 AddPrinter('EPSON MODEL Y');
 COMMIT;
END;
/
BEGIN
 AddPrinter('EPSON MODEL Y');
 COMMIT;
END;
/
BEGIN
 AddPrinter('EPSON MODEL Y');
 COMMIT;
END;
/
--Adding stations to 'Amazon Lab 126'. 
-- I createD 4 stations, 2 stations has their own printers while the other 2 stations share one printer 
BEGIN
 AddStation('Brick Oven', 2, 1);
 COMMIT;
END;
/
BEGIN
 AddStation('Soup', 1, 1);
 COMMIT;
END;
/
BEGIN
 AddStation('World Entree', 3, 1);
 COMMIT;
END;
/
BEGIN
 AddStation('Salad Bar', 3, 1);
 COMMIT;
END;
/

--Create all subtypes of menu items
--single items available at Brick Oven, Soup, and World
BEGIN
 AddSingleItem('Pesto Margheritta', 6.00, 750, 0,'pesto, tomatoes, basil, fresh mozzarella', 1 );
 COMMIT;
END;
/
BEGIN
 AddSingleItem('Pepperoni Pizza', 6.00, 850, 0,'house made marinara sauce and shredded mozzarella cheese', 1 );
 COMMIT;
END;
/
BEGIN
 AddSingleItem('Cajun Seitan With Seasoned Pasta', 12.00, 1050, 0,'seasoned pasta tossed onions, garlic, bell peppers, celery, chicken broth, cream, butter, flour, cajun seasoning, tomato, spinach and topped with cajun seitan', 3 );
 COMMIT;
END;
/
BEGIN
 AddSingleItem('Cajun Salmon With Seasoned Pasta', 14.00, 1000, 0,'seasoned pasta tossed with shrimp, clams, andouille sausage, onions, garlic, bell peppers, celery, chicken broth, cream, butter, flour, cajun seasoning, tomato, spinach and topped with cajun salmon', 3 );
 COMMIT;
END;
/
BEGIN
 AddSingleItem('Butternut Squash And Pear', 4.50, 350, 0,'winter squash, bosc pears, shallots, carrots, honey, apple cider and mascarpone cheese', 2 );
 COMMIT;
END;
/
BEGIN
 AddSingleItem('Greek Lemon Chicken', 4.5, 1000, 0,'hala chicken, onions, leeks , chicken broth, oregano, dill, white rice, eggs and lemon juice', 2 );
 COMMIT;
END;
/

--Add BYO item and ingredients at Salad Bar
BEGIN
 AddBYOItem('Build Your Own Salad', 9.00, 600, 0,'romaine, mixed greens, arugula, beets, cucumbers, tomatoes, carrots, cauliflower, bell peppers, cage free eggs, blueberries, mushrooms, hodo tofu, tri-colored quinoa, chicken, kale salad, cottage cheese, shredded cheese, caesar, and ranch dressing', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('romain', 0, 0, 1,'', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('arugula', 0, 0, 1,'', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('beets', 0, 0, 1,'', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('cucumbers', 0, 0, 1,'', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('cage free eggs', 2.00, 150, 1,'', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('chicken', 3.50, 150, 1,'', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('Ranch', 0, 180, 1,'', 4 );
 COMMIT;
END;
/
BEGIN
 AddBYOItem('caesar', 0, 180, 1,'', 4 );
 COMMIT;
END;
/

--Add Modifier Items
BEGIN
 AddModItem('No Crackers', 0, 0, 2,'', 2 );
 COMMIT;
END;
/
BEGIN
 AddModItem('Add Crackers', 0, 75, 2,'', 2 );
 COMMIT;
END;
/

--Add Modifier
BEGIN
 AddSoupMods(5, 16, 17 );
 COMMIT;
END;
/
BEGIN
 AddSoupMods(6, 16, 17 );
 COMMIT;
END;
/

--Add Steps for BYO Salad
BEGIN
 AddBYOStep('Choose Your Salad', 7 );
 COMMIT;
END;
/
BEGIN
 AddBYOStep('Choose Your Toppings', 7 );
 COMMIT;
END;
/
BEGIN
 AddBYOStep('Choose Your Protein', 7 );
 COMMIT;
END;
/
BEGIN
 AddBYOStep('Choose Your Dressing', 7 );
 COMMIT;
END;
/

--Add menu_items to each Step (BYO Salad)
BEGIN
 AddTwoIngredientsStep(1, 8, 9);
 COMMIT;
END;
/
BEGIN
 AddTwoIngredientsStep(2, 10, 11);
 COMMIT;
END;
/
BEGIN
 AddTwoIngredientsStep(3, 12, 13);
 COMMIT;
END;
/
BEGIN
 AddTwoIngredientsStep(4, 14, 15);
 COMMIT;
END;
/

--Add Receipts
BEGIN
 AddReceipt(1, '26-JUN-02 12:39:52 PM', 1, 12, 1.20, 13.20);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '26-JUN-02 12:49:13 PM', 2, 18.5, 1.85, 20.25);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '26-JUN-02 1:09:54 PM', 3, 11, 1.10, 12.10);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '26-JUN-02 1:10:18 PM', 4, 4.5, 0.45, 4.95);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '26-JUN-02 1:12:11 PM', 5, 18.50, 1.85, 20.25);
 COMMIT;
END;
/

--Add Receipts without adding to Has Table
BEGIN
 AddReceipt(1, '25-JUN-02 1:12:11 PM', 5, 61, 6.1, 67.1);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '24-JUN-02 1:12:11 PM', 5, 58, 5.80, 63.80);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '27-JUN-02 1:12:11 PM', 5, 62, 6.20, 68.20);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '28-JUN-02 1:12:11 PM', 5, 48, 4.80, 52.80);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '26-JUN-02 11:12:11 AM', 5, 14.5, 1.45, 15.95);
 COMMIT;
END;
/
BEGIN
 AddReceipt(1, '26-JUN-02 2:12:11 PM', 5, 11, 1.1, 12.1);
 COMMIT;
END;
/

--Add Detailed Receipts to Has Bridge Entity
BEGIN
 ReceiptHasModItem(1, 5, 16);
 COMMIT;
END;
/
BEGIN
 ReceiptHasSingleItem(1, 3);
 COMMIT;
END;
/
BEGIN
 ReceiptHasBYOItem(3, 7, 8, 10, 12, 15);
 COMMIT;
END;
/
BEGIN
 ReceiptHasBYOAndSingleItem(2, 7, 8, 10, 13, 15, 2);
 COMMIT;
END;
/
BEGIN
 ReceiptHasModAndSingleItem(5, 6, 17, 4);
 COMMIT;
END;
/

--***************************
--QUERIES
--***************************

-- 1.	Sales volume within a certain period
SELECT
SUM(aftertax_amount) as sales_total
FROM receipt
WHERE TRAN_TIME > '26-JUN-02 12:45:00 PM' 
AND  TRAN_TIME < '26-JUN-02 01:15:00 PM';

-- 2.	Most popular items sold within a certain period
SELECT
item_name,
count(item_name) as QTY_SOLD
FROM receipt
JOIN HAS ON has.receipt_id = receipt.receipt_id
JOIN menu_item ON menu_item.item_id = has.item_id
WHERE TRAN_TIME > '26-JUN-02 12:45:00 PM' 
AND  TRAN_TIME < '26-JUN-02 01:15:00 PM'
GROUP BY item_name
ORDER BY QTY_SOLD desc;

--Or we can exclude all the modifiers
SELECT
item_name,
count(item_name) as QTY_SOLD
FROM receipt
JOIN HAS ON has.receipt_id = receipt.receipt_id
JOIN menu_item ON menu_item.item_id = has.item_id
WHERE TRAN_TIME > '26-JUN-02 12:45:00 PM' 
AND  TRAN_TIME < '26-JUN-02 01:15:00 PM'
AND item_type != 1
GROUP BY item_name
ORDER BY QTY_SOLD desc;

--3.	Most popular modifier by number of modifiers sold within a certain period
SELECT
item_name,
count(item_name) as QTY_SOLD
FROM receipt
JOIN HAS ON has.receipt_id = receipt.receipt_id
JOIN menu_item ON menu_item.item_id = has.item_id
WHERE TRAN_TIME > '26-JUN-02 12:45:00 PM' 
AND  TRAN_TIME < '26-JUN-02 01:15:00 PM'
AND item_type = 1
GROUP BY item_name
ORDER BY QTY_SOLD desc;

--***************************
--CREATE INDEXES
--***************************

--Create Entity Foreign Key Indexes
CREATE INDEX storeSysIdIdx
ON Store (system_id);
CREATE INDEX stationStoreIdIdx
ON station (store_id);
CREATE INDEX stationPrinterIdIdx
ON station (printer_id);
CREATE INDEX receiptStoreIdIdx
ON receipt (store_id);
CREATE INDEX stepItemIdIdx
ON step (item_id);
CREATE INDEX systemUserIdIdx
ON system_user (system_id);
CREATE INDEX adminUserIdIdx
ON admin_user (store_id);

--Create Entity Bridge Foreign Key Indexes
CREATE INDEX containStationIdIdx
ON contain (station_id);
CREATE INDEX containItemIdIdx
ON contain (item_id);
CREATE INDEX modifierItemIdIdx
ON modifier (item_id);
CREATE INDEX modifierModIdIdx
ON modifier (modifier_id);
CREATE INDEX includeStepIdIdx
ON include (step_id);
CREATE INDEX includeItemIdIdx
ON include (item_id);
CREATE INDEX hasReceiptIdIdx
ON has (receipt_id);
CREATE INDEX hasItemIdIdx
ON has (item_id);

--Create Heavy Traffic Columns Index
CREATE INDEX menuItemTypeIdx
ON Menu_Item (item_type);
CREATE INDEX itemNameIdx
ON Menu_Item (item_name);
CREATE INDEX itemCaloriesIdx
ON Menu_Item (calories);
--***************************
--CREATE UPDATE TABLES AND TRIGGER
--***************************

--Create a refund history table
CREATE TABLE receipt_refund_history (
refund_id DECIMAL(12) PRIMARY KEY,
receipt_id DECIMAL(12),
old_pretax_amount DECIMAL(6,2),
new_pretax_amount DECIMAL(6,2),
change_date TIMESTAMP,
foreign key (receipt_id) references receipt(receipt_id)
);

--Create sequence for receipt_refund_history
CREATE SEQUENCE refund_seq START WITH 1; 

--Create index for receipt_refund_history table
CREATE INDEX refundReceiptIdIdx
ON receipt_refund_history (receipt_id);

--Create a trigger for receipt_refund_history
CREATE OR REPLACE TRIGGER receipt_refund_trg
AFTER UPDATE ON receipt
FOR EACH ROW
BEGIN
    IF: OLD.pretax_amount <> :NEW.pretax_amount THEN
    INSERT INTO receipt_refund_history
    VALUES(refund_seq.nextval, :NEW.receipt_id, :OLD.pretax_amount, :NEW.pretax_amount, SYSDATE );
    END IF;
END;
/

--Test and Validate the receipt_refund_trigger
UPDATE receipt
--pretax_amount was 12 and now changing to 11.
SET pretax_amount = 11 
WHERE receipt_id = 1;

select *
from receipt_refund_history;


--*******************
--DATA VISUALIZATION
--*******************

--Weekly Sales
select 
    to_char(tran_time,  'DY') as "dateOfWeek",
    min(TRUNC(TRAN_TIME)) as "date",
    sum(aftertax_amount) as "totalSales"
from receipt
WHERE TRAN_TIME > '24-JUN-02' 
AND  TRAN_TIME < '29-JUN-02'
group by to_char(tran_time,  'DY')
order by "date";

--Daily Sales
select
    min(TRUNC(TRAN_TIME)) as "date",
    extract (hour from tran_time) as "hours",
    sum(aftertax_amount) as "hourlySales"
from receipt
WHERE trunc(tran_time) = '26-Jun-02'
group by extract (hour from tran_time)
order by "hours"
;


