CREATE DATABASE `GroupProject`;
USE `GroupProject`;

CREATE TABLE `items` (
  `itemID` int(11) NOT NULL,
  `itemName` varchar(45) NOT NULL,
  `itemDescription` varchar(45) NOT NULL,
  `itemCost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`itemID`)
);

CREATE TABLE `storagelocations` (
  `locationID` int(11) NOT NULL,
  `locationName` varchar(45) NOT NULL,
  `locationDescription` varchar(45) NOT NULL,
  PRIMARY KEY (`locationID`)
);

CREATE TABLE `suppliers` (
  `supplierID` int(11) NOT NULL,
  `supplierName` varchar(45) NOT NULL,
  `supplierAddress` varchar(45) NOT NULL,
  `supplierCity` varchar(45) NOT NULL,
  `supplierState` varchar(45) NOT NULL,
  `supplierZip` varchar(45) NOT NULL,
  `supplierPhone` char(12) NOT NULL,
  PRIMARY KEY (`supplierID`)
);

CREATE TABLE `inventory` (
  `itemID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT '0',
  `reorderLevel` int(4) NOT NULL,
  `reorderStatus` varchar(45) NOT NULL,
  PRIMARY KEY (`itemID`,`locationID`),
  KEY `locationID_idx` (`locationID`),
  CONSTRAINT `itemIDforInventory` FOREIGN KEY (`itemID`) REFERENCES `items` (`itemid`),
  CONSTRAINT `locationIDforInventory` FOREIGN KEY (`locationID`) REFERENCES `storagelocations` (`locationid`)
);

CREATE TABLE `orders` (
  `orderID` int(11) NOT NULL,
  `itemID` int(11) NOT NULL,
  `supplierID` int(11) NOT NULL,
  `orderQuantity` int(4) NOT NULL,
  `orderTotal` decimal(10,2) NOT NULL,
  `orderDate` datetime NOT NULL,
  PRIMARY KEY (`orderID`,`itemID`,`supplierID`),
  KEY `itemID_idx` (`itemID`),
  KEY `supplierID_idx` (`supplierID`),
  CONSTRAINT `itemIDforOrders` FOREIGN KEY (`itemID`) REFERENCES `items` (`itemid`),
  CONSTRAINT `supplierIDforOrders` FOREIGN KEY (`supplierID`) REFERENCES `suppliers` (`supplierid`)
);