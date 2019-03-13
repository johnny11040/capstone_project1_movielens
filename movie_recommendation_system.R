#############################################################
# Data Science Capstone - Movie Recommendation System
#############################################################

if(!require(tidyverse)) install.packages("tidyverse", repos = "http://cran.us.r-project.org"); library(tidyverse)
if(!require(caret)) install.packages("caret", repos = "http://cran.us.r-project.org"); library(caret)

# MovieLens 10M dataset:
# https://grouplens.org/datasets/movielens/10m/
# http://files.grouplens.org/datasets/movielens/ml-10m.zip

dl <- tempfile()
download.file("http://files.grouplens.org/datasets/movielens/ml-10m.zip", dl)

#### Load Data, Create edx set, validation set, and submission file ####

ratings <- read.table(text = gsub("::", "\t", readLines(unzip(dl, "ml-10M100K/ratings.dat"))),
                      col.names = c("userId", "movieId", "rating", "timestamp"))

movies <- str_split_fixed(readLines(unzip(dl, "ml-10M100K/movies.dat")), "\\::", 3)
colnames(movies) <- c("movieId", "title", "genres")
movies <- as.data.frame(movies) %>% mutate(movieId = as.numeric(levels(movieId))[movieId],
                                           title = as.character(title),
                                           genres = as.character(genres))

movielens <- left_join(ratings, movies, by = "movieId")

# Validation set will be 10% of MovieLens data

set.seed(1)
test_index <- createDataPartition(y = movielens$rating, times = 1, p = 0.1, list = FALSE)
edx <- movielens[-test_index,]
temp <- movielens[test_index,]

# Make sure userId and movieId in validation set are also in edx set

validation <- temp %>% 
  semi_join(edx, by = "movieId") %>%
  semi_join(edx, by = "userId")

# Add rows removed from validation set back into edx set

removed <- anti_join(temp, validation)
edx <- rbind(edx, removed)

rm(dl, ratings, movies, test_index, temp, movielens, removed)

#### Exploratory Analyses ####
# Check if there are any blank values in the dataset
sapply(edx, function(x) sum(is.na(x))) # No NA values

# Check if any rating is > 5 or <= 0
sum(edx$rating > 5 | edx$rating <= 0) # No inconsistencies in ratings

# Count of movies and users
length(unique(edx$movieId)) # 10,677 different movies
length(unique(edx$userId)) # 69,878 different users

# Distribution of ratings given
table(edx$rating)
#   0.5       1     1.5       2     2.5       3     3.5       4     4.5       5 
# 85374  345679  106426  711422  333010 2121240  791624 2588430  526736 1390114
hist(edx$rating, xlab="Rating", main="Histogram of Ratings")

# Distribution of average ratings by movies
movie_avgs <- edx %>% group_by(movieId) %>% summarize(avg_rating = mean(rating))
hist(movie_avgs$avg_rating, xlab="Average Rating", main="Histogram of average rating by movie")

# Distribution of average ratings by users
user_avgs <- edx %>% group_by(userId) %>% summarize(avg_rating = mean(rating))
hist(movie_avgs$avg_rating, xlab="Average Rating", main="Histogram of average rating by user")

#### Model ####

# Matrix Factorization Method

# Just the average rating across all movies and users
mu <- mean(edx$rating)
mu # 3.51 - Average rating for all movies across all users

naive_rmse <- RMSE(validation$rating, mu)
naive_rmse # RMSE = 1.06

rmse_results <- data.frame(method="Just the average", RMSE=naive_rmse)

# Account for differences between movies
movie_avgs <- edx %>% group_by(movieId) %>% summarize(b_i = mean(rating - mu))

pred_movies <- mu + validation %>% left_join(movie_avgs, by='movieId') %>% .$b_i

model_1_rmse <- RMSE(pred_movies, validation$rating) # RMSE = 0.94
rmse_results <- rbind(rmse_results, data.frame(method="Movie Effect Model", 
                                               RMSE = model_1_rmse))

# Account for differences between users
user_avgs <- 
  edx %>% left_join(movie_avgs, by='movieId') %>% 
  group_by(userId) %>% summarize(b_u = mean(rating - mu - b_i))

pred_users <- 
  validation %>% 
  left_join(movie_avgs, by='movieId') %>% 
  left_join(user_avgs, by='userId') %>% 
  mutate(pred = mu + b_i + b_u) %>% .$pred

model_2_rmse <- RMSE(pred_users, validation$rating) # RMSE = 0.865
rmse_results <- rbind(rmse_results, data.frame(method="User Effect Model", 
                                               RMSE = model_2_rmse))

# Plot the RMSE for the three models constructed
barplot(rmse_results$RMSE, names.arg = rmse_results$method)
