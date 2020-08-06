# Importing libraries

library("dplyr")
library("tidyr")


dir <- "C:/Users/Edgar/Documents/R/COVID-19mx_Mobility"
setwd(dir)
getwd()
# Reading downloaded csv
# https://www.google.com/covid19/mobility/
data <- read.csv(file = 'Global_Mobility_Report.csv', encoding = "UTF-8")
# Print column names in dataframe
colnames(data)

# Required country codes
country_region_code <- c("MX")
# Creating a subset using required country codes
subset = data[data$country_region_code %in% country_region_code ,]
# Check countries in subset
unique(subset$country_region)
unique(subset$sub_region_1)

#
histdata <- subset %>%
    group_by(country_region_code, country_region,sub_region_1)

histdata$sub_region_1[histdata$sub_region_1 == ""] <- "National"
head(histdata)
write.csv(histdata,'Historical_COVID_MX_Mobility_from_GOOGLE.csv')

# Aggregating data to get average percent change
aggdata <- subset %>%
    group_by(country_region_code, country_region,sub_region_1) %>%
    
    summarize(retail_and_recreation_percent_avg = mean(retail_and_recreation_percent_change_from_baseline, na.rm = TRUE),
              
              grocery_and_pharmacy_percent_avg = mean(grocery_and_pharmacy_percent_change_from_baseline, na.rm = TRUE),
              
              parks_percent_avg = mean(parks_percent_change_from_baseline, na.rm = TRUE),
              
              transit_stations_percent_avg = mean(transit_stations_percent_change_from_baseline, na.rm = TRUE),
              
              workplaces_percent_avg = mean(workplaces_percent_change_from_baseline, na.rm = TRUE),
              
              residential_percent_avg = mean(residential_percent_change_from_baseline, na.rm = TRUE))
colnames(aggdata)

head(aggdata)
class(aggdata)

# Adding additional average change column


aggdata <- transform(aggdata, overall_mob_percent=(retail_and_recreation_percent_avg+grocery_and_pharmacy_percent_avg+
                                                parks_percent_avg+transit_stations_percent_avg+workplaces_percent_avg+residential_percent_avg))
colnames(aggdata)
aggdata$sub_region_1[aggdata$sub_region_1 == ""] <- "National"
head(aggdata)
write.csv(aggdata,'COVID_MX_Mobility_from_GOOGLE.csv')

 