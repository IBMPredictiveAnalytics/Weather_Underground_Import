# Weather Underground Import
##### Description:

This extension imports weather data for a vector of valid 3 or 4 digit Airport codes or a valid Weather Station ID (examples: "BUF", "ORD", "VABB" for Mumbai).    The extension will return a record of weather information for a given date at each location. 

---

##### User Interface:

This extension reads in a column of location from data in SPSS Modeler and accepts a date to import weather observations for.  Either one specific data field or the full last record on the given date can be imported.

![Dialog](https://raw.githubusercontent.com/IBMPredictiveAnalytics/Weather_Underground_Import/master/Screenshot/Dialog.png)
---
##### Output:

The following fields will be returned if the Last Record is selected.

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
 -  R 2.15.x or R 3.1

---
Installation instructions
----
1. Download the extension: [Download][3] 
2. Close IBM SPSS Modeler. Save the .cfe file in the CDB directory, located by default on Windows in "C:\ProgramData\IBM\SPSS\Modeler\16\CDB" or under your IBM SPSS Modeler installation directory.
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
- There is a sample available in the [example][6] directory


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