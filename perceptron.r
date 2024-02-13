library(geometry)
library(tidyverse)
library(ggthemes)


# Create Data that is separable
create_seperable <- function(n, seed=NULL) {
  if (!is.null(seed)) {
    set.seed(seed) # Set the seed based on input
  }
  coefs <- c(runif(1,-1,1), runif(1,-1,1))
  x1 <- runif(n, -1, 1)
  x2 <- runif(n, -1, 1)
  df <- data.frame(x1, x2)
  
  df$y <- as.numeric(ifelse(x2-(coefs[1]*x1)>coefs[2], 1, -1))
  # x2-a1x1>a2
  return(df)
}

perceptronTrain <- function(x, y, lr=0.01, max_iters=200) {
  x$bias <- 1
  weights <- c(rep(0, ncol(x)))
  any_misclassified <- T #Start with none classified correctly
  j <- 0
  while (any_misclassified && j < max_iters) {
    any_misclassified <- F # Assume that all are classified
    for (i in 1:nrow(x)) { # For all observations
      val <- dot(unlist(x[i,]), weights) #dot product of predictors and weights
      pred <- ifelse(val>0, 1, -1) # step function
      if (y[i]-pred!=0) { #if the prediction is not equal to true value
        any_misclassified <- T  # It is misclassified
        weights <- weights + lr*(y[i]-pred)*(unlist(x[i,])) # change weights by formula
        # new_weights = old_weights * learning rate * error * predictor
      }
    }
    j <- j + 1 # iterations up one
  }
  return(list("weights"=weights, "epochs"=j))
}

perceptronPredict <- function(x, weights) {
  x$bias <- 1
  y_pred <- c()
  for (i in 1:nrow(x)) { # for all predictors
    val <- unlist(x[i,]) %*% weights # dot product with estimated weights
    y_pred[i] <-ifelse(val > 0, 1, -1) # step function
  }
  return(y_pred)
}

correct_rate <- function(y_pred, y_true) {
  return(mean(y_pred==y_true)) # Accuracy of the model
}

train_test <- function(data, x1, x2, y) { 
  train <- sample(c(TRUE, FALSE), nrow(data), replace=T, prob=c(0.8, 0.2)) # Split train test 80/20
  test <- (!train)
  X.train <- data %>% filter(train) %>% 
    select(x1, x2) # make training predictors dataframe
  X.test <- data %>% filter(test) %>%
    select(x1, x2) # make test predictors dataframe
  Y.train <- data %>% filter(train) %>%
    select(all_of(y)) %>% unlist() # make training response dataframe
  Y.test <- data %>% filter(test) %>% 
    select(all_of(y)) %>% unlist() # make test response dataframe
  return(list(X.train, Y.train, X.test, Y.test))
}

sep_graph <- function(data, x1, x2, y, model) {
  # graph all points and decision boundary
  x<- ggplot(data, aes(x=.data[[x1]], y=.data[[x2]], col=as.factor(.data[[y]]))) +
    geom_point() +
    geom_abline(intercept=(model$weights[3]*-1)/(model$weights[2]), 
                slope=(model$weights[1]*-1)/model$weights[2], lwd=2,
                col="pink") +
    theme_economist()
  return(x)
}

