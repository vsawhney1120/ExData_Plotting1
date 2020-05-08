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

#Generating Plot4
png(filename = "./data/plot4.png")
par(mfcol = c(2,2), mar = c(4,4,2,2))
plot(Global_active_power~DateTime,data = hpc_subset, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")
plot(Sub_metering_1~DateTime, data = hpc_subset, type = "n", ylab = "Energy Sub metering", xlab = "")
    points(Sub_metering_1~DateTime, data = hpc_subset, col = "black", type = "l")
    points(Sub_metering_2~DateTime, data = hpc_subset, col = "red", type = "l")
    points(Sub_metering_3~DateTime, data = hpc_subset, col = "blue", type = "l")
    legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = c(1,1,1), col = c("black","red","blue"))
plot(Voltage~DateTime,data = hpc_subset, type = "l", ylab = "Voltage", xlab = "datetime")
plot(Global_reactive_power~DateTime,data = hpc_subset, type = "l", ylab = "global_reactive_power", xlab = "datetime")
dev.off()