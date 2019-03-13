# movielens
•	Describe movie_recommendation_system.R:
o	This is the R code that uses the movielens 10M data to build the recommendation system that predicts ratings. The code is split into 3 sections – 
	Load data: 
This section uses the code provided in the project description to – 
•	download the movielens 10M data 
•	read ratings and movies tables
•	merge the two tables and split them into ex (train) and validation (test) datasets
	Exploratory analyses:
This section is used to perform descriptive analyses on the edx dataset created in the previous step. Quality of the data is checked, number of unique movies and users are counted and histograms of ratings by movies and users are plotted to understand variation in the dependent variable
	Model:
This section uses the matrix factorization method to build linear models to predict ratings for a given user-movie combination. Predictions are made on the validation dataset and RMSE is calculated for each model. Then, the RMSE results are plotted on a bar plot.

•	Describe movie_recommendation_system.Rmd:
	This is the R markdown file used to generate the final report. The markdown file is split into 4 sections – Executive Summary, Analysis, Results and Conclusion. 
R codes are included at each stage wherever relevant. The R code that is used to load the data and create edx and validation sets are hidden in the final report too improve readability. 

•	Describe movie_recommendation_system_report.pdf:
o	This is the final project report. It is generated used the R markdown file and follows the 4-section structure mentioned earlier. Here is a description of what each section provides - 
	Executive Summary – provides an overview of the objective of the project, process followed and end result obtained. 
	Analysis – describes the steps followed to analyze the movielens dataset and build the recommendation model. The R codes used, corresponding outputs and graphics wherever applicable are also provided
	Results – describes the results obtained at each step of the analysis process. Reports the RMSE for each iteration of the model
	Conclusion – briefly talks about what was achieved through the project, makes a comment on the results obtained and provides suggestions on improvements that can be made
