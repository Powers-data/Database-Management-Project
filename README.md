# Database-Management-Project

## About the project
This project was about designing and implementing a database to solve a data management problem of my own choice of data. The intent of this project is to have an opportunity to work on something of interest to me that should have some real utility as a completed database. This project is broken up into 2 parts. The first part is the design specifications detailing the data to be tracked and how all the elements work together. Also need to specify any business rules that dictate how the data are to be managed. As in any good development project, also need to identify stakeholders and detail what data they will need to access and maintain. Document at least five data questions the data must answer to be relevant. The second part is the implementation of the design created in part 1. This will include the SQL statements to create the tables and columns to hold the data and any constraints that implement the business rules. Also included are representative statements for the basic Data Manipulation Language (DML) that implement the create, read, update, and delete statements (referred to as CRUD) used in maintaining the data.


## Background
A couple of months ago, a new puppy named Kinako joined our family; now we have two cats and one dog. Kinako has a picky tongue, so we tried all kinds of kibble from various brands and DYI homemade dog foods. Finally, we decided to try raw food diet, and she loves it! At first, we were unsure if Kinako would like it, so we just tried it, but as it went smoothly for more than three months, we started to investigate raw food meal plans more. In the present world, where people can find jobs on the other side of the world with just one Internet search button, information on raw food diet for a dog was very limited. The raw food diet for a dog has various benefits for their health, such as healthier skin, cleaner teeth, higher energy levels, and smaller stools. However, many mainstream veterinarians disagree with the raw food diet and warn about its risks. Potential risks that they claim include an unbalanced diet that may damage dogs' health. As a non-dietitian but a parent who wants my babies to have a long healthy life, I wanted to make this easier. I thought that with well-structured data, we could make a balanced raw diet plan. 


## Goals
In this project, I will focus on two things; 1: Make a balanced raw diet plan for dogs and cats and 2: Track the ingredients inventory. As we tried this diet for over three months, we realized it is hard to track all the ingredients we bought. For example, when I purchased a whole chicken and a rabbit. I organized and stored it by type and amount. After a while, it is hard to track the type of ingredient and how much of the ingredients are stored. Thus, while tracking the inventory, the database will make a balanced diet plan based on the ingredients in the inventory. If there is not enough it will suggest what ingredients are needed. To sum up, the goal of this project will be to identify the inventory and propose a meal plan based on the inventory. Then suggest what ingredients and how much more you need if you run out of ingredients.

## Stakeholders
Since I know several pet parents are interested in this project, I figured this could be a business opportunity. I talked to my friend, a soft engineer; he also agreed to make this a service. Moreover, we have a potential investor too. I have proposed that the implementation of this database will bring the business opportunity of the new dog food market, the profitability of the local butchers and grocery stores, and increase the needs of the veterinary nutritionist. Pet owners will be able to start or maintain their raw food diet plan for their pets easily. To sum up, the stakeholders in this project are the investor, soft engineers, pet owners, veterinary nutritionists, grocery stores, and local butcher shops.

## Glossary
An Owner is a person who owned pets and makes plans for the raw food meal for their pets through this service.
A Pet is an animal owned by a person.
A PetRequirement is a daily required calorie by a pet.
A Stock is storage owned by an owner.
A Store is a grocery store or butcher shop that sells raw meats, vegetables, and fruits. 
An Ingredient is a food ingredient that is a part of the meal plan.
A MealModel is three different models suggested by the owner or pet’s nutrition requirement, which includes; PMR(Prey Model Raw), BARF(Biologically Appropriate Raw Foods), and Custom(customized by the user).
A MealPlanl is a designed meal plan for a pet with preference, requirement, and quantity of an ingredient in stock. If there is an insufficient quantity of an ingredient in stock, the database will suggest replenishment from the store what amount is needed for the meal plan.

## Data Questions
	What are the top 5 ingredient types for preference by pet? 
	What is the average needs calorie by pet type? 
	What is the average age by pet type and most common activity level for a pet? 
	How is the percentage divided between pets with spayed and pets without spayed by pet type?
	What is the average daily raw food bill per pet? And how connected to their weight?

