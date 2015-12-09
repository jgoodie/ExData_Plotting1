# expl-data-analisys course project #1
# Plot 4

library(data.table)
library(dplyr)
library(lubridate)
if(!file.exists("ExData_Plotting1")){
        dir.create("ExData_Plotting1")
}
#Zipped data URL
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

# Check for existence of zipped data file if doesn't exist download and extract the data to the GettingData folder.
if(!file.exists("./ExData_Plotting1/household_power_consumption.zip")){
        download.file(fileURL, destfile = "./ExData_Plotting1/household_power_consumption.zip")
        unzip("./ExData_Plotting1/household_power_consumption.zip", exdir = "./ExData_Plotting1")
        list.files("./ExData_Plotting1")
        dataDownloaded <- date()
        dataDownloaded
}
# Read the whole file. Not really sure how to read sections from a file as suggested in the assignment notes.
hpc <- read.table("./ExData_Plotting1/household_power_consumption.txt", sep = ";", header = TRUE)

# We will only be using data from the dates 2007-02-01 and 2007-02-02. 
# mutate the table and combine the Date and Time variables and get rid of the Time variable
# Got frustrated because there were problems with strptime and dplyr.
# and used lubridate instead
hpc <- mutate(hpc, Date = dmy_hms(paste(Date,Time))) %>% select(-(Time))
# filter out 2007-02-01 and 2007-02-02
day1 <- filter(hpc, as.Date(Date)=="2007-02-01")
day2 <- filter(hpc, as.Date(Date)=="2007-02-02")
# combine the two days
twodays <- rbind(day1, day2)
# Clean up a bit 
rm(day1, day2, hpc)

twodays <- mutate(twodays, 
                  Global_active_power = as.numeric(as.character(twodays$Global_active_power)),
                  Global_reactive_power = as.numeric(as.character(twodays$Global_reactive_power)),
                  Voltage = as.numeric(as.character(twodays$Voltage)),
                  Global_intensity = as.numeric(as.character(twodays$Global_intensity)),
                  Sub_metering_1 = as.numeric(as.character(twodays$Sub_metering_1)), 
                  Sub_metering_2 = as.numeric(as.character(twodays$Sub_metering_2)),
                  Sub_metering_3 = as.numeric(as.character(twodays$Sub_metering_3)))

png(filename = "./ExData_Plotting1/plot4.png", width = 480, height = 480)
par(mfcol = c(2,2))
# Top Left
plot(twodays$Global_active_power ~ twodays$Date, type="l", xlab="", ylab = "Global Active Power (kilowatts)")
# Bottom Left
with(twodays, plot(Date, Sub_metering_1, xlab="", ylab = "Energy sub metering", type="n"))
with(twodays, lines(Date, Sub_metering_1, col="black"))
with(twodays, lines(Date, Sub_metering_2, col="red"))
with(twodays, lines(Date, Sub_metering_3, col="blue"))
legend("topright", bty="n",col = c("black", "red", "blue"), lty=c(1,1,1), lwd=2, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))





