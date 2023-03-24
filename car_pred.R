getwd()

setwd("/Users/darshanpatel/Documents/R")

getwd()

data <- read.csv("darshan2.csv" , header=T , row.name=NULL, dec=".", sep=";")
print(data)

#drop un wanted column from the data 
library(dplyr)
data<-select (data,-c(Dealer,seller_type,fuel,transmission,owner,torque,name ))
str(data)
data=data [data$km_driven!=1,]
data=data [data$mileage!=0,]
data[data == '?'] < NA

# see where  the na value are 
nrow(cars_data[is.na(cars_data$selling_price) | is.na(cars_data$mileage),])
#removing the NA
cars_data <- data[!(is.na(data$mileage) | is.na(data$selling_price)),]


#normalize of data
normalize <- function(x) {
  return((x- mean(x))  /(max(x)-min(x)))
  
}
cars_data$year=normalize(cars_data$year)
cars_data$selling_price=normalize(cars_data$selling_price)
cars_data$km_driven=normalize(cars_data$km_driven)
cars_data$mileage=normalize(cars_data$mileage)
cars_data$engine=normalize(cars_data$engine)
cars_data$max_power=normalize(cars_data$max_power)
cars_data$seats=normalize(cars_data$seats)
str(cars_data)

#model
cars_data<-select (cars_data,-c(max_power ))
mod = lm(selling_price ~ .,data =cars_data)
#lets check model 
summary(mod)


library(ggplot2)

#predictive part 
predicted.data <- data.frame(probability=mod$fitted.values,sp=cars_data$selling_price)
predicted.data <- predicted.data [order(predicted.data$probability, decreasing = FALSE),]
predicted.data$rank =1 :nrow(predicted.data )
#ggplot for predication
ggplot(predicted.data  , aes(x=rank,y=probability))+ geom_point()


