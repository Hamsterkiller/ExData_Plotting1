# file.create("./subsetData.csv")

# STEP1
# preprocessing source data to reduce memory usage
src <- file("./household_power_consumption.txt", open="r")
res <- file("./subsetData.csv", open="w")

# STEP3
# preprocess data to reduce memory usage
preprocess(src, res)
clearData <- read.csv("./subsetData.csv", header=TRUE)

## 'Sub_metering' timeseries 
# adding datetime variable
datetime <- strptime(paste(clearData$Date, clearData$Time, sep=" "), "%d/%m/%Y %H:%M:%S") 
clearDataDateTimed <- cbind(clearData, datetime)
# exporting plot to PNG (480x480 dpi)
# launching png-device
png(file="plot3.png", width = 480, height = 480)
with(clearDataDateTimed, plot(datetime, Sub_metering_1, type = "l", xlab="", ylab="Energy sub metering", col="black"))
points(clearDataDateTimed$datetime, clearDataDateTimed$Sub_metering_2, type="l", col="red")
points(clearDataDateTimed$datetime, clearDataDateTimed$Sub_metering_3, type="l", col="blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty=c(1, 1, 1), col=c("black", "red", "blue"))
dev.off()


# STEP2
#___________________________________________________________________________________________
## preprocessing function, source before launching base program
preprocess <- function(src, res) {
  
  #first iteration
  buffer <- read.table(file=src, header=TRUE, sep=";", nrows=100000)   
  subsetData <- subset(buffer, buffer$Date == "1/2/2007" | buffer$Date == "2/2/2007")
  write.table(subsetData, file=res, sep=",")
  
  repeat {
    buffer <- read.table(file=src, header=FALSE, sep=";",  nrows=100000)      
    subsetData <- subset(buffer, buffer$Date == "1/2/2007" | buffer$Date == "2/2/2007")
    write.table(subsetData, file=res, sep=",", col.names=FALSE)
    print(c("Number of rows buffered: ", nrow(buffer)))
    
    png
    if(nrow(buffer) < 100000) {
      close(src)
      close(res)
      break;
    }
    
    
  } 
  
}