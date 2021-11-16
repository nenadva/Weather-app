# The Weather, a Simple Weather App Using the Open Weather Map api.

This app demos use of the Open Weather Map api. The UI is simple,
with views of the current conditions, the five day forecast, and a detail view 
of any one of the days selected by the user. CoreLocation is used to fetch 
the device location, and to fetch and display weather data for that location.

UITests fetch weather live data and assert that correct, live data is shown in the app.
The UI tests can be run by typing command-u. 

The Segues class decouples the 5 day controller from it's context: the 
5 day controller doesn't hard code the type of the daily forecast controller
when a user taps on a cell or the today view.

The 5 day table view controller is generic: the model and cell types are generic
across the 5 day table view implementation.

The ForecastViewModel provides api for customized display of the weather data.

A compass direction string is calculated from the wind degrees returned from the Open Weather Map server.

Localized strings are in place and used, although English is the only language supported at the moment.

The header view shows the temp min and temp max from current conditions to be consistent 
with the rest of the app showing daily min/max.

The minimum deployment target to 9.3 to allow testing on a 4s.

