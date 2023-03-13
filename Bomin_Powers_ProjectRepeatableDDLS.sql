/*
	Author	: Bomin Powers
	Title	: Project Rawsome Pawsome
	Course	: IST659 M409
	Term	: April 2021
*/

-- drop all database objects in reverse order of their dependencies
-- including views, stored procedures and tables;

-- drop all procedures or trigger
DROP PROCEDURE IF EXISTS dbo.rp_pro_updIngredientIntoStock;
go
DROP TRIGGER IF EXISTS dbo.trg_ins2_MealPlanCall;
go
DROP TRIGGER IF EXISTS dbo.trg_ins1_MealPlanCall;
go
DROP TRIGGER IF EXISTS dbo.trg_ins_PetMealModel;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddMealModelTypeAmount_BARF;
go
DROP TRIGGER IF EXISTS dbo.trg_upd_IngredientStock;
go
DROP TRIGGER IF EXISTS dbo.trg_upd2_IngredientStock;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddIngredientIntoStock;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddIngredientPartIntoStore;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddIngredientSourceIntoStore;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddNutritionPart;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddNutritionSource;
go
DROP TRIGGER IF EXISTS dbo.trg_ins_PetHealthinfo;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddPetHealthinfo;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddPet;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddStock;
go
DROP PROCEDURE IF EXISTS dbo.rp_pro_AddOwner;
go

-- drop all views
DROP VIEW IF EXISTS dbo.rp_v_OwnerPet;
go
DROP VIEW IF EXISTS dbo.rp_v_StockReport;
go
DROP VIEW IF EXISTS dbo.rp_v_PetPreferenceCount;
go
DROP VIEW IF EXISTS dbo.rp_v_MealPlanCallhelp;
go
DROP VIEW IF EXISTS dbo.rp_v_CompletePlans;
go
DROP VIEW IF EXISTS dbo.rp_v_UpdateIngredientStock;
go

-- drop all tables in reverse order of their dependencies
DROP TABLE IF EXISTS dbo.rp_MealModelPartAmount;
go
DROP TABLE IF EXISTS dbo.rp_CompleteMealPlan;
go
DROP TABLE IF EXISTS dbo.rp_MealPlanCall;
go
DROP TABLE IF EXISTS dbo.rp_MealModelTypeAmount;
go
DROP TABLE IF EXISTS dbo.rp_PetMealModel;
go
DROP TABLE IF EXISTS dbo.rp_MealModelRatio;
go
DROP TABLE IF EXISTS dbo.rp_MealModel;
go
DROP TABLE IF EXISTS dbo.rp_IngredientStockUpdate;
go
DROP TABLE IF EXISTS dbo.rp_IngredientStock;
go
DROP TABLE IF EXISTS dbo.rp_IngredientStore;
go
DROP TABLE IF EXISTS dbo.rp_Store;
go
DROP TABLE IF EXISTS dbo.rp_Stock;
go
DROP TABLE IF EXISTS dbo.rp_PetPreference;
go
DROP TABLE IF EXISTS dbo.rp_IngredientNutritionFacts;
go
DROP TABLE IF EXISTS dbo.rp_IngredientDetail;
go
DROP TABLE IF EXISTS dbo.rp_IngredientType;
go
DROP TABLE IF EXISTS dbo.rp_PetRequiredCalorie;
go
DROP TABLE IF EXISTS dbo.rp_PetHealthinfo;
go
DROP TABLE IF EXISTS dbo.rp_Pet_ActivityRate;
go
DROP TABLE IF EXISTS dbo.rp_Pet_WeightCategory;
go
DROP TABLE IF EXISTS dbo.rp_Pet;
go
DROP TABLE IF EXISTS dbo.rp_Owner;
go

-- create all tables in order of their dependencies
CREATE TABLE rp_Owner
(
	rp_OwnerID int NOT NULL IDENTITY
	, OwnerFirstName varchar(30) NOT NULL
	, OwnerLastName varchar(30) NOT NULL
	, EmailAddress varchar(50) NOT NULL
	-- place constraints
	, CONSTRAINT rp_Owner_PK PRIMARY KEY (rp_OwnerID)
	, CONSTRAINT rp_Owner_U1 UNIQUE (EmailAddress)
);

CREATE TABLE rp_Pet
(
	rp_PetID int NOT NULL IDENTITY
	, PetName varchar(20) NOT NULL
	, PetType varchar(10) NOT NULL
	, DateOfBirth datetime NOT NULL
	, rp_OwnerID int NOT NULL
	-- place constraints
	, CONSTRAINT rp_Pet_PK PRIMARY KEY (rp_PetID)
	, CONSTRAINT rp_Pet_FK1 FOREIGN KEY (rp_OwnerID) REFERENCES rp_Owner (rp_OwnerID)
	-- limits values for PetType column
	, CONSTRAINT rp_Pet_chk_val CHECK (PetType in ('Dog','Cat'))
);

CREATE TABLE rp_Pet_WeightCategory
(
	rp_Pet_WeightCategoryID int NOT NULL IDENTITY
	, WeightCategory varchar(20) NOT NULL
	-- place constraints
	, CONSTRAINT rp_Pet_WeightCategory_PK PRIMARY KEY (rp_Pet_WeightCategoryID)
);

CREATE TABLE rp_Pet_ActivityRate
(
	rp_Pet_ActivityRateID int NOT NULL IDENTITY
	, ActivityLevel varchar(40) NOT NULL
	, EnergyNeeds decimal(6,2)
	-- place constraints
	, CONSTRAINT rp_Pet_ActivityRate_PK PRIMARY KEY (rp_Pet_ActivityRateID)
);

CREATE TABLE rp_PetHealthinfo
(
	rp_PetHealthinfoID int NOT NULL IDENTITY
	, PetWeight decimal(6,2) NOT NULL
	, rp_Pet_WeightCategoryID int NOT NULL
	, rp_Pet_ActivityRateID int NOT NULL
	, Spayed varchar(5) NOT NULL
	, rp_PetID int NOT NULL
	-- place constraints
	, CONSTRAINT rp_PetHealthinfo_PK PRIMARY KEY (rp_PetHealthinfoID)
	, CONSTRAINT rp_PetHealthinfo_FK1 FOREIGN KEY (rp_PetID) REFERENCES rp_Pet (rp_PetID)
	, CONSTRAINT rp_PetHealthinfo_FK2 FOREIGN KEY (rp_Pet_WeightCategoryID) REFERENCES rp_Pet_WeightCategory (rp_Pet_WeightCategoryID)
	, CONSTRAINT rp_PetHealthinfo_FK3 FOREIGN KEY (rp_Pet_ActivityRateID) REFERENCES rp_Pet_ActivityRate (rp_Pet_ActivityRateID)
	-- limits values for Spayed column
	, CONSTRAINT rp_PetHealthinfo_chk_val3 CHECK (Spayed in ('Yes','No'))
);

CREATE TABLE rp_PetRequiredCalorie
(
	rp_PetRequiredCalorieID int NOT NULL IDENTITY
	, rp_PetHealthinfoID int NOT NULL
	, PetRequiredCalorie int NOT NULL
	-- place constraints
	, CONSTRAINT rp_PetRequiredCalorie_PK PRIMARY KEY (rp_PetRequiredCalorieID)
	, CONSTRAINT rp_PetRequiredCalorie_FK1 FOREIGN KEY (rp_PetHealthinfoID) REFERENCES rp_PetHealthinfo (rp_PetHealthinfoID)
);

CREATE TABLE rp_IngredientType
(
	rp_IngredientTypeID int NOT NULL IDENTITY
	, IngredientType varchar(20) NOT NULL
	-- place constraints
	, CONSTRAINT rp_IngredientType_PK PRIMARY KEY (rp_IngredientTypeID)
	, CONSTRAINT rp_IngredientType_U1 UNIQUE (IngredientType)
);

CREATE TABLE rp_IngredientDetail
(
	rp_IngredientDetailID int NOT NULL IDENTITY
	, rp_IngredientTypeID int NOT NULL
	, IngredientSource varchar(20) NOT NULL
	, IngredientPart varchar(20)
	-- place constraints
	, CONSTRAINT rp_IngredientDetail_PK PRIMARY KEY (rp_IngredientDetailID)
	, CONSTRAINT rp_IngredientDetail_FK1 FOREIGN KEY (rp_IngredientTypeID) REFERENCES rp_IngredientType (rp_IngredientTypeID)
);

CREATE TABLE rp_IngredientNutritionFacts
(
	rp_IngredientNutritionFactsID int NOT NULL IDENTITY
	, rp_IngredientDetailID int NOT NULL
	, IngredientCalorie int NOT NULL
	, IngredientFat int
	, IngredientProtein int
	, IngredientCarbs int
	, IngredientFiber int
	, IngredientSugar int
	-- place constraints
	, CONSTRAINT rp_IngredientNutritionFacts_PK PRIMARY KEY (rp_IngredientNutritionFactsID)
	, CONSTRAINT rp_IngredientNutritionFacts_FK1 FOREIGN KEY (rp_IngredientDetailID) REFERENCES rp_IngredientDetail (rp_IngredientDetailID)
);

CREATE TABLE rp_PetPreference
(
	rp_PetPreferenceID int NOT NULL IDENTITY
	, rp_PetID int NOT NULL
	, rp_IngredientDetailID int NOT NULL
	-- place constraints
	, CONSTRAINT rp_PetPreference_PK PRIMARY KEY (rp_PetPreferenceID)
	, CONSTRAINT rp_PetPreference_FK1 FOREIGN KEY (rp_PetID) REFERENCES rp_Pet (rp_PetID)
	, CONSTRAINT rp_PetPreference_FK2 FOREIGN KEY (rp_IngredientDetailID) REFERENCES rp_IngredientDetail (rp_IngredientDetailID)
);

