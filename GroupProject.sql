DROP SCHEMA IF EXISTS `groupproject` ;

CREATE SCHEMA IF NOT EXISTS `groupproject`
USE `groupproject`;

CREATE TABLE `books` (
  `bookID` int(11) NOT NULL AUTO_INCREMENT,
  `bookTitle` varchar(45) NOT NULL,
  `bookDescription` varchar(45) NOT NULL,
  `bookCost` decimal(10,2) NOT NULL,
  PRIMARY KEY (`itemID`)
);

CREATE TABLE `locations` (
  `locationID` int(11) NOT NULL AUTO_INCREMENT,
  `aisleNum` int(2) NOT NULL,
  `shelfNum` int(2) NOT NULL,
  `rowNum` int(1) NOT NULL,
  PRIMARY KEY (`locationID`)
);

CREATE TABLE `borrowers` (
  `borrowerID` int(11) NOT NULL AUTO_INCREMENT,
  `borrowerName` varchar(45) NOT NULL,
  `borrowerAddress` varchar(45) NOT NULL,
  `borrowerCity` varchar(45) NOT NULL,
  `borrowerState` varchar(45) NOT NULL,
  `borrowerZip` varchar(45) NOT NULL,
  `borrowerPhone` char(12) NOT NULL,
  PRIMARY KEY (`borrowerID`)
);

CREATE TABLE `inventory` (
  `bookID` int(11) NOT NULL,
  `locationID` int(11) NOT NULL,
  `available` bit(1) NOT NULL,
  PRIMARY KEY (`itemID`,`locationID`),
  KEY `bookID_idx` (`bookID`),
  KEY `locationID_idx` (`locationID`),
  CONSTRAINT `bookIDforInventory` FOREIGN KEY (`bookID`) REFERENCES `books` (`bookID`),
  CONSTRAINT `locationIDforInventory` FOREIGN KEY (`locationID`) REFERENCES `locations` (`locationID`)
);

CREATE TABLE `loans` (
  `loanID` int(11) NOT NULL,
  `bookID` int(11) NOT NULL,
  `borrowerID` int(11) NOT NULL,
  `checkOutDate` datetime NOT NULL,
  `dueDate` datetime NOT NULL,
  PRIMARY KEY (`loanID`,`bookID`,`borrowerID`),
  KEY `bookID_idx` (`bookID`),
  KEY `borrowerID_idx` (`borrowerID`),
  CONSTRAINT `bookIDforLoans` FOREIGN KEY (`bookID`) REFERENCES `books` (`bookID`),
  CONSTRAINT `borrowerIDforLoans` FOREIGN KEY (`borrowerID`) REFERENCES `borrowers` (`borrowerID`)
);
