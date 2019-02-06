DROP SCHEMA IF EXISTS `groupprojectolap`;

CREATE SCHEMA IF NOT EXISTS `groupprojectolap`;
USE `groupprojectolap`;

CREATE TABLE `dimbooks` (
  `bookID` int(11) NOT NULL,
  `bookTitle` varchar(45) NOT NULL,
  `bookDescription` varchar(45) NOT NULL,
  `bookCost` decimal(10,2) NOT NULL,
  `available` char(1),
  `AisleRowShelf` varchar(8),
  PRIMARY KEY (`bookID`)
);

INSERT INTO dimbooks (bookID, bookTitle, bookDescription, bookCost, available, AisleRowShelf)
SELECT 	groupproject.books.bookID,
		groupproject.books.bookTitle,
        groupproject.books.bookDescription,
        groupproject.books.bookCost,
        groupproject.inventory.available,
        CONCAT(groupproject.locations.aisleNum, '-', groupproject.locations.rowNum, '-', groupproject.locations.shelfNum) AS AisleRowShelf
FROM groupproject.books
LEFT JOIN groupproject.inventory ON groupproject.books.bookID = groupproject.inventory.bookID
LEFT JOIN groupproject.locations ON groupproject.inventory.locationID = groupproject.locations.locationID;

CREATE TABLE `dimlocations` (
  `locationID` int(11) NOT NULL,
  `aisleNum` int(2) NOT NULL,
  `shelfNum` int(2) NOT NULL,
  `rowNum` int(1) NOT NULL,
  `locationName` varchar(8),
  `contents` varchar(255),
  PRIMARY KEY (`locationID`)
);

INSERT INTO dimlocations (locationID, aisleNum, shelfNum, rowNum, locationName, contents)
SELECT 	groupproject.locations.locationID,
		groupproject.locations.aisleNum,
        groupproject.locations.shelfNum,
        groupproject.locations.rowNum,
        CONCAT(groupproject.locations.aisleNum, '-', groupproject.locations.rowNum, '-', groupproject.locations.shelfNum) AS Location,
        (SELECT GROUP_CONCAT(dimbooks.bookTitle SEPARATOR ', ')
        FROM dimbooks
        WHERE AisleRowShelf = Location) AS contents
FROM groupproject.locations;

CREATE TABLE `dimborrowers` (
  `borrowerID` int(11) NOT NULL,
  `borrowerName` varchar(45) NOT NULL,
  `borrowerAddress` varchar(45) NOT NULL,
  `borrowerCity` varchar(45) NOT NULL,
  `borrowerState` varchar(45) NOT NULL,
  `borrowerZip` varchar(45) NOT NULL,
  `borrowerPhone` char(12) NOT NULL,
  `booksPastDue` char(1) NOT NULL,
  PRIMARY KEY (`borrowerID`)
);

INSERT INTO dimborrowers (borrowerID, borrowerName, borrowerAddress, borrowerCity, borrowerState, borrowerZip, borrowerPhone, booksPastDue)
SELECT 	groupproject.borrowers.borrowerID,
		groupproject.borrowers.borrowerName,
        groupproject.borrowers.borrowerAddress,
        groupproject.borrowers.borrowerCity,
        groupproject.borrowers.borrowerState,
        groupproject.borrowers.borrowerZip,
        groupproject.borrowers.borrowerPhone,
        IF(groupproject.loans.dueDate < current_date(), "Y", "N") AS booksPastDue
FROM groupproject.borrowers
LEFT JOIN groupproject.loans ON groupproject.borrowers.borrowerID = groupproject.loans.borrowerID;

CREATE TABLE `facts` (
  `bookID` int(11) DEFAULT NULL,
  `locationID` int(11) DEFAULT NULL,
  `borrowerID` int(11) DEFAULT NULL,
  `onLoan` bit(1) DEFAULT 0,
  `inStock` bit(1) DEFAULT 0,
  UNIQUE (`bookID`,`locationID`, `borrowerID`),
  KEY `bookID_idx` (`bookID`),
  KEY `locationID_idx` (`locationID`),
  KEY `borrowerID_idx` (`borrowerID`)
);

INSERT INTO facts(bookID, locationID, inStock)
SELECT 	groupproject.inventory.bookID,
		groupproject.inventory.locationID,
        groupproject.inventory.available
FROM groupproject.inventory;

INSERT INTO facts(bookID, borrowerID, onLoan)
SELECT 	groupproject.loans.bookID,
		groupproject.loans.borrowerID,
        1
FROM groupproject.loans;