CREATE TABLE rp_Stock
(
	rp_StockID int NOT NULL IDENTITY
	, StorageName varchar(30) NOT NULL
	, rp_OwnerID int NOT NULL
	-- place constraints
	, CONSTRAINT rp_Stock_PK PRIMARY KEY (rp_StockID)
	, CONSTRAINT rp_Stock_FK1 FOREIGN KEY (rp_OwnerID) REFERENCES rp_Owner (rp_OwnerID)
);

CREATE TABLE rp_Store
(
	rp_StoreID int NOT NULL IDENTITY
	, StoreName varchar(30) NOT NULL
	-- place constraints
	, CONSTRAINT rp_Store_PK PRIMARY KEY (rp_StoreID)
);

CREATE TABLE rp_IngredientStore
(
	rp_IngredientStoreID int NOT NULL IDENTITY
	, rp_StoreID int NOT NULL
	, rp_IngredientDetailID int NOT NULL
	, IngredientPricePer100g  decimal(3,2) NOT NULL
	-- place constraints
	, CONSTRAINT rp_IngredientStore_PK PRIMARY KEY (rp_IngredientStoreID)
	, CONSTRAINT rp_IngredientStore_FK1 FOREIGN KEY (rp_StoreID) REFERENCES rp_Store (rp_StoreID)
	, CONSTRAINT rp_IngredientStore_FK2 FOREIGN KEY (rp_IngredientDetailID) REFERENCES rp_IngredientDetail (rp_IngredientDetailID)
);

CREATE TABLE rp_IngredientStock
(
	rp_IngredientStockID int NOT NULL IDENTITY
	, rp_StockID int NOT NULL
	, rp_IngredientStoreID int NOT NULL
	, IngredientAmount  decimal(6,2) NOT NULL
	, StoredDate datetime NOT NULL default GETDATE()
	, Finished varchar(3)
	-- place constraints
	, CONSTRAINT rp_IngredientStock_PK PRIMARY KEY (rp_IngredientStockID)
	, CONSTRAINT rp_IngredientStock_FK1 FOREIGN KEY (rp_StockID) REFERENCES rp_Stock (rp_StockID)
	, CONSTRAINT rp_IngredientStock_FK2 FOREIGN KEY (rp_IngredientStoreID) REFERENCES rp_IngredientStore (rp_IngredientStoreID)
);

CREATE TABLE rp_IngredientStockUpdate
(
	rp_IngredientStockUpdateID int NOT NULL IDENTITY
	, rp_IngredientStockID int NOT NULL
	, UpdatedDate datetime default GETDATE() NOT NULL
	-- place constraints
	, CONSTRAINT rp_IngredientStockUpdate_PK PRIMARY KEY (rp_IngredientStockUpdateID)
	, CONSTRAINT rp_IngredientStockUpdate_FK1 FOREIGN KEY (rp_IngredientStockID) REFERENCES rp_IngredientStock (rp_IngredientStockID)
);


CREATE TABLE rp_MealModel
(
	rp_MealModelID int NOT NULL IDENTITY
	, MealModelName varchar(10) NOT NULL
	, MealModelDescription varchar(50)
	-- place constraints
	, CONSTRAINT rp_MealModel_PK PRIMARY KEY (rp_MealModelID)
);

CREATE TABLE rp_MealModelRatio
(
	rp_MealModelRatioID int NOT NULL IDENTITY
	, rp_MealModelID int NOT NULL
	, rp_IngredientTypeID int NOT NULL
	, MealModelTypeRatio decimal(6,2) NOT NULL
	-- place constraints
	, CONSTRAINT rp_MealModelRatio_PK PRIMARY KEY (rp_MealModelRatioID)
	, CONSTRAINT rp_MealModelRatio_FK1 FOREIGN KEY (rp_MealModelID) REFERENCES rp_MealModel (rp_MealModelID)
	, CONSTRAINT rp_MealModelRatio_FK2 FOREIGN KEY (rp_IngredientTypeID) REFERENCES rp_IngredientType (rp_IngredientTypeID)
);

CREATE TABLE rp_PetMealModel
(
	rp_PetMealModelID int NOT NULL IDENTITY
	, rp_PetID int NOT NULL
	, rp_MealModelID int NOT NULL
	-- place constraints
	, CONSTRAINT rp_PetMealModel_PK PRIMARY KEY (rp_PetMealModelID)
	, CONSTRAINT rp_PetMealModel_FK1 FOREIGN KEY (rp_PetID) REFERENCES rp_Pet (rp_PetID)
	, CONSTRAINT rp_PetMealModel_FK2 FOREIGN KEY (rp_MealModelID) REFERENCES rp_MealModel (rp_MealModelID)
	, CONSTRAINT rp_PetMealModel_U1 UNIQUE (rp_PetID)
);

CREATE TABLE rp_MealModelTypeAmount
(
	rp_MealModelTypeAmountID int NOT NULL IDENTITY
	, rp_PetMealModelID int NOT NULL
	, rp_IngredientTypeID int NOT NULL
	, MealModelTypeAmount decimal(6,2) NOT NULL
	-- place constraints
	, CONSTRAINT rp_MealModelTypeAmount_PK PRIMARY KEY (rp_MealModelTypeAmountID)
	, CONSTRAINT rp_MealModelTypeAmount_FK1 FOREIGN KEY (rp_PetMealModelID) REFERENCES rp_PetMealModel (rp_PetMealModelID)
	, CONSTRAINT rp_MealModelTypeAmount_FK2 FOREIGN KEY (rp_IngredientTypeID) REFERENCES rp_IngredientType (rp_IngredientTypeID)
);

CREATE TABLE rp_MealPlanCall
(
	rp_MealPlanCallID int NOT NULL IDENTITY
	, rp_MealModelTypeAmountID int NOT NULL
	, rp_IngredientDetailID int NOT NULL
	, IngredientContents decimal(3,2) NOT NULL
	, MealPlanCallDate date NOT NULL
	-- place constraints
	, CONSTRAINT rp_MealPlanCall_PK PRIMARY KEY (rp_MealPlanCallID)
	, CONSTRAINT rp_MealPlanCall_FK1 FOREIGN KEY (rp_MealModelTypeAmountID) REFERENCES rp_MealModelTypeAmount (rp_MealModelTypeAmountID)
	, CONSTRAINT rp_MealPlanCall_FK2 FOREIGN KEY (rp_IngredientDetailID) REFERENCES rp_IngredientDetail (rp_IngredientDetailID)
);

CREATE TABLE rp_CompleteMealPlan
(
	rp_CompleteMealPlanID int NOT NULL IDENTITY
	, rp_PetID int NOT NULL
	, SuggestedDate date NOT NULL
	-- place constraints
	, CONSTRAINT rp_CompleteMealPlan_PK PRIMARY KEY (rp_CompleteMealPlanID)
	, CONSTRAINT rp_CompleteMealPlan_FK1 FOREIGN KEY (rp_PetID) REFERENCES rp_Pet (rp_PetID)
);
GO

CREATE TABLE rp_MealModelPartAmount
(
	rp_MealModelPartAmountID int NOT NULL IDENTITY
	, rp_CompleteMealPlanID int NOT NULL
	, rp_MealPlanCallID int NOT NULL 
	, MealModelPartAmount decimal(6,2) NOT NULL
	-- place constraints
	, CONSTRAINT rp_MealModelPartAmount_PK PRIMARY KEY (rp_MealModelPartAmountID)
	, CONSTRAINT rp_MealModelPartAmount_FK1 FOREIGN KEY (rp_CompleteMealPlanID) REFERENCES rp_CompleteMealPlan (rp_CompleteMealPlanID)
	, CONSTRAINT rp_MealModelPartAmount_FK2 FOREIGN KEY (rp_MealPlanCallID) REFERENCES rp_MealPlanCall (rp_MealPlanCallID)
);
GO

---------------------------------------------------------------------------------------------------------------------------------------------------
-- create procedures
-- Add Owner procedures
CREATE OR ALTER PROCEDURE rp_pro_AddOwner (@firstName varchar(30), @lastName varchar(30), @email varchar(50))
AS
	-- clarify there is same Email Address value
	IF EXISTS
	(
		SELECT * FROM rp_Owner WHERE EmailAddress = @email
	)
BEGIN
	PRINT 'Unique value(=EmailAddress) existed'
	RETURN (SELECT rp_OwnerID FROM rp_Owner WHERE EmailAddress = @email);
END
ELSE
BEGIN
	INSERT INTO rp_Owner (OwnerFirstName, OwnerLastName, EmailAddress)
	VALUES (@firstName, @lastName, @email)
	PRINT 'Inserted Owner'
	RETURN SCOPE_IDENTITY()
END
GO

-- Add Stock procedures
CREATE OR ALTER PROCEDURE rp_pro_AddStock (@email varchar(50), @storageName varchar(30))
AS
BEGIN
	-- We have a owner email address but we need the owner ID
	-- Declare a variable to hold the ID
	DECLARE @ownerID int
	SELECT @ownerID = rp_OwnerID FROM rp_Owner
	WHERE EmailAddress = @email
	-- Add the row
	INSERT INTO rp_Stock(rp_OwnerID, StorageName)
	VALUES (@ownerID, @storageName)
	RETURN SCOPE_IDENTITY()
