library(keras)

# Use keras model for prediction.

predictSolarPower <- function(x, model) {
  y <- keras::predict(x, model)
  
  y
}

# load test data.

loadData <- function() {
  load("./results_lstm.RData")
}

# reconcile the data.

denomalizeData <- function(data, max, min) {
  data * (max - min) + min
}
