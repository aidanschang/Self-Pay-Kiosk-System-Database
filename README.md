# Self-Pay-Kiosk-System-Database

## Project Direction Overview
As an individual with hospitality background, I have extensive experience working with Self Pay Kiosk System (SPKS) and I would like to develop a simplified version of a SPKS that is commonly used in restaurants and corporate cafeterias (refer to Stores in the rest of the project). 

For a quick overview of my vision of SPKS, I created the following scenario to illustrate how the SPKS works:

A customer walked into a Store and wants to buy some lunch. The customer walks up to a kiosk screen and browses for today’s menu offering. The Store offers stations like Chef’s Special, Tossed Salad Bar, Grille, and Fusion. Within each station, the customer can find the menu items on the kiosk screen and can either select a single item or build an item step by step like burgers or tossed salads and added to the cart. By design, modifiers can be added to some customizable items such as amount of dressing on a salad or toasted/untoasted bread on a deli sandwich. 

Once finished selecting, the customer can proceed to check out on the kiosk screen and a detailed receipt with order number is printed. Consequently, the corresponded Station printers will receive a ticket with the name of the dish as well as the order number. Another core feature of a SPKS is that an administrative user has access to view all sales history to fulfill their financial duties.

Given that SPKS are highly customizable at each Store, the onsite managers are often given with the admin access to perform operations such as create, delete, and modify the database that mentioned above. However, since this project doesn’t involve with the View and business logic aspect of the SPKS development, this database is only as beneficial as storing and retrieving data. 

Lastly, it’s worth to note that foodservice company don’t want to deal with the cost of the R & D and overhead of maintaining the SPKS, therefore, the brand I was working for (and pretty much the entire hospitality industry) are contracted with third party SPKS company to help us setup the hardware (kiosks, screens, printers, and servers), create the Store account, provide training, and provide regular maintenance, etc.