END
GO

-- Add Pet procedures
CREATE OR ALTER PROCEDURE rp_pro_AddPet (@email varchar(50), @petName varchar(20), @petType varchar(10), @DOB datetime)
AS
BEGIN
	-- We have a owner email address but we need the owner ID
	-- Declare a variable to hold the ID
	DECLARE @ownerID int
	SELECT @ownerID = rp_OwnerID FROM rp_Owner
	WHERE EmailAddress = @email
	-- Add the row
	INSERT INTO rp_Pet (rp_OwnerID, PetName, PetType, DateOfBirth)
	VALUES (@ownerID, @petName, @petType, @DOB)
	RETURN SCOPE_IDENTITY()
END
GO

-- Add Pet health info procedures
CREATE OR ALTER PROCEDURE rp_pro_AddPetHealthinfo (@email varchar(50), @petName varchar(20), @weight decimal(6,2), @weightCT int, @activity int, @spayed varchar(5))
AS
BEGIN
	-- We have a pet name but we need the pet ID
	-- Declare a variable to hold the ID
	DECLARE @ownerID int
	SELECT @ownerID = rp_OwnerID FROM rp_Owner
	WHERE EmailAddress = @email
	DECLARE @petID int
	SELECT @petID = rp_PetID FROM rp_Pet WHERE rp_OwnerID = @ownerID AND PetName = @petName
	-- Add the row
	INSERT INTO rp_PetHealthinfo (rp_PetID, PetWeight, rp_Pet_WeightCategoryID, rp_Pet_ActivityRateID, Spayed)
	VALUES (@petID, @weight, @weightCT, @activity, @spayed)
	RETURN SCOPE_IDENTITY()
END
GO

-- trigger that is fired whenever insert/update occurs against rp_PetHealthinfo table
CREATE OR ALTER TRIGGER trg_ins_PetHealthinfo
ON rp_PetHealthinfo
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @weight decimal(6,2)
		, @arID int
		, @energy decimal(6,2)
		, @cal int
		, @healthinfoID int
	SELECT @weight = PetWeight FROM inserted decimal
	SELECT @arID = rp_Pet_ActivityRateID FROM inserted
	SELECT @energy = EnergyNeeds FROM rp_Pet_ActivityRate WHERE rp_Pet_ActivityRateID = @arID
	SELECT @cal = ((30*@weight)+70)*@energy
	SELECT @healthinfoID = rp_PetHealthinfoID FROM inserted
	INSERT INTO rp_PetRequiredCalorie (
		rp_PetHealthinfoID,
		PetRequiredCalorie
		)
	SELECT
		@healthinfoID,
		@cal
	PRINT 'We successfully Fired Triggers for calculating pets required Calorie'
END
GO

-- Add ingredient nutrition (type,source) procedures
CREATE OR ALTER PROCEDURE rp_pro_AddNutritionSource (@type varchar(20), @source varchar(20), @calorie int, @protein int, @fat int, @carbs int, @fiber int, @sugar int)
AS
BEGIN
	DECLARE @typeID int
	SELECT @typeID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType = @type
	DECLARE @detailID int
	SELECT @detailID = rp_IngredientDetailID FROM rp_IngredientDetail
	WHERE rp_IngredientTypeID = @typeID AND IngredientSource = @source
	-- Add the row
	INSERT INTO rp_IngredientNutritionFacts(rp_IngredientDetailID, IngredientCalorie, IngredientProtein, IngredientFat, IngredientCarbs, IngredientFiber, IngredientSugar)
	VALUES (@detailID, @calorie, @protein, @fat, @carbs, @fiber, @sugar)
	RETURN SCOPE_IDENTITY()
END
GO

-- Add ingredient nutrition (type,source,part) procedures
CREATE OR ALTER PROCEDURE rp_pro_AddNutritionPart (@type varchar(20), @source varchar(20), @part varchar(20), @calorie int, @protein int, @fat int, @carbs int, @fiber int, @sugar int)
AS
BEGIN
	DECLARE @typeID int
	SELECT @typeID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType = @type
	DECLARE @detailID int
	SELECT @detailID = rp_IngredientDetailID FROM rp_IngredientDetail
	WHERE rp_IngredientTypeID = @typeID AND IngredientSource = @source AND IngredientPart = @part
	-- Add the row
	INSERT INTO rp_IngredientNutritionFacts(rp_IngredientDetailID, IngredientCalorie, IngredientProtein, IngredientFat, IngredientCarbs, IngredientFiber, IngredientSugar)
	VALUES (@detailID, @calorie, @protein, @fat, @carbs, @fiber, @sugar)
	RETURN SCOPE_IDENTITY()
END
GO

-- Add ingredient price info into store (type,source) procedures
CREATE OR ALTER PROCEDURE rp_pro_AddIngredientSourceIntoStore (@storeN varchar(30), @type varchar(20), @source varchar(20), @price decimal(6,2))
AS
BEGIN
	DECLARE @storeID int
	SELECT @storeID = rp_StoreID FROM rp_Store
	WHERE StoreName = @storeN
	DECLARE @typeID int
	SELECT @typeID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType = @type
	DECLARE @detailID int
	SELECT @detailID = rp_IngredientDetailID FROM rp_IngredientDetail
	WHERE rp_IngredientTypeID = @typeID AND IngredientSource = @source
	-- Add the row
	INSERT INTO rp_IngredientStore(rp_StoreID, rp_IngredientDetailID, IngredientPricePer100g)
	VALUES (@storeID, @detailID, @price)
	RETURN SCOPE_IDENTITY()
END
GO

-- Add ingredient price info into store (type,source,part) procedures
CREATE OR ALTER PROCEDURE rp_pro_AddIngredientPartIntoStore (@storeN varchar(30), @type varchar(20), @source varchar(20), @part varchar(20), @price decimal(6,2))
AS
BEGIN
	DECLARE @storeID int
	SELECT @storeID = rp_StoreID FROM rp_Store
	WHERE StoreName = @storeN
	DECLARE @typeID int
	SELECT @typeID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType = @type
	DECLARE @detailID int
	SELECT @detailID = rp_IngredientDetailID FROM rp_IngredientDetail
	WHERE rp_IngredientTypeID = @typeID AND IngredientSource = @source AND IngredientPart = @part
	-- Add the row
	INSERT INTO rp_IngredientStore(rp_StoreID, rp_IngredientDetailID, IngredientPricePer100g)
	VALUES (@storeID, @detailID, @price)
	RETURN SCOPE_IDENTITY()
END
GO

-- Add ingredient into stock procedures
CREATE OR ALTER PROCEDURE rp_pro_AddIngredientIntoStock 
(@email varchar(50), @stkName varchar(30), @storeN varchar(30), @type varchar(20), @source varchar(20), @part varchar(20) = NULL, @amount int, @date datetime = NULL)
AS
BEGIN
	DECLARE @stkID int
	SELECT @stkID = rp_StockID FROM rp_Stock
	WHERE rp_OwnerID = (SELECT rp_OwnerID FROM rp_Owner WHERE EmailAddress = @email) AND StorageName = @stkName
	DECLARE @strID int
	SELECT @strID = rp_StoreID FROM rp_Store WHERE StoreName = @storeN
	DECLARE @typeID int
	SELECT @typeID = rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = @type
	DECLARE @detailID int
	SELECT @detailID = rp_IngredientDetailID FROM rp_IngredientDetail
	WHERE rp_IngredientTypeID = @typeID AND IngredientSource = @source OR IngredientPart = @part
	DECLARE @ingstrID int
	SELECT @ingstrID = rp_IngredientStoreID FROM rp_IngredientStore WHERE rp_StoreID = @strID AND rp_IngredientDetailID = @detailID
	-- if condision for date value
	IF @date IS NULL
		BEGIN SET @date = GETDATE()
	END
	-- Add the row
	INSERT INTO rp_IngredientStock(rp_StockID, rp_IngredientStoreID, IngredientAmount, StoredDate)
	VALUES (@stkID, @ingstrID, @amount, @date)
	RETURN SCOPE_IDENTITY()
END
GO

-- trigger that is fired whenever update occurs against rp_IngredientStock table
CREATE TRIGGER trg_upd_IngredientStock
ON rp_IngredientStock
FOR UPDATE
AS
BEGIN
	INSERT INTO rp_IngredientStockUpdate (
		rp_IngredientStockID,
		UpdatedDate
		)
	SELECT
		rp_IngredientStockID,
		GETDATE()
	FROM inserted
END
GO

-- trigger that is fired when specific update (ingredient amount is updated to 0) occurs against rp_IngredientStock table
CREATE TRIGGER trg_upd2_IngredientStock
ON rp_IngredientStock
AFTER UPDATE
AS
BEGIN
	SET NOCOUNT ON;
	-- specific update = ingredient amount updated to 0g
	UPDATE rp_IngredientStock SET Finished = 'Y'
	FROM rp_IngredientStock t
	INNER JOIN inserted i on t.rp_IngredientStockID = i.rp_IngredientStockID
	AND i.IngredientAmount = 0
END
GO

