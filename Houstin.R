# librarys used
install.packages("leaflet")
library(leaflet)
library(RColorBrewer)
library(dplyr)


# big data set. use to see all values 
options(max.print=999999)

# read the texas Air bnb csv file
texas = read.csv("C:/Users/Ronet/Documents/R/Texas_Rentals.csv")

# turn csv into a data frame 
texas_df = as.data.frame.matrix(texas)

# view all the texas data table 
View(texas_df)

# selecting all citys from the data table (going to use Houston as the city of intrest)
texasCity = select(texas_df, city)
texasCity

#### subset houston #####


# extract all data that is from the city Houston 
Houston = subset(texas_df, city == "Houston" )
View(Houston)

# want to see the units of each column name 
summary(Houston)

#see just the class of all the data
sapply(Houston, class)

#
AvgPrice = Houston$average_rate_per_night

# average_rate_per_night was a character to begin with 
class(AvgPrice)

#replace it as a integer
AvgPrice = suppressWarnings(as.numeric(as.character(AvgPrice)))
AvgPrice

# now it is an integer\numeric
class(AvgPrice)

# begin the leaflet mapping 

# want a popup tab on each listing that shows 
# 1. price per night
# 2. number of bedrooms 
# 3. url 

Houston = Houston%>%mutate(popup_info = paste("price per night", AvgPrice, "<br/>", 
                                              "number of bedrooms", Houston$bedrooms_count, "<br/>", "URL", Houston$url ))
Houston$popup_info



# brak up the prices into different ranges 
mybins = c(0, 30, 60, 120, 160, 200, 250, 300, 350, 10000)


# creat a color pallete for the colors 
Cpal = colorBin(palette = "YlOrRd",
                domain = AvgPrice,
                na.color = "grey",
                bins = mybins)



# make the map

leaflet()%>%
  addTiles()%>%
  addCircleMarkers(data = Houston, lat = ~latitude, lng = ~longitude, radius = 2, popup = ~popup_info, color = ~Cpal(AvgPrice)) %>%
  addLegend("bottomright",
            pal = Cpal, 
            values = Houston$average_rate_per_night,
            title = "Airbnb Price",
            labFormat = labelFormat(prefix = "$"),
            opacity = 1
  )