## Use Cases and Fields
1.	Initial Store Setup for a new Location
a.	The sales team signed a contract with a Store to expand the SPKS to a new location.
b.	Each new Store needs to be setup by an IT staff of a SPKS company.
c.	IT staff creates store_id, store_name, and tax_rate for the new Store.
d.	Once created, the new Store is ready to be customized by the Admin User(s).
![image](https://user-images.githubusercontent.com/84875731/208284146-f6cac9f2-2155-4895-943b-3c7016dabeda.png)

2.	Setup Admin Users/System Users
a.	The SPKS company will determine and choose whether the user will be Admin User or System Users based on the scenario. 
b.	If the company hires a new IT, then they create a System User.
c.	If the company’s goal is to setup Admin Users for the Stores, the Store will tell the IT staff how many Admin Users they will need.
a.	Once the numbers of Admin Users have been determined, the IT staff creates admin user accounts so that Admin User haves the access to the Store.
![image](https://user-images.githubusercontent.com/84875731/208284156-4bf38dba-a717-4392-b1a7-2430f45ee5e8.png)

3.	View Stations
a.	During Store service time, customer can walk up to the kiosk to browse the menu.
b.	First thing the customer see on the kiosk are the Stations this Store has.
c.	If the customer finds the Station to be intriguing, the customer selects the Station to view that station’s menu items.
![image](https://user-images.githubusercontent.com/84875731/208284159-49f98541-7b54-4654-8417-cec099c8bc8e.png)

4.	Browse and Add Menu Items to the Cart
Single_Item
  a.	Once the customer selects the Station, the customer can see all the Menu Items from that Station.
  b.	Menu items are associate with information such as price, calories, and item descriptions.
  c.	There are two types of Menu Items, a Single Item or a Build Your Own Item (BYO Item).
  d.	If a customer selects a Single Item, the selection process is finished and can proceed to select more Menu Items or check out. 
Modifier_Item
  a.	Modifier_Item behalf like a menu item but instead being a food item, modifiers are the instructions that describe how a menu item should be prepared. 
  b.	For example, the kiosk asks the customer for the salad dressing level or how well-cooked they want their steak to be cooked. The customer can select the Modifier_Item such as “Light”, “Normal”, and “Extra” for the dressing level and “Rare”, “Medium”, and “Well Done” for the wellness of the steak.	
  c.	Modifier_Item may contain calories information for places like hospitals or gyms or may associate with up-charge if “Extra” dressing was selected.
BYO_Item
  a.	A customer selects a BYO menu item on a Station.
  b.	Depends on how the BYO item were designed, the SPKS prompts number of steps to asks the customer to select desired ingredients to be included in the BYO menu item.
  c.	For example, in order to build a burger, first step is to select type of buns (brioche, wheat, multigrain), second step is to select type of patties (beef patties, impossible), third step is to select type of cheese (pepper jack, American, Swiss, cheddar), forth step is to select type of condiments (mayo, mustard, ketchup), and fifth step is to select type of sides (French fries, sweet potato fries, onion rings).
  d.	Once the BYO menu item has been built, it is added to the cart automatically.
![image](https://user-images.githubusercontent.com/84875731/208284183-a16e5eed-c537-4b4c-b4e7-06398d7001e0.png)

5.	Browse and add a built-your-own (BYO) Menu item to cart
![image](https://user-images.githubusercontent.com/84875731/208284190-7af060ce-ce7c-4c28-800a-a4e20f34fc44.png)

6.	Checkout order
a.	The customer can add multiple desired Menu Items to the cart.
b.	Once all items have been added, the customer can proceed to checkout.
c.	After the order has been processed, a detail receipt will be printed for the customer which contains order number, timestamp, store ID, store name, line items, prices, tax, and sales total.
![image](https://user-images.githubusercontent.com/84875731/208284202-d5720455-3d84-435c-a471-840d9d5c6afd.png)

7.	Print Kitchen Orders
a.	The processed order will be printed at adequate printers at the stations depending on what food the customer ordered.
![image](https://user-images.githubusercontent.com/84875731/208284212-389973db-55e7-4e9f-b7ff-c8b643c9cbf1.png)

8.	Customer Refund
a.	A customer may ask for a refund for their unsatisfied meals. 
b.	The admin user (café manager) may issue a refund through SPKS terminal by identifying customer’s order_number that was printed on their receipts.
![image](https://user-images.githubusercontent.com/84875731/208284220-fe0b5ee1-c47d-4663-89ab-a57513e44f66.png)

## Structural Database Rules
  1.	The SPKS associate with one or many System Users, each System User is associated by a SPKS.
(Mandatory, singular/plural), (Mandatory, singular)

The SPKS needs a System User(s) to perform daily operations and maintenance to the system at a corporate level. Therefore, one to many System Users are necessary for this SPKS that I am designing.

2.	A User is a System User, or an Admin User.
(Mandatory, or)

The supertype User, can either be a subtype System User, or a subtype Admin User.

3.	The SPKS may operate on zero or many Stores, each Store is operated by one SPKS.
(Optional, plural), (Mandatory, singular)

The SPKS may expand business from zero Store to multiple Stores. In the case of expansion, a System User will create a unique Store profile for each new location. 

4.	Each Store has one or many Admin Users, each Admin User has one Store. 
(Mandatory, singular/ plural), (Mandatory, singular)

Once a Store profile has been created, Admin User(s) can be added to that Store so that those Admin User(s) can start design the menu interface. (Typically, Admin Users are the café managers)

5.	Each Store have one to many Stations, each Station has one Store.
(Mandatory, singular/ plural), (Mandatory, singular)

Depends on the sales volume, ranging from 3 to 10 Stations are possible to be found at each Store to divert the sales traffic.

6.	Each Station serve one or many Menu Items, each Menu Item may be served by zero to many Stations.
(Mandatory, singular/ plural), (optional, singular/ plural)

Typically, Admin Users will create Menu Items based on daily offering. Unused Menu Items may be taken out of the current menu for future use. In this case, a Menu item may have zero association with any Stations. On the other hand, a popular Menu Item such as “rice” or “mashed potato” may be found at multiple Stations on the same day. In this scenario, each Menu Item may be associated with many Stations.

7.	A Menu Item can be either a Modifier_Item, Single_Item, or a BYO_Item.
(Mandatory, or)

A Menu Item have three subtypes, a Modifier, a build-your-own item, or a single item.

8.	Each Menu Item may have zero or many Modifiers, each Modifier can be associated with zero to many Menu Items.
(Optional, singular/ plural), (Optional, singular/ plural)

Typically, Modifiers are applied where static menus are being used such as Grill Station, Salad Stations, and Daily Stations. While daily specials are less likely involved with Modifiers.

9.	Each BYO Menu Item contains one or many Steps, each Step is used by one BYO Menu Item
(Mandatory, singular/plural), (Mandatory, singular)

A build-your-own Menu item must contain at least one Step and every Step must be unique and used once by its associated item.
 
10.	Each Step contains one or many Menu Item, each Menu Item may be used in zero or many Steps.
(Mandatory, singular/plural), (Optional, singular/plural)

In each Step of building a BYO Menu Item, it contains at least one ingredient (Menu Item) and one ingredient (Menu Item) may be used in different Steps at other BYO Menu Items

11.	Each Store may generate zero to many Receipts, each Receipt is generated by one Store.
(Optional, singular/ plural), (Mandatory, singular)

A Store may generate large amounts of transactions per day, or zero if it hasn’t opened.

12.	Each Receipt contain one or many Menu Items, each Menu Item may be contained by zero to many Receipts.
(Mandatory, singular/ plural), (Optional, singular/ plural)

When a Menu Item is unpopular, customer may not buy it on that day. 
13.	Each Station own a Printer, each Printer may be owned by multiple Stations
(Mandatory, Single), (Optional, Plural)

Each Station needs one Printer, but sometimes due to space limitations, multiple Stations can share one printer. Further, in some cases during a printer failure, an Admin user can reroute the Station-Printer relationship so that one Printer is capable to print multiple Station’s orders.

14.	Each Receipt may have one or many Refunds, each Refund can only be applied to one Receipt.
(Optional, plural), (Mandatory, singular)

A customer may request several refunds on their order and each Refund can only applied to one Receipt.

## Initial DBMS Physical ERD
![image](https://user-images.githubusercontent.com/84875731/208284240-2dde9d6c-3e37-47f7-9bce-aa71908b7d95.png)
All tables are valid and legally represented with constraints, and attributes so they all qualify for 1NF. After further review, there are no partial dependencies so therefore, it also qualifies for 2NF.

When reviewing for transitive dependencies, I noticed that I originally have store_name attribute under the Receipt table, which is a transitive dependency because receipt_id -> store_id -> store_name. Once I removed the store_name attribute under Receipt table, I now qualify for 3NF.

By following the rule ‘every determinant must be a candidate key’, I have reviewed and confirmed that no two candidate keys exist within any given entity, therefore, my DBMS physical ERS is compliant with BCNF.

## Stored Procedure Execution and Explanations
Part 1 of the stored procedures is straigtforward as it just passes data into the entities.
![image](https://user-images.githubusercontent.com/84875731/208284278-2ed1a6e6-1392-4de9-888a-93d673e02ee0.png)

Part 2 involves stored procedures for the bridge entities and I had to hard coded two procedures because creating modifiers and BYO steps are very subjective to each Store and I don’t have the knowledge yet to dynamically create a stored procedures that invloves unknown number of data rows to be inserted. 
![image](https://user-images.githubusercontent.com/84875731/208284281-54b23720-44a5-4450-bde0-41f19c4848e0.png)

Part 3 involves hard coding a few receipt templates that simulate a few most common combinations that would occurred during real usage. As I mentioned earlier, since my Receipt Entity takes the advantage of using many to many relationship, I can’t dynamically create a stored procedure that captures all the menu items, modifiers, and BYO items with my current knowledge. 
![image](https://user-images.githubusercontent.com/84875731/208284284-7e89e44c-0d3b-4b2b-b98d-305586e20311.png)

Executing stored procedures are straightforward except Receipt and Has Entities. They were a bit trickier because without the aid of computer automation from the Controllers and View, it required some plannings for the combinations of different menu types and pre-calculations on the sales price. 
![image](https://user-images.githubusercontent.com/84875731/208284289-1efaef68-ef96-450f-a177-3d5ef9650bfe.png)

 

