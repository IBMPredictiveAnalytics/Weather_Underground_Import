# Weather Underground Import
##### Description:

This extension imports weather data for a vector of valid 4 digit ICAO Airport codes or a valid Weather Station ID (examples: "KBUF", "KORD", "VABB" for Mumbai).    The extension will return a record of weather information for a given date at each location. 

Note: Visit [Weather Underground](http://www.wunderground.com/) to find the correct Airport code or Station ID if needed.  Wikipedia maintains a list of ICAO Airport codes [here.](https://en.wikipedia.org/wiki/International_Civil_Aviation_Organization_airport_code#Prefixes)

---

##### User Interface:

This extension reads in a column of location from data in SPSS Modeler and accepts a date to import weather observations for.  You have the option to return the last record on file for the date or select the record that is the minimum or maximum for each of the weather features. For example you can return the records for a date that contain the minimum temperature for the date at each location. 

![Dialog](https://raw.githubusercontent.com/IBMPredictiveAnalytics/Weather_Underground_Import/master/Screenshot/Dialog.png)
---
##### Output:

The following fields will be returned when the node is executed:

- Time
- Temperature
- Dew.Point
- Humidity
- Sea Level Pressure
- Visibility
- Wind Direction
- Wind Speed
- Gust Speed
- Precipitation
- Events
- Conditions
- Wind Dir Degrees
- DateUTC
- DateTime


![Output](https://raw.githubusercontent.com/IBMPredictiveAnalytics/Weather_Underground_Import/master/Screenshot/Output.png)

![Stream](https://raw.githubusercontent.com/IBMPredictiveAnalytics/Weather_Underground_Import/master/Screenshot/Stream.png)
---
Requirements
----
- IBM SPSS Modeler v16 or later
- ‘R Essentials for SPSS Modeler’ plugin: [Download here][8]
-  R 2.15.x or R 3.1 ([Use this link][8] to find the correct version)

---
Installation instructions
----
1. Download the extension: [Download][3] 
2. Close IBM SPSS Modeler. Save the .cfe file in the CDB directory, located by default on Windows in "C:\ProgramData\IBM\SPSS\Modeler\version\CDB" or under your IBM SPSS Modeler installation directory.  Note: this is a hidden directory, so you need to type it in manually or copy/paste the file path.
3. Restart IBM SPSS Modeler, the node will now appear in the Model palette.

---
R Packages used
----
The R packages will be installed the first time the node is used as long as an Internet connection is available.
- [plyr][4]
- [weatherData][9]
 
---
Documentation and samples
----
- Find a PDF with the documentation of this extension in the [Documentation][5] directory
- There is a sample available in the [Example][6] directory


---
License
----

[Apache 2.0][1]


Contributors
----

  - Armand Ruiz ([armand_ruiz](https://twitter.com/armand_ruiz))


[1]: http://www.apache.org/licenses/LICENSE-2.0.html
[3]: https://github.com/IBMPredictiveAnalytics/Weather_Underground_Import/blob/master/Source%20code/WeatherUndergroundImport.cfe
[4]: https://cran.r-project.org/web/packages/plyr/
[5]: https://github.com/IBMPredictiveAnalytics/Weather_Underground_Import/tree/master/Documentation
[6]: https://github.com/IBMPredictiveAnalytics/Weather_Underground_Import/tree/master/Example
[8]: https://developer.ibm.com/predictiveanalytics/downloads/
[9]: https://cran.r-project.org/web/packages/weatherData/