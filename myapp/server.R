library(ggplot2)
library(keras)

predictSolarPower <- function(x, model) {
  # y <- predict(model, x)
  y <- keras:::predict.keras.engine.training.Model(model, x)
  
  y
}

# load test data.

loadData <- function() {
  
  # the pre-trained model is saved in blob, together with some helper data 
  # (e.g., test data, max and min for denormalizing data, and date data.)
  
  download.file(url="https://zhledata.blob.core.windows.net/misc/results_lstm.RData",
                destfile="./results.RData")
  
  download.file(url="https://zhledata.blob.core.windows.net/misc/model_lstm.h5",
                mode="wb",
                destfile="./model.h5")
  load("./results.RData")
  model <- load_model_hdf5("./model.h5")
  
  return(list(x_test=results$x_test,
              y_test=results$y_test,
              date_test=results$date_test,
              ref=results$ref,
              model=model))
}

denomalizeData <- function(data, max, min) {
  data * (max - min) + min
}

function(input, output, session) {
  results <- loadData()
  
  date_test <- results$date_test
  x_test    <- results$x_test
  y_test    <- results$y_test
  model     <- results$model
  ref       <- results$ref      
  
  y_pred <- predictSolarPower(x_test, model)
  y_pred <- denomalizeData(y_pred, ref$total_max, ref$total_min)
  
  df_pred <- data.frame(date=date_test,
                        true=y_test,
                        pred=y_pred)
  
  dataPlot <- reactive({
    date_start <- input$date_range[[1]]
    date_end   <- input$date_range[[2]]
    
    df_pred[df_pred$date >= date_start & df_pred$date <= date_end, ]
  })
  
  output$plot <- renderPlot({
    ggplot(dataPlot(), aes(x=date)) +
      geom_line(aes(y=true, color="True")) +
      geom_line(aes(y=pred, color="Pred")) +
      theme_bw() +
      ggtitle("Solar power prediction") +
      xlab("Date") +
      ylab("Reading from sensor")
  })
}
