getwd()
 
setwd("/Users/darshanpatel/Documents/R")

getwd()

data <- read.csv("darshan1.csv" , header=T , row.name=NULL, dec=".", sep=";")
print(data)
print(is.data.frame(data))
#vector
names_column <- data$name 
length(names_column)
table(names_column)
#most sailed car ANSWER 1
sort(table(names_column), decreasing = TRUE) [1:1]
#dealer with most sale ANSWER 2"
dealer_column <- data$Dealer
length(dealer_column)
table(dealer_column)
 # answer  3
library("dplyr")
aggregated_df<-data %>% 
group_by(name) %>% 
summarise(selling_price=mean(selling_price))

### ANSWER 4 ###

#oldest_car 

y_min <- min(data$year, na.rm = TRUE)
oldest_car <-data[data$year == y_min, "name"]
print(oldest_car)
print(y_min)
#newest_car

y_max <- max(data$year , na.rm = TRUE)[1:1]
newest_car <- data[data$year == y_max, "name"]
print(newest_car)
print(y_max)


#ANSWER 5

lowm <- data[order(data$selling_price, data$mileage),]
head(lowm ,1)


## ANSWER 6 ##
individuals <- subset(data, seller_type == "Individual")
sum(individuals$selling_price)
###




#ggplot2
library(ggplot2)
#1 for most selling car 
ggplot(data, aes(x=name)) + geom_bar() + theme_minimal() +
  labs(y = "units  ", title = "most selling  cars ")

# 2 dealer with highest  sells 
ggplot(data, aes(x=Dealer)) + geom_bar() + theme_minimal() +
  labs(y = "units ", title = "dealer with most sell  ")

#3 newest car and oldest car 
ggplot(data, aes(x=year)) + geom_bar() + theme_minimal() +
  labs(y = " newestand oldest ", title = "cars  ")
# 4 total rev of individual
ggplot(individuals, aes(x=seller_type)) + geom_bar() + theme_minimal() +
  labs(y = " units", title = "individuals ")
#6
ggplot(aggregated_df, aes(x = name, y = selling_price )) + geom_col()



#ggplot for anwer 5 
highlightpoint <- head(lowm, 1)




b <- ggplot(lowm, aes(x = mileage, y = selling_price))




b +   geom_point(data=highlightpoint, 
                 aes(x=mileage,y=selling_price), 
                 color="red",
                 size=3)