-- Add meal model type amount by calcultaing within the data we already have
-- for BARF meal model
CREATE OR ALTER  PROCEDURE rp_pro_AddMealModelTypeAmount_BARF (@petName varchar(20))
AS
BEGIN
	DECLARE @mealmodelID int
	SELECT @mealmodelID = rp_PetMealModelID FROM rp_PetMealModel
	WHERE rp_PetID = (SELECT rp_PetID FROM rp_Pet WHERE PetName = @petName)
	-- declare type1:7 from BARF model
	DECLARE @type1ID int
	SELECT @type1ID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType ='Muscle meat'
	DECLARE @type2ID int
	SELECT @type2ID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType ='Edible bone'
	DECLARE @type3ID int
	SELECT @type3ID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType ='Organ'
	DECLARE @type4ID int
	SELECT @type4ID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType ='Liver'
	DECLARE @type5ID int
	SELECT @type5ID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType ='Vegetable'
	DECLARE @type6ID int
	SELECT @type6ID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType ='Fruits'
	DECLARE @type7ID int
	SELECT @type7ID = rp_IngredientTypeID FROM rp_IngredientType
	WHERE IngredientType ='Seeds/Nuts'
	-- declare required calorie for pet
	DECLARE @cal int
	SELECT @cal = PetRequiredCalorie FROM rp_PetRequiredCalorie
	WHERE rp_PetHealthinfoID = (SELECT rp_PetHealthinfoID FROM rp_PetHealthinfo WHERE rp_PetID = 
	(SELECT rp_PetID FROM rp_Pet WHERE PetName = @petName))
	-- declare ingredient amount of each type
	DECLARE @t1amount decimal(6,2)
	SELECT @t1amount = @cal * (SELECT MealModelTypeRatio FROM rp_MealModelRatio WHERE rp_IngredientTypeID = @type1ID)
	DECLARE @t2amount decimal(6,2)
	SELECT @t2amount = @cal * (SELECT MealModelTypeRatio FROM rp_MealModelRatio WHERE rp_IngredientTypeID = @type2ID)
	DECLARE @t3amount decimal(6,2)
	SELECT @t3amount = @cal * (SELECT MealModelTypeRatio FROM rp_MealModelRatio WHERE rp_IngredientTypeID = @type3ID)
	DECLARE @t4amount decimal(6,2)
	SELECT @t4amount = @cal * (SELECT MealModelTypeRatio FROM rp_MealModelRatio WHERE rp_IngredientTypeID = @type4ID)
	DECLARE @t5amount decimal(6,2)
	SELECT @t5amount = @cal * (SELECT MealModelTypeRatio FROM rp_MealModelRatio WHERE rp_IngredientTypeID = @type5ID)
	DECLARE @t6amount decimal(6,2)
	SELECT @t6amount = @cal * (SELECT MealModelTypeRatio FROM rp_MealModelRatio WHERE rp_IngredientTypeID = @type6ID)
	DECLARE @t7amount decimal(6,2)
	SELECT @t7amount = @cal * (SELECT MealModelTypeRatio FROM rp_MealModelRatio WHERE rp_IngredientTypeID = @type7ID)
	 -- Add the row
	INSERT INTO rp_MealModelTypeAmount (rp_PetMealModelID, rp_IngredientTypeID, MealModelTypeAmount)
	VALUES	(@mealmodelID, @type1ID, @t1amount)
			, (@mealmodelID, @type2ID, @t2amount)
			, (@mealmodelID, @type3ID, @t3amount)
			, (@mealmodelID, @type4ID, @t4amount)
			, (@mealmodelID, @type5ID, @t5amount)
			, (@mealmodelID, @type6ID, @t6amount)
			, (@mealmodelID, @type7ID, @t7amount)
	RETURN SCOPE_IDENTITY()
END
GO

-- trigger that is fired when occurs against rp_PetMealModel table
CREATE TRIGGER trg_ins_PetMealModel
ON rp_PetMealModel
AFTER INSERT, UPDATE
AS
BEGIN
	DECLARE @petN varchar(20)
	SELECT @petN = PetName FROM rp_Pet WHERE rp_PetID = (SELECT rp_PetID FROM inserted)

	EXEC rp_pro_AddMealModelTypeAmount_BARF @petN
	PRINT 'We successfully Fired Triggers for calculating pets required ingredient type amount by type'
END
GO

-- trigger that is fired when occurs against rp_PetMealModel table
CREATE OR ALTER TRIGGER trg_ins1_MealPlanCall
ON rp_MealPlanCall
AFTER INSERT
AS
BEGIN
	DECLARE @mmtaID int
		, @petmmID int
		, @petID int
		, @calldate date
	SELECT @mmtaID = rp_MealModelTypeAmountID FROM inserted
	SELECT @petmmID = rp_PetMealModelID FROM rp_MealModelTypeAmount WHERE rp_MealModelTypeAmountID=@mmtaID
	SELECT @petID = rp_PetID FROM rp_PetMealModel WHERE rp_PetMealModelID = @petmmID
	SELECT @calldate = MealPlanCallDate FROM inserted
		-- if condition
		IF NOT EXISTS (SELECT rp_CompleteMealPlanID FROM rp_CompleteMealPlan WHERE rp_PetID = @petID AND SuggestedDate = @calldate)
			BEGIN
			INSERT INTO rp_CompleteMealPlan (rp_PetID, SuggestedDate)
			SELECT @petID, @calldate
			PRINT 'We successfully Fired Triggers for inserting raw into rp_CompleteMealPlan'
		END -- if END
END
GO

-- trigger that is fired when insert occurs against rp_MealPlanCall table
-- Add meal model part amount by calcultaing within the data we already have
CREATE OR ALTER TRIGGER trg_ins2_MealPlanCall
ON rp_MealPlanCall
AFTER INSERT
AS
BEGIN
	DECLARE @ingDID int
		, @mpcID int
		, @ingCon decimal(3,2)
		, @mmtaID int
		, @petmmID int
		, @petID int
		, @commpID int
		, @requiredTcal int
		, @calforingD int
		, @ingcal int
		, @mmpa decimal(6,2)
		
	SELECT @ingDID = rp_IngredientDetailID FROM inserted
	SELECT @mpcID = rp_MealPlanCallID FROM inserted
	SELECT @ingCon = IngredientContents FROM inserted
	SELECT @mmtaID = rp_MealModelTypeAmountID FROM inserted
	SELECT @petmmID = rp_PetMealModelID FROM rp_MealModelTypeAmount WHERE rp_MealModelTypeAmountID = @mmtaID
	SELECT @petID = rp_PetID FROM rp_PetMealModel WHERE rp_PetMealModelID = @petmmID
	SELECT @commpID = rp_CompleteMealPlanID FROM rp_CompleteMealPlan WHERE rp_PetID = @petID AND SuggestedDate = (SELECT MealPlanCallDate FROM inserted)
	SELECT @requiredTcal = MealModelTypeAmount FROM rp_MealModelTypeAmount WHERE rp_MealModelTypeAmountID = @mmtaID
	SELECT @calforingD = @requiredTcal * @ingCon
	SELECT @ingcal = IngredientCalorie FROM rp_IngredientNutritionFacts WHERE rp_IngredientDetailID = @ingDID
	SELECT @mmpa = @calforingD*100/@ingcal
	INSERT INTO rp_MealModelPartAmount (
		rp_CompleteMealPlanID,
		rp_MealPlanCallID,
		MealModelPartAmount
		)
	SELECT
		@commpID,
		@mpcID,
		@mmpa
	PRINT 'We successfully Fired Triggers for calculating pets required amount for ingredient'
END
GO

CREATE OR ALTER PROCEDURE rp_pro_updIngredientIntoStock (@stkID int, @ingstrID int, @amount decimal(6,2))
AS
BEGIN
		DECLARE @amountexist decimal(6,2)
		SELECT @amountexist =  IngredientAmount FROM rp_IngredientStock 
		WHERE rp_IngredientStockID = @stkID AND rp_IngredientStoreID = @ingstrID 
		-- update stock's ingredient amount
		UPDATE rp_IngredientStock SET IngredientAmount = @amountexist-@amount
		WHERE rp_IngredientStockID = @stkID AND rp_IngredientStoreID = @ingstrID
END
GO

--------------------------------------------------------------------------------------------------------------------
-- INSERT RECORD INTO TABLE;
-- insert weight category
INSERT INTO rp_Pet_WeightCategory(WeightCategory)
	VALUES
		('UnderWeight'),('Ideal'),('OverWeight');
GO

-- insert activity rate
INSERT INTO rp_Pet_ActivityRate(ActivityLevel, EnergyNeeds)
	VALUES
		('Low activity -Dog', 1),('Moderate activity -Dog', 1.3),('Average active -Dog', 1.5),('High intensity active -Dog',1.7),
		('Low activity -Cat', 1),('Neutered -Cat', 1.2),('Average active -Cat', 1.4);
GO

-- insert store
INSERT INTO rp_Store(StoreName)
	VALUES
		('Aeon awase'),('Rycom'),('Safeway'),('Whole Foods Market');
GO

