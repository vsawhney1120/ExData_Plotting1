#Retrieving Data
install.packages("dplyr")
library(dplyr)
if(!dir.exists("data")){dir.create("data")}
if(!file.exists("./data/household_power_consumption.txt")){
    dataurl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(dataurl,"./data/dataset.zip")
    unzip("./data/dataset.zip",exdir="./data")
    }

#Reading Data
hpc <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE, na.strings = "?", colClasses = c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

#Formatting and Subsetting Data
hpc <- mutate(hpc, Date=as.Date(Date, format = "%d/%m/%Y"))
hpc_subset1 <- hpc[hpc$Date=="2007-02-01",]
hpc_subset2 <- hpc[hpc$Date=="2007-02-02",]
hpc_subset <- rbind(hpc_subset1,hpc_subset2)
hpc_subset <- hpc_subset[complete.cases(hpc_subset),]
DateTime <- paste(hpc_subset$Date,hpc_subset$Time)
DateTime <- as.POSIXct(DateTime)
hpc_subset <- hpc_subset[,!(names(hpc_subset) %in% c("Date","Time"))]
hpc_subset <- cbind(DateTime, hpc_subset)

#Generating Plot1
png(filename = "./data/plot1.png")
hist(hpc_subset$Global_active_power, col = "red", main = "Global Active Power", xlab = "Global Active Power (kilowatts)")
dev.off()