# Get Weather Data : Given valid stations and a date, this function will return weather data
# Bouchra Harnoufi - IBM Extreme Blue 2014

# Packages used : 
# "plyr" - author :  Hadley Wickham
# "weatherData" author : Ram Narasimhan

# Download packages if necessary
if (require("weatherData")) {
  print("weatherData is loaded correctly")
} else {
  print("trying to install weatherData")
  install.packages("weatherData")
  if (require(weatherData)) {
    print("weatherData installed and loaded")
  } else {
    stop("Could not install required packages (weatherData)")
  }
}
library(weatherData) 

if (require("plyr")) {
  print("plyr is loaded correctly")
} else {
  print("trying to install plyr")
  install.packages("plyr")
  if (require(weatherData)) {
    print("plyr installed and loaded")
  } else {
    stop("Could not install required packages (plyr)")
  }
}
library(plyr)

# These following functions are used by the main function (getWeather)

# Verify if the date format is correct or not 
IsDateInvalid <- function (date, opt_warnings=TRUE) {
  d <- try(as.Date(date))
  if (class( d ) == "try-error" || is.na(d)) {
    message(paste( "\n\nInvalid date supplied:", date ))
    return(1)
  }
  #If a date in the future is supplied, print an error message
  if(date > Sys.Date()){
    if(opt_warnings)
      warning(paste("\n\nInput Date cannot be in the future:", date))
    return(1)
  }
  return(0) #is okay
}


# Try to read an URL address
readUrl <- function(final_url) {
  out <- tryCatch ({
    u <- url(final_url)
    # readLines(u, warn=FALSE)
    readLines(u)
    # The return value of `readLines()` is the actual value
    # that will be returned in case there is no condition
    # (e.g. warning or error).
    # You dont need to state the return value via `return()` as code
    # in the "try" part is not wrapped insided a function (unlike that
    # for the condition handlers for warnings and error below)
  },
  error=function(cond) {
    message(paste("URL does not seem to exist:", final_url))
    message("The original error message:")
    message(cond)
    return(NA) # Choose a return value in case of error
  },
  warning=function(cond) {
    message(paste("URL caused a warning:", final_url))
    message("Here's the original warning message:")
    message(cond)
    # Choose a return value in case of warning
    return(NA)
  },
  finally= close(u)
  )
  return(out)
}

# Function getWeather
# Args: 
#          station: string representing a valid 3- or 4-letter Airport code or a valid Weather Station ID (examples: "BUF", "ORD", "VABB" for Mumbai)
#          date: a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#          station_type: = "airportCode" (3- or 4-letter airport code) or "ID" 
# Returns:
#         a vector (length: 15) containing weather data of station
getWeather <- function (station, date, station_type) {
  date <- as.Date(date)
  m <- as.integer(format(date, "%m"))
  d <- as.integer(format(date, "%d"))
  y <- format(date, "%Y")
  if (station_type == "id") {
    base_url <- "http://www.wunderground.com/weatherstation/WXDailyHistory.asp?"
    final_url <- paste0(base_url, "ID=", station, "&month=", 
                        m, "&day=", d, "&year=", y, "&format=1")
  }
  if (station_type == "airportcode") {
    airp_url = "http://www.wunderground.com/history/airport/"
    coda = "/DailyHistory.html?format=1"
    final_url <- paste0(airp_url, station, "/", 
                        y, "/", m, "/", d, coda)
  }
  wxdata <- readUrl(final_url)
  if (grepl(pattern = "No daily or hourly history data", wxdata[3])) {
    warning(sprintf("Unable to get data from URL\n                  \n Check Station name %s \n                  \n Check If Date is in the future %s\n                  \n Inspect the validity of the URL being tried:\n %s \n", 
                    station, date, final_url))
    message("For non-US Airports, try the 4-letter Code")
    return(NULL)
  }
  if (is.na(wxdata[1])) {
    warning(sprintf("Unable to get data from URL\n Check if URL is reachable"))
    return(NULL)
  }
  if (length(wxdata) < 3) {
    warning(paste("not enough records found for", station, 
                  "/n Only", length(wxdata), "records."))
    return(NULL)
  }
  wxdata <- wxdata[-c(1)]
  wxdata <- gsub("<br />", "", wxdata)
  header_row <- wxdata[1]
  tC <- textConnection(paste(wxdata, collapse = "\n"))
  wxdata <- read.csv(tC, as.is = TRUE, row.names = NULL, header = FALSE, 
                     skip = 1)
  close(tC)
  header_row <- make.names(strsplit(header_row, ",")[[1]])
  names(wxdata) <- header_row
  wxdata$DateTime <- as.POSIXct(strptime(paste(date, wxdata[[1]]), 
                                         format = "%Y-%m-%d %I:%M %p"))
  wxdata$DateUTC.br. <- NULL
  wxdata$SoftwareType <- NULL
  wxdata <- wxdata[order(wxdata$Time), ]
  row.names(wxdata) <- 1:nrow(wxdata)
  df <- wxdata
  return(df)
}