-- insert owner
EXEC rp_pro_AddOwner 'Bomin', 'Powers', 'bominp@abc.com'
EXEC rp_pro_AddOwner 'James', 'Smith', 'james@abc.com'
EXEC rp_pro_AddOwner 'Maria', 'Garcia', 'maria@abc.com'
EXEC rp_pro_AddOwner 'Robert', 'Johnson', 'robert@abc.com'
EXEC rp_pro_AddOwner 'Jennifer', 'Brown', 'jennifer@abc.com'
EXEC rp_pro_AddOwner 'Michael', 'Jones', 'michael@abc.com'
EXEC rp_pro_AddOwner 'Linda', 'Miller', 'linda@abc.com'
EXEC rp_pro_AddOwner 'William', 'Davis', 'william@abc.com'
EXEC rp_pro_AddOwner 'Jose', 'Rodriguez', 'jose@abc.com'
EXEC rp_pro_AddOwner 'Miguel', 'Martinez', 'miguel@abc.com'
EXEC rp_pro_AddOwner 'Barbara', 'Wilson', 'barbara@abc.com'
EXEC rp_pro_AddOwner 'Karen', 'Anderson', 'karen@abc.com'
EXEC rp_pro_AddOwner 'Richard', 'Moore', 'richard@abc.com'
EXEC rp_pro_AddOwner 'Jessica', 'Jackson', 'jessica@abc.com'
EXEC rp_pro_AddOwner 'Christopher', 'Martin', 'christopher@abc.com'
EXEC rp_pro_AddOwner 'Sandra', 'Lee', 'sandra@abc.com'
EXEC rp_pro_AddOwner 'Anthony', 'Thompson', 'anthony@abc.com'
EXEC rp_pro_AddOwner 'Donald', 'White', 'donald@abc.com'
EXEC rp_pro_AddOwner 'Emily', 'Harris', 'emily@abc.com'
EXEC rp_pro_AddOwner 'Paul', 'Lewis', 'paul@abc.com'
GO

-- insert stock
EXEC rp_pro_AddStock 'bominp@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'james@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'maria@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'robert@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'jennifer@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'michael@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'linda@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'william@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'jose@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'miguel@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'barbara@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'karen@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'richard@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'jessica@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'christopher@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'sandra@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'anthony@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'donald@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'emily@abc.com', 'Ref1'
EXEC rp_pro_AddStock 'paul@abc.com', 'Ref1'
GO

-- insert pet
EXEC rp_pro_AddPet 'bominp@abc.com', 'Kinako', 'Dog', '2020/5/12'
EXEC rp_pro_AddPet 'bominp@abc.com', 'Porsche', 'Cat', '2016/4/27'
EXEC rp_pro_AddPet 'bominp@abc.com', 'Rati', 'Cat', '2016/4/27'
EXEC rp_pro_AddPet 'james@abc.com', 'Max', 'Dog', '2010/7/01'
EXEC rp_pro_AddPet 'maria@abc.com', 'Charlie', 'Cat', '2020/1/10'
EXEC rp_pro_AddPet 'maria@abc.com', 'Sammy', 'Cat', '2016/5/10'
EXEC rp_pro_AddPet 'maria@abc.com', 'Luna', 'Cat', '2009/4/5'
EXEC rp_pro_AddPet 'robert@abc.com', 'Murphy', 'Dog', '2019/5/01'
EXEC rp_pro_AddPet 'jennifer@abc.com', 'Molly', 'Dog', '2017/2/28'
EXEC rp_pro_AddPet 'jennifer@abc.com', 'Panda', 'Cat', '2019/10/30'
EXEC rp_pro_AddPet 'linda@abc.com', 'Lola', 'Dog', '2015/8/10'
EXEC rp_pro_AddPet 'william@abc.com', 'Cooper', 'Dog', '2013/4/12'
EXEC rp_pro_AddPet 'jose@abc.com', 'Ruby', 'Dog', '2014/9/15'
EXEC rp_pro_AddPet 'jose@abc.com', 'Annie', 'Dog', '2014/9/15'
EXEC rp_pro_AddPet 'miguel@abc.com', 'Teddy', 'Dog', '2019/12/20'
EXEC rp_pro_AddPet 'barbara@abc.com', 'Oliver', 'Dog', '2018/3/25'
EXEC rp_pro_AddPet 'karen@abc.com', 'Leo', 'Cat', '2020/5/12'
EXEC rp_pro_AddPet 'richard@abc.com', 'Bella', 'Dog', '2017/11/12'
EXEC rp_pro_AddPet 'jessica@abc.com', 'Duke', 'Dog', '2013/1/2'
EXEC rp_pro_AddPet 'jessica@abc.com', 'Riley', 'Dog', '2015/8/19'
EXEC rp_pro_AddPet 'jessica@abc.com', 'Lily', 'Dog', '2020/1/15'
EXEC rp_pro_AddPet 'jessica@abc.com', 'Nala', 'Dog', '2021/3/5'
EXEC rp_pro_AddPet 'christopher@abc.com', 'Zeus', 'Cat', '2010/4/2'
EXEC rp_pro_AddPet 'sandra@abc.com', 'Hank', 'Dog', '2017/6/25'
EXEC rp_pro_AddPet 'anthony@abc.com', 'Mia', 'Cat', '2014/4/10'
EXEC rp_pro_AddPet 'anthony@abc.com', 'Moose', 'Cat', '2018/7/6'
EXEC rp_pro_AddPet 'anthony@abc.com', 'Nova', 'Cat', '2020/12/10'
EXEC rp_pro_AddPet 'donald@abc.com', 'Lucky', 'Dog', '2017/6/12'
EXEC rp_pro_AddPet 'emily@abc.com', 'Lexi', 'Dog', '2019/9/15'
EXEC rp_pro_AddPet 'emily@abc.com', 'Remi', 'Dog', '2017/2/10'
EXEC rp_pro_AddPet 'paul@abc.com', 'Baxter', 'Dog', '2018/8/8'
GO

-- insert pet health info
EXEC rp_pro_AddPetHealthinfo 'bominp@abc.com','Kinako', 7.8, 2, 2, 'YES'
EXEC rp_pro_AddPetHealthinfo 'bominp@abc.com','Porsche', 3.9, 3, 5, 'YES'
EXEC rp_pro_AddPetHealthinfo 'bominp@abc.com','Rati', 4, 2, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'james@abc.com','Max', 35, 2, 3, 'YES'
EXEC rp_pro_AddPetHealthinfo 'maria@abc.com','Charlie', 5.4, 2, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'maria@abc.com','Sammy', 5.2, 2, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'maria@abc.com','Luna', 7.6, 2, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'robert@abc.com','Murphy', 25, 2, 2, 'NO'
EXEC rp_pro_AddPetHealthinfo 'jennifer@abc.com', 'Molly', 12, 3, 1, 'YES'
EXEC rp_pro_AddPetHealthinfo 'jennifer@abc.com', 'Panda', 3, 1, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'linda@abc.com', 'Lola', 22, 2, 4, 'NO'
EXEC rp_pro_AddPetHealthinfo 'william@abc.com', 'Cooper', 24, 3, 1, 'YES'
EXEC rp_pro_AddPetHealthinfo 'jose@abc.com', 'Ruby', 17, 2, 2, 'YES'
EXEC rp_pro_AddPetHealthinfo 'jose@abc.com', 'Annie', 5, 2, 2, 'YES'
EXEC rp_pro_AddPetHealthinfo 'miguel@abc.com', 'Teddy', 30, 2, 4, 'YES'
EXEC rp_pro_AddPetHealthinfo 'barbara@abc.com', 'Oliver', 36, 3, 2, 'YES'
EXEC rp_pro_AddPetHealthinfo 'karen@abc.com', 'Leo', 7, 3, 5, 'NO'
EXEC rp_pro_AddPetHealthinfo 'richard@abc.com', 'Bella', 14, 2, 4, 'YES'
EXEC rp_pro_AddPetHealthinfo 'jessica@abc.com', 'Duke', 31, 2, 4, 'YES'
EXEC rp_pro_AddPetHealthinfo 'jessica@abc.com', 'Riley', 28, 2, 4, 'YES'
EXEC rp_pro_AddPetHealthinfo 'jessica@abc.com', 'Lily', 20, 2, 4, 'YES'
EXEC rp_pro_AddPetHealthinfo 'jessica@abc.com', 'Nala', 34, 2, 4, 'YES'
EXEC rp_pro_AddPetHealthinfo 'christopher@abc.com', 'Zeus', 6.5, 2, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'sandra@abc.com', 'Hank', 43, 2, 4, 'NO'
EXEC rp_pro_AddPetHealthinfo 'anthony@abc.com', 'Mia', 4.5, 2, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'anthony@abc.com', 'Moose', 5.8, 2, 6, 'YES'
EXEC rp_pro_AddPetHealthinfo 'anthony@abc.com', 'Nova', 6.2, 3, 5, 'YES'
EXEC rp_pro_AddPetHealthinfo 'donald@abc.com', 'Lucky', 42, 2, 4, 'NO'
EXEC rp_pro_AddPetHealthinfo 'emily@abc.com', 'Lexi', 38, 2, 4, 'YES'
EXEC rp_pro_AddPetHealthinfo 'emily@abc.com', 'Remi', 4, 2, 3, 'YES'
EXEC rp_pro_AddPetHealthinfo 'paul@abc.com', 'Baxter', 36, 2, 4, 'NO'
GO

			/*-- Verify that the PetHealthinfo trigger for calculating the required calories works well
			SELECT
				rp_Pet.PetName
				, rp_PetRequiredCalorie.PetRequiredCalorie
			FROM rp_PetHealthinfo
			JOIN rp_Pet ON rp_PetHealthinfo.rp_PetID = rp_Pet.rp_PetID
			JOIN rp_PetRequiredCalorie ON rp_PetHealthinfo.rp_PetHealthinfoID = rp_PetRequiredCalorie.rp_PetHealthinfoID
			*/

-- insert ingredient type
INSERT INTO rp_IngredientType(IngredientType) 
	VALUES ('Muscle meat'), ('Edible bone'), ('Organ'), ('Liver'), ('Vegetable'), ('Fruits'), ('Seeds/Nuts')

