

CREATE DATABASE Manufacturer;

use Manufacturer;

--Create Three Schemas

CREATE SCHEMA Component;

CREATE SCHEMA Product;

CREATE SCHEMA Supplier;

---Create product table---

CREATE TABLE Product.Product(
     [prod_id][int] PRIMARY KEY NOT NULL,
	 [prod_name][varchar](50) NOT NULL,
	 [quantity][int] ,
	 );

---Create Supplier table---

CREATE TABLE Supplier.Supplier(
     [supp_id][int] PRIMARY KEY NOT NULL,
	 [supp_name][varchar](50) NOT NULL,
	 [supp_location][varchar](50) NOT NULL,
	 [supp_country][varchar](50) NOT NULL,
	 [is_active] BIT, 
	 );

---Create Prod_Comp table---

CREATE TABLE Product.Prod_Comp(
     [product_id][int] NOT NULL,
	 [comp_id][int] NOT NULL,
	 [quantity_comp][int] 
     PRIMARY KEY ([product_id], [comp_id]),
	 );

---Create Component table---

CREATE TABLE Component.Component(
     [comp_id][int] PRIMARY KEY NOT NULL,
	 [comp_name][varchar](50) NOT NULL,
	 [description][varchar](50),
	 [quantity_comp][int],
	 );


---Create Comp_Supp table---

CREATE TABLE Component.Comp_Supp(
     [supp_id][int] NOT NULL,
	 [comp_id][int] NOT NULL,
	 [order_date][date],
	 [quantity][int],
	 PRIMARY KEY ([supp_id], [comp_id]),
	 );

	 ---ADD FOREÝGN KEY---

ALTER TABLE Product.Prod_Comp ADD CONSTRAINT FK_1 FOREIGN KEY (product_id) REFERENCES Product.Product(prod_id)

ALTER TABLE Product.Prod_Comp ADD CONSTRAINT FK_2 FOREIGN KEY (comp_id) REFERENCES Component.Component(comp_id)

ALTER TABLE Component.Comp_supp ADD CONSTRAINT FK_3 FOREIGN KEY (supp_id) REFERENCES Supplier.Supplier(supp_id)

ALTER TABLE Component.Comp_supp ADD CONSTRAINT FK_4 FOREIGN KEY (comp_id) REFERENCES Component.Component(comp_id)