# Funcrion getData
# Args: 
#          station_id: vector of strings representing a valid 3- or 4-letter Airport code or a valid Weather Station ID (examples: "BUF", "ORD", "VABB" for Mumbai)
#                      or the name of the city (examples: "Paris","Berlin", "London")
#          date: a valid string representing a date in the past (YYYY-MM-DD, all numeric)
#          daily_min_temp: TRUE if the minimum temperature of the date is desired
#          daily_max_temp: TRUE if the maximum temperature of the date is desired
#          daily_min_hum: TRUE if the minimum humidity of the date is desired
#          daily_max_hum: TRUE if the maximum humidity of the date is desired
#          daily_min_pres: TRUE if the minimum pressure of the date is desired
#          daily_max_pres: TRUE if the maximum pressure of the date is desired
#          daily_min_wind: TRUE if the minimum wind speed of the date is desired
#          daily_max_wind: TRUE if the maximum wind speed of the date is desired
# Returns:
#         a data frame containing weather data of each station_id element
getData <- function (station_id, date, 
                     daily_min_temp = FALSE, daily_max_temp = FALSE, 
                     daily_min_hum = FALSE, daily_max_hum = FALSE, 
                     daily_min_pres = FALSE, daily_max_pres = FALSE, 
                     daily_min_wind = FALSE, daily_max_wind = FALSE) {
  coda <- NULL
  res <- data.frame()
  index <- 1
  if (IsDateInvalid(date)) {
    return(paste("Unable to build a valid URL \n Date format Invalid \n Input date should be within quotes \n and of the form 'YYYY-MM-DD' \n\n", date))
  } 
  for (i in 1:length(station_id)) {
    single_day_df <- getWeather(station_id[i], date[i], station_type = "airportcode")
    if (is.null(single_day_df)) {
      single_day_df <- getWeather(station_id[i], date[i], station_type = "id")
    }
    if (is.null(single_day_df)) {
      for (j in 1:15) {
        res[index,j] <- NA
      }
    } else {
      unik <- !duplicated(single_day_df$DateTime)
      temp <- single_day_df[unik,]
      c <- order(temp$DateTime)
      single_day_df <- temp[c,]
      for (j in 1:ncol(single_day_df)) {
        res[index,j] <- single_day_df[nrow(single_day_df),j]
      }
      if (daily_min_temp) {
        single_day_df[,2] <- as.numeric(single_day_df[,2])
        min_row <- which.min(single_day_df[,2])
        res[index,] <- single_day_df[min_row,]      
      } 
      if (daily_max_temp) {
        single_day_df[,2] <- as.numeric(single_day_df[,2])
        max_row <- which.max(single_day_df[,2])
        res[index,] <- single_day_df[max_row,]
      }
      if (daily_min_hum) {
        single_day_df[,4] <- as.numeric(single_day_df[,4])
        min_row <- which.min(single_day_df[,4])
        res[index,] <- single_day_df[min_row,]       
      } 
      if (daily_max_hum) {
        single_day_df[,4] <- as.numeric(single_day_df[,4])
        max_row <- which.max(single_day_df[,4])
        res[index,] <- single_day_df[max_row,]
      }
      if (daily_min_pres) {
        single_day_df[,5] <- as.numeric(single_day_df[,5])
        min_row <- which.min(single_day_df[,5])
        res[index,] <- single_day_df[min_row,]
      } 
      if (daily_max_pres) {
        single_day_df[,5] <- as.numeric(single_day_df[,5])
        max_row <- which.max(single_day_df[,5])
        res[index,] <- single_day_df[max_row,]
      }
      if (daily_min_wind) {
        single_day_df[,8] <- as.numeric(single_day_df[,8])
        min_row <- which.min(single_day_df[,8])
        res[index,] <- single_day_df[min_row,]
      } 
      if (daily_max_wind) {
        single_day_df[,8] <- as.numeric(single_day_df[,8])
        max_row <- which.max(single_day_df[,8])
        res[index,] <- single_day_df[max_row,]
      } 
    }
    index <- index + 1
  }
  return(res)
}

# Call to the function "getData" 

theDate <- c()
station <- c()
for (i in 1:nrow(modelerData)) {
  station <- c(station,as.character(modelerData$%%location%%[i]))
  theDate <- c(theDate,as.character(modelerData$%%recorddate%%[i]))
}
print(station)

if ("%%data%%" == "default") {
  mo <- getData(station, theDate)
} else {
  mo <- getData(station, theDate,%%data%% = TRUE)
}
print(mo)

mo[,15] <- as.character(as.POSIXlt(mo[,15],origin = "1970-01-01"))
for (i in 1 : nrow(mo)) {
  for (j in 1 : ncol(mo)) {
    if (!(is.na(mo[i,j]))) {
      if ((mo[i,j] == "") | (mo[i,j] == "-") | mo[i,j] == "N/A") {
        mo[i,j] <- NA
      }
    }
  }
}

#Construction of the modelerData and the modelerDataModel
modelerData <- cbind(modelerData,mo)

var1 <- c(fieldName= "Time" ,fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="",  fieldRole="")
var2 <- c(fieldName="Temperature",fieldLabel="",fieldStorage="real",fieldMeasure="",fieldFormat="",   fieldRole="")
var3 <- c(fieldName="Dew.Point",fieldLabel="",fieldStorage="real",fieldMeasure="",fieldFormat="",   fieldRole="")
var4 <- c(fieldName="Humidity",fieldLabel="",fieldStorage="real",fieldMeasure="",fieldFormat="",   fieldRole="")
var5 <- c(fieldName="Sea Level Pressure",fieldLabel="",fieldStorage="real",fieldMeasure="",fieldFormat="",  fieldRole="")
var6 <- c(fieldName="Visibility",fieldLabel="",fieldStorage="real",fieldMeasure="",fieldFormat="",  fieldRole="")
var7 <- c(fieldName="Wind Direction",fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="",   fieldRole="")
var8 <- c(fieldName="Wind Speed",fieldLabel="",fieldStorage="real",fieldMeasure="",fieldFormat="", fieldRole="")
var9 <- c(fieldName="Gust Speed",fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="",  fieldRole="")
var10 <- c(fieldName="Precipitation",fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="",    fieldRole="")
var11 <- c(fieldName="Events",fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="", fieldRole="")
var12 <- c(fieldName="Conditions",fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="",  fieldRole="")
var13 <- c(fieldName="Wind Dir Degrees",fieldLabel="",fieldStorage="real",fieldMeasure="",fieldFormat="",   fieldRole="")
var14 <- c(fieldName="DateUTC",fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="",  fieldRole="")
var15 <- c(fieldName="DateTime",fieldLabel="",fieldStorage="string",fieldMeasure="",fieldFormat="",  fieldRole="")

modelerDataModel <- data.frame(modelerDataModel, var1, var2, var3, var4, var5, var6, var7, var8, var9, var10, var11, var12, var13, var14, var15, stringsAsFactors = FALSE)