-- insert ingredient detail
	-- Muscle meat--
	INSERT INTO rp_IngredientDetail (rp_IngredientTypeID, IngredientSource) 
		VALUES	((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Chicken')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Pork')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Beef')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Rabbit')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Turkey')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Lamb')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Goat')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 'Duck')
	GO
	-- Edible bone--
	INSERT INTO rp_IngredientDetail (rp_IngredientTypeID, IngredientSource, IngredientPart) 
		VALUES	((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Edible bone'), 'Chicken' , 'Wing')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Edible bone'), 'Duck' , 'Wing')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Edible bone'), 'Chicken' , 'Neck')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Edible bone'), 'Turkey' , 'Neck')
	GO
	-- Organ--
	INSERT INTO rp_IngredientDetail (rp_IngredientTypeID, IngredientSource, IngredientPart) 
		VALUES	((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Beef' , 'Kidney')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Beef' , 'Spleen')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Chicken' , 'Heart')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Beef' , 'Heart')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Pork' , 'Heart')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Pork' , 'Lung')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Beef' , 'Lung')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Lamb' , 'Lung')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 'Chicken' , 'Gizzard')
	GO
	-- Liver --
	INSERT INTO rp_IngredientDetail (rp_IngredientTypeID, IngredientSource) 
		VALUES	((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Liver'), 'Chicken')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Liver'), 'Pork')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Liver'), 'Beef')
	GO
	-- Vegetable --
	INSERT INTO rp_IngredientDetail (rp_IngredientTypeID, IngredientSource) 
		VALUES	((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Vegetable'), 'Broccoli')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Vegetable'), 'Spinach')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Vegetable'), 'Kale')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Vegetable'), 'Carrot')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Vegetable'), 'Cauliflower')
	GO
	-- Fruits --
	INSERT INTO rp_IngredientDetail (rp_IngredientTypeID, IngredientSource) 
		VALUES	((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Fruits'), 'Blueberries')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Fruits'), 'Blackberries')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Fruits'), 'Watermelon')
	GO
	-- Seeds/Nuts --
	INSERT INTO rp_IngredientDetail (rp_IngredientTypeID, IngredientSource) 
		VALUES	((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Seeds/Nuts'), 'Sunflower Seeds')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Seeds/Nuts'), 'Pumpkin Seeds')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Seeds/Nuts'), 'Almonds')
				, ((SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Seeds/Nuts'), 'Brazil Nuts')
	GO

-- insert nutrition facts
	-- Muscle meat--
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Chicken', 172, 20, 9, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Pork', 134, 21, 4, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Beef', 178, 28, 6, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Rabbit', 114, 21, 2, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Turkey', 157, 21, 7, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Lamb', 112, 15, 5, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Goat', 143, 27, 3, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Muscle meat', 'Duck', 123, 19, 4, NULL, NULL, NULL
	-- Edible bone--
	EXEC rp_pro_AddNutritionPart 'Edible bone', 'Chicken', 'Wing', 191, 17, 12, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Edible bone', 'Duck', 'Wing', 84, 20, 0, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Edible bone', 'Chicken', 'Neck', 213, 18, 14, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Edible bone', 'Turkey', 'Neck', 162, 22, 7, NULL, NULL, NULL
	-- Organ--
	EXEC rp_pro_AddNutritionPart 'Organ', 'Beef', 'Kidney', 99, 17, 3, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Beef', 'Spleen', 105, 18, 3, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Chicken', 'Heart', 153, 15, 9, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Beef', 'Heart', 112, 17, 3, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Pork', 'Heart', 118, 17, 4, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Pork', 'Lung', 85, 14, 2, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Beef', 'Lung', 92, 16, 2, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Lamb', 'Lung', 95, 16, 2, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionPart 'Organ', 'Chicken', 'Gizzard', 94, 17, 2, NULL, NULL, NULL
	-- Liver --
	EXEC rp_pro_AddNutritionSource 'Liver', 'Chicken', 119, 16, 4, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Liver', 'Pork', 134, 21, 3, NULL, NULL, NULL
	EXEC rp_pro_AddNutritionSource 'Liver', 'Beef', 135, 20, 3, NULL, NULL, NULL
	-- Vegetable --
	EXEC rp_pro_AddNutritionSource 'Vegetable', 'Broccoli', 34, 2, 0, 6, 2, 1
	EXEC rp_pro_AddNutritionSource 'Vegetable', 'Spinach', 23, 2, 0, 3, 2, 0
	EXEC rp_pro_AddNutritionSource 'Vegetable', 'Kale', 49, 4, 0, 8, 3, 2
	EXEC rp_pro_AddNutritionSource 'Vegetable', 'Carrot', 41, 0, 0, 8, 3, 3
	EXEC rp_pro_AddNutritionSource 'Vegetable', 'Cauliflower', 25, 1, 0, 4, 2, 1
	-- Fruits --
	EXEC rp_pro_AddNutritionSource 'Fruits', 'Blueberries', 57, 0, 0, 14, 2, 9
	EXEC rp_pro_AddNutritionSource 'Fruits', 'Blackberries', 43, 1, 0, 9, 5, 4
	EXEC rp_pro_AddNutritionSource 'Fruits', 'Watermelon', 30, 0, 0, 7, 0, 6
	-- Seeds/Nuts --
	EXEC rp_pro_AddNutritionSource 'Seeds/Nuts', 'Sunflower Seeds', 546, 19, 49, 15, 9, 2
	EXEC rp_pro_AddNutritionSource 'Seeds/Nuts', 'Pumpkin Seeds', 446, 18, 19, 53, 18, 0
	EXEC rp_pro_AddNutritionSource 'Seeds/Nuts', 'Almonds', 598, 20, 52, 21, 10, 4
	EXEC rp_pro_AddNutritionSource 'Seeds/Nuts', 'Brazil Nuts', 659, 14, 67, 11, 7, 2
	GO


-- insert price info into store
-- Aeon awase
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Chicken', 1.35
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Pork', 1.4
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Beef', 1.67
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Rabbit', 2
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Turkey', 1.45
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Lamb', 1.8
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Goat', 1.9
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Muscle meat', 'Duck', 1.4
GO
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Edible bone', 'Chicken', 'Wing', 1.2
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Edible bone', 'Duck', 'Wing', 1.35
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Edible bone', 'Chicken', 'Neck', 1
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Edible bone', 'Turkey', 'Neck', 1.11
GO
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Beef', 'Kidney', 1.3
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Beef', 'Spleen', 1.7
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Chicken', 'Heart', 0.8
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Beef', 'Heart', 1.1
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Pork', 'Heart', 0.7
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Pork', 'Lung', 0.8
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Beef', 'Lung', 1.1
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Lamb', 'Lung', 1.7
EXEC rp_pro_AddIngredientPartIntoStore 'Aeon awase', 'Organ', 'Chicken', 'Gizzard', 0.7
GO
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Liver', 'Chicken',  1.2
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Liver', 'Pork', 1.1
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Liver', 'Beef', 1.4
GO
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Vegetable', 'Broccoli', 1.1
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Vegetable', 'Spinach', 1.0
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Vegetable', 'Kale', 1.3
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Vegetable', 'Carrot', 1.0
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Vegetable', 'Cauliflower', 1.1
GO
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Fruits', 'Blueberries', 4.1
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Fruits', 'Blackberries', 3.8
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Fruits', 'Watermelon', 1.0
GO
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Seeds/Nuts', 'Sunflower Seeds', 1.25
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Seeds/Nuts', 'Pumpkin Seeds', 1.25
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Seeds/Nuts', 'Almonds', 2.1
EXEC rp_pro_AddIngredientSourceIntoStore 'Aeon awase', 'Seeds/Nuts', 'Brazil Nuts', 3.5

-- insert ingredient into stock
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Muscle meat', 'Chicken', NULL, 600, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Muscle meat', 'Beef', NULL, 800, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Edible bone', 'Chicken', 'Wing', 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Edible bone', 'Chicken', 'Neck', 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Organ', 'Chicken', 'Gizzard', 200, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Organ', 'Beef', 'Heart', 100, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Liver', 'Chicken', NULL, 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Vegetable', 'Broccoli', NULL, 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Vegetable', 'Spinach', NULL, 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Vegetable', 'Carrot', NULL, 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Fruits', 'Watermelon', NULL, 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Fruits', 'Blueberries', NULL, 300, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Seeds/Nuts', 'Sunflower Seeds', NULL, 100, '5/1/2021'
EXEC rp_pro_AddIngredientIntoStock 'bominp@abc.com', 'Ref1', 'Aeon awase', 'Seeds/Nuts', 'Almonds', NULL, 100, '5/1/2021'
GO

	/*-- Read rows in Ingredientstock
	SELECT * FROM rp_IngredientStock
	SELECT * FROM rp_IngredientStockUpdate
*/
/*-- Read rows in Pet and IngredientDetail tables to insert values in PetPreference
SELECT * FROM rp_Pet
SELECT * FROM rp_IngredientDetail
*/
-- insert pet preference
INSERT INTO rp_PetPreference(rp_PetID, rp_IngredientDetailID) 
	VALUES	((SELECT rp_PetID FROM rp_Pet WHERE PetName = 'Kinako'),1)
			, (1,9), (1,3), (2,1), (2,6), (2,7), (2,25), (3,4), (3,6), (3,22), (3,26), (3,15), (3,23), (4,2), (4,25), (4,32), (4,20), (5,32), (5,33), (5,16)
			, (5,10), (6,16), (6,4), (6,31), (6,8), (7,13), (7,34), (7,6), (7,9), (8,3), (8,5), (8,14), (8,8), (8,11), (9,32), (9,22), (9,28), (9,31), (10,7)
			, (10,1), (10,8), (10,31), (11,2), (11,3), (11,20), (11,32), (12,16), (12,10), (12,4), (12,8), (12,2), (13,16), (13,5), (13,3), (13,28), (14,7), (14,20), (14,28)
			, (14,32), (14,9), (15,2), (15,3), (15,8), (15,13), (16,4), (16,31), (16,5), (16,9), (16,3), (16,5), (16,11), (16,13), (16,12), (17,11), (17,12), (17,9), (17,3)
			, (17,1), (18,8), (18,31), (18,2), (18,3), (18,20), (19,32), (19,16), (19,10), (19,4), (20,8), (20,2), (20,16), (21,5), (21,3), (21,28), (21,7), (22,20), (22,28)
			, (22,32), (22,9), (23,2), (23,3), (23,8), (23,13), (24,4), (24,31), (25,5), (25,9), (25,3), (25,5), (26,11), (26,13), (26,12), (26,11), (26,12), (26,9), (27,3)
			, (27,5), (27,9), (27,11), (28,3), (28,11), (28,28), (28,32), (29,2), (29,1), (29,11), (29,25), (29,33), (30,1), (30,28), (30,4), (31,11), (31,8), (31,5), (31,3)
			, (4,9), (6,9), (15,9), (15,9), (28,9), (18,9), (16,9), (16,1), (6,1), (7,1), (8,1), (9,1), (9,11), (14,11), (5,11), (14,8), (30,8), (4,4),(17,4),(31,4),(27,4)
GO

-- insert meal model
INSERT INTO rp_MealModel(MealModelName) VALUES('BARF')
GO

-- insert meal model ratio info
--BARF--
INSERT INTO rp_MealModelRatio(rp_MealModelID, rp_IngredientTypeID, MealModelTypeRatio)
	VALUES	(1, (SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Muscle meat'), 0.7)
			, (1, (SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Edible bone'), 0.1)
			, (1, (SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Vegetable'), 0.07)
			, (1, (SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Liver'), 0.05)
			, (1, (SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Organ'), 0.05)
			, (1, (SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Seeds/Nuts'), 0.02)
			, (1, (SELECT rp_IngredientTypeID FROM rp_IngredientType WHERE IngredientType = 'Fruits'), 0.01)
	GO

/*-- Read rows in Pet and MealModel tables to insert values in PetMealModel
SELECT * FROM rp_Pet
SELECT * FROM rp_MealModel
*/
-- insert pet's choice of meal model
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (1,1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (2, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (3, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (4, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (5, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (6, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (7, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (8, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (9, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (10, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (11, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (12, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (13, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (14, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (15, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (16, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (17, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (18, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (19, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (20, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (21, 1)
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (22, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (23, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (24, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (25, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (26, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (27, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (28, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (29, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (30, 1) 
GO
INSERT INTO rp_PetMealModel(rp_PetID, rp_MealModelID) VALUES (31, 1) 
GO

		/*-- Read rows to verify that the PetMealModel trigger for calculating ingredient amount by ingredientType works well
			SELECT
			rp_Pet.rp_PetID AS petID
			, rp_Pet.PetName
			, rp_PetMealModel.rp_PetMealModelID AS pmmID
			, rp_MealModelTypeAmount.rp_MealModelTypeAmountID AS mmtaID
			, rp_IngredientType.IngredientType
			, rp_MealModelTypeAmount.MealModelTypeAmount
			FROM rp_Pet
			LEFT JOIN rp_PetMealModel ON rp_PetMealModel.rp_PetID = rp_Pet.rp_PetID
			LEFT JOIN rp_MealModelTypeAmount ON rp_PetMealModel.rp_PetMealModelID = rp_MealModelTypeAmount.rp_PetMealModelID
			LEFT JOIN rp_IngredientType ON rp_MealModelTypeAmount.rp_IngredientTypeID = rp_IngredientType.rp_IngredientTypeID
			SELECT * FROM rp_IngredientDetail
		*/
		

-- insert meal plan call raws
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,1,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,3,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (2,9,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (3,21,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (4,22,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (5,25,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (6,31,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (7,35,1,'5/1/2021')
GO
--5/2/2021
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,1,0.3,'5/2/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,3,0.7,'5/2/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (2,9,1,'5/2/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (3,19,1,'5/2/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (4,23,1,'5/2/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (5,25,1,'5/2/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (6,32,1,'5/2/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (7,33,1,'5/2/2021')
GO
--5/3/2021
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,1,0.3,'5/3/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,8,0.7,'5/3/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (2,9,1,'5/3/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (3,19,1,'5/3/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (4,23,1,'5/3/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (5,25,1,'5/3/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (6,31,1,'5/3/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (7,33,1,'5/3/2021')
GO
--5/4/2021
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,1,0.3,'5/4/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,8,0.7,'5/4/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (2,9,1,'5/4/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (3,19,1,'5/4/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (4,23,1,'5/4/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (5,25,1,'5/4/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (6,31,1,'5/4/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (7,33,1,'5/4/2021')
GO
--5/5/2021
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,1,0.3,'5/5/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,8,0.7,'5/5/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (2,9,1,'5/5/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (3,19,1,'5/5/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (4,23,1,'5/5/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (5,25,1,'5/5/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (6,31,1,'5/5/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (7,33,1,'5/5/2021')
GO
--5/6/2021
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,1,0.3,'5/6/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,8,0.7,'5/6/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (2,9,1,'5/6/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (3,19,1,'5/6/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (4,23,1,'5/6/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (5,25,1,'5/6/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (6,31,1,'5/6/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (7,33,1,'5/6/2021')
GO
--5/7/2021
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,1,0.3,'5/7/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (1,8,0.7,'5/7/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (2,9,1,'5/7/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (3,19,1,'5/7/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (4,23,1,'5/7/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (5,25,1,'5/7/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (6,31,1,'5/7/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (7,33,1,'5/7/2021')
GO
--petID=2
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (8,1,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (8,4,0.7,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (9,11,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (10,19,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (11,23,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (12,25,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (13,31,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (14,33,1,'5/1/2021')
GO
--petID=3
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (15,3,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (15,7,0.7,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (16,9,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (17,14,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (18,22,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (19,25,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (20,30,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (21,33,1,'5/1/2021')
GO
--petID=4
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (22,4,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (22,6,0.7,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (23,10,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (24,15,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (25,23,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (26,26,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (27,31,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (28,34,1,'5/1/2021')
GO
--petID=5
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (29,2,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (29,7,0.7,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (30,11,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (31,15,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (32,23,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (33,26,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (34,31,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (35,34,1,'5/1/2021')
GO
--petID=6
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (36,3,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (36,1,0.7,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (37,11,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (38,16,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (39,23,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (40,28,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (41,32,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (42,36,1,'5/1/2021')
GO
--petID=7
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (43,3,0.5,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (43,1,0.7,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (44,11,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (45,16,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (46,23,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (47,28,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (48,32,1,'5/1/2021')
GO
INSERT INTO rp_MealPlanCall (rp_MealModelTypeAmountID, rp_IngredientDetailID, IngredientContents, MealPlanCallDate) VALUES (49,36,1,'5/1/2021')
GO
					/*
					SELECT * FROM rp_v_MealPlanCallhelp WHERE petID=7
					SELECT * FROM rp_IngredientDetail WHERE rp_IngredientTypeID = 6
					*/

		/*-- Read rows to verify that the PetMealModel trigger for calculating ingredient amount by ingredientParts works well
			SELECT
			rp_MealModelPartAmount.rp_MealModelPartAmountID AS mmpaID
			, rp_IngredientType.IngredientType
			, rp_IngredientDetail.IngredientSource
			, rp_IngredientDetail.IngredientPart
			, rp_MealModelPartAmount.MealModelPartAmount
			, rp_CompleteMealPlan.SuggestedDate
			, rp_Pet.rp_PetID AS petID
			FROM rp_MealModelPartAmount
			LEFT JOIN rp_CompleteMealPlan ON rp_MealModelPartAmount.rp_CompleteMealPlanID = rp_CompleteMealPlan.rp_CompleteMealPlanID
			LEFT JOIN rp_Pet ON rp_CompleteMealPlan.rp_PetID = rp_Pet.rp_PetID
			JOIN rp_MealPlanCall ON rp_MealModelPartAmount.rp_MealPlanCallID = rp_MealPlanCall.rp_MealPlanCallID
			JOIN rp_IngredientDetail ON rp_MealPlanCall.rp_IngredientDetailID = rp_IngredientDetail.rp_IngredientDetailID
			JOIN rp_IngredientType ON rp_IngredientDetail.rp_IngredientTypeID = rp_IngredientType.rp_IngredientTypeID
		*/

	/*-- to update stock's ingredient amount
	SELECT * FROM rp_v_UpdateIngredientStock
	*/

-- update stock's ingredient amount
EXEC rp_pro_updIngredientIntoStock 1,1,80
EXEC rp_pro_updIngredientIntoStock 2,3,77
EXEC rp_pro_updIngredientIntoStock 5,21,20
EXEC rp_pro_updIngredientIntoStock 7,22,15
EXEC rp_pro_updIngredientIntoStock 8,25,79
EXEC rp_pro_updIngredientIntoStock 14,35,1
--5/2
EXEC rp_pro_updIngredientIntoStock 1,1,47
EXEC rp_pro_updIngredientIntoStock 2,3,108
EXEC rp_pro_updIngredientIntoStock 6,16,20
EXEC rp_pro_updIngredientIntoStock 8,25,79
EXEC rp_pro_updIngredientIntoStock 11,32,10
EXEC rp_pro_updIngredientIntoStock 14,35,1
--5/3
EXEC rp_pro_updIngredientIntoStock 1,1,47
EXEC rp_pro_updIngredientIntoStock 6,16,20
EXEC rp_pro_updIngredientIntoStock 8,25,79
EXEC rp_pro_updIngredientIntoStock 13,33,1
GO

	/*--retrieve the stock
	SELECT * FROM rp_v_StockReport
	*/

-- create view
-- create view of pets and their owners
CREATE OR ALTER VIEW rp_v_OwnerPet AS
SELECT
	rp_Owner.rp_OwnerID
	, rp_Owner.OwnerFirstName+rp_Owner.OwnerLastName AS OwnerName
	, PetName
	, PetType
	FROM rp_Pet
	JOIN rp_Owner ON rp_Pet.rp_OwnerID = rp_Owner.rp_OwnerID
GO

-- Create a view to retrieve the stock
CREATE OR ALTER VIEW rp_v_StockReport AS
	SELECT
		rp_Owner.OwnerFirstName + rp_Owner.OwnerLastName AS OwnerName
		, rp_Stock.StorageName
		, rp_IngredientType.IngredientType
		, rp_IngredientStock.rp_IngredientStockID
		, rp_IngredientStock.rp_IngredientStoreID
		, rp_IngredientDetail.rp_IngredientDetailID
		, rp_IngredientDetail.IngredientSource
		, rp_IngredientDetail.IngredientPart
		, rp_IngredientStock.IngredientAmount
		, rp_IngredientStock.StoredDate
		, rp_IngredientStockUpdate.UpdatedDate
		, rp_IngredientStock.Finished
	FROM rp_IngredientStock
	JOIN rp_Stock ON rp_IngredientStock.rp_StockID = rp_Stock.rp_StockID
	JOIN rp_Owner ON rp_Stock.rp_OwnerID = rp_Owner.rp_OwnerID
	LEFT JOIN rp_IngredientStockUpdate ON rp_IngredientStock.rp_IngredientStockID = rp_IngredientStockUpdate.rp_IngredientStockID
	JOIN rp_IngredientStore ON rp_IngredientStock.rp_IngredientStoreID = rp_IngredientStore.rp_IngredientStoreID
	JOIN rp_IngredientDetail ON rp_IngredientStore.rp_IngredientDetailID = rp_IngredientDetail.rp_IngredientDetailID
	JOIN rp_IngredientType ON rp_IngredientDetail.rp_IngredientTypeID = rp_IngredientType.rp_IngredientTypeID
GO

-- Create a view pet's prefrence ingredient
CREATE OR ALTER VIEW rp_v_PetPreferenceCount AS
	SELECT
		rp_PetPreference.rp_IngredientDetailID AS IngID
		, IngredientType
		, IngredientSource
		, IngredientPart
		, COUNT (*) AS num_Preference
	FROM rp_PetPreference
	JOIN rp_IngredientDetail ON rp_PetPreference.rp_IngredientDetailID = rp_IngredientDetail.rp_IngredientDetailID
	JOIN rp_IngredientType ON rp_IngredientDetail.rp_IngredientTypeID = rp_IngredientType.rp_IngredientTypeID
	GROUP BY rp_PetPreference.rp_IngredientDetailID, IngredientType, IngredientSource, IngredientPart
GO

-- Create a view to help write meal plan call values
CREATE OR ALTER VIEW rp_v_MealPlanCallhelp AS
	SELECT
		rp_Pet.rp_PetID AS petID
		, rp_Pet.PetName
		, rp_PetMealModel.rp_PetMealModelID AS pmmID
		, rp_MealModelTypeAmount.rp_MealModelTypeAmountID AS mmtaID
		, rp_IngredientType.IngredientType
		, rp_MealModelTypeAmount.MealModelTypeAmount
		FROM rp_Pet
		LEFT JOIN rp_PetMealModel ON rp_PetMealModel.rp_PetID = rp_Pet.rp_PetID
		LEFT JOIN rp_MealModelTypeAmount ON rp_PetMealModel.rp_PetMealModelID = rp_MealModelTypeAmount.rp_PetMealModelID
		LEFT JOIN rp_IngredientType ON rp_MealModelTypeAmount.rp_IngredientTypeID = rp_IngredientType.rp_IngredientTypeID
GO

-- Create a view to retrieve complete meal plan
CREATE OR ALTER VIEW rp_v_CompletePlans AS
	SELECT
		rp_Pet.PetName
		, rp_CompleteMealPlan.rp_CompleteMealPlanID AS cmpID
		, SuggestedDate
		, rp_IngredientType.IngredientType
		, rp_IngredientDetail.rp_IngredientDetailID
		, rp_IngredientDetail.IngredientSource
		, rp_IngredientDetail.IngredientPart
		, rp_MealModelPartAmount.MealModelPartAmount AS gram
	FROM rp_MealModelPartAmount
	JOIN rp_CompleteMealPlan ON rp_MealModelPartAmount.rp_CompleteMealPlanID = rp_CompleteMealPlan.rp_CompleteMealPlanID
	JOIN rp_Pet ON rp_CompleteMealPlan.rp_PetID = rp_Pet.rp_PetID
	JOIN rp_MealPlanCall ON rp_MealModelPartAmount.rp_MealPlanCallID = rp_MealPlanCall.rp_MealPlanCallID
	JOIN rp_IngredientDetail ON rp_MealPlanCall.rp_IngredientDetailID = rp_IngredientDetail.rp_IngredientDetailID
	JOIN rp_IngredientType ON rp_IngredientDetail.rp_IngredientTypeID = rp_IngredientType.rp_IngredientTypeID
GO

-- create a view to update stock's ingredient amount
CREATE OR ALTER VIEW rp_v_UpdateIngredientStock AS
	SELECT
		rp_CompleteMealPlan.rp_CompleteMealPlanID AS cmpID
		, rp_MealModelPartAmount.rp_MealModelPartAmountID AS mmpaID
		, SuggestedDate
		, rp_IngredientType.IngredientType
		, rp_IngredientDetail.IngredientSource
		, rp_IngredientDetail.IngredientPart
		, rp_IngredientStock.rp_IngredientStockID AS ingskID
		, rp_IngredientStock.rp_IngredientStoreID AS ingsrID
		, rp_MealModelPartAmount.MealModelPartAmount AS gram
	FROM rp_IngredientStore
	JOIN rp_IngredientStock ON rp_IngredientStore.rp_IngredientStoreID = rp_IngredientStock.rp_IngredientStoreID
	JOIN rp_IngredientDetail ON rp_IngredientStore.rp_IngredientDetailID = rp_IngredientDetail.rp_IngredientDetailID
	JOIN rp_IngredientType ON rp_IngredientDetail.rp_IngredientTypeID = rp_IngredientType.rp_IngredientTypeID
	JOIN rp_MealPlanCall ON rp_IngredientDetail.rp_IngredientDetailID = rp_MealPlanCall.rp_IngredientDetailID
	RIGHT JOIN rp_MealModelPartAmount ON rp_MealPlanCall.rp_MealPlanCallID = rp_MealModelPartAmount.rp_MealPlanCallID
	RIGHT JOIN rp_CompleteMealPlan ON rp_MealModelPartAmount.rp_CompleteMealPlanID = rp_CompleteMealPlan.rp_CompleteMealPlanID
GO


-- finally, pull results from the tables

-- Data Questions
-- What are the top 5 ingredient types for preference by pet type?
SELECT TOP 5 * FROM rp_v_PetPreferenceCount 
ORDER BY num_Preference DESC
GO
-- What is the average needs calorie by pet type? 
SELECT
	rp_Pet.PetType
	, AVG(PetRequiredCalorie) AS avgCalorie
	FROM rp_Pet
	JOIN rp_PetHealthinfo ON rp_Pet.rp_PetID = rp_PetHealthinfo.rp_PetID
	JOIN rp_PetRequiredCalorie ON rp_PetHealthinfo.rp_PetHealthinfoID = rp_PetRequiredCalorie.rp_PetHealthinfoID
	GROUP BY PetType
GO

-- What is the average age by pet type and most common activity level for a pet?
SELECT
	PetType
	, AVG(DATEDIFF(YEAR, DateOfBirth, GETDATE())) AS avgAge
	FROM rp_Pet
	GROUP BY PetType
GO
SELECT
	ActivityLevel
	, COUNT(rp_PetHealthinfo.rp_Pet_ActivityRateID) AS numofPets
	FROM rp_Pet_ActivityRate
	JOIN rp_PetHealthinfo ON rp_Pet_ActivityRate.rp_Pet_ActivityRateID=rp_PetHealthinfo.rp_Pet_ActivityRateID
	GROUP BY ActivityLevel
	ORDER BY numofPets DESC
GO

-- How is the percentage divided between pets with spayed and pets without spayed by pet type?

SELECT
	PetType
	, COUNT(PetType) AS numPet
	, COUNT(case when rp_PetHealthinfo.Spayed = 'Yes' then 1 end) AS Spayed
	FROM rp_PetHealthinfo
	JOIN rp_Pet ON rp_Pet.rp_PetID = rp_PetHealthinfo.rp_PetID
	GROUP BY PetType

-- What is the average daily raw food bill per pet? And how connected to their weight?

SELECT * FROM rp_v_CompletePlans
WHERE PetName = 'Kinako' AND SuggestedDate = '2021/05/01'


