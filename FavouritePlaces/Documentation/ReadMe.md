#  Favourite Places by Brianne Byer
## First Milestone
### 26/04/23
Important Note: Had to create a new project and start app from beginning, due to issues with the DataModel.
Created ReadMe, to track progress of assignment.
Created DetailView, RowView and SearchView to segment code later.
Created Core database, called DataModel.
Created Peristence, which handles the DataModel.
Created ViewModel, which will handle any functions/extensions/classes etc., for application.
Grouped all created files under appropriate groups, as is best practice.
In DataModel, added entity called Location, and attributes called name (String) and picture (URL).

In Persistence, add struct to handle instance and call an error if container is unable to load.
In FavouritePlacesApp, to be able to use DataModel throughout app, variable persistenceHandler has been passed through ContentView.
Added @Environment to ContentView to access DataModel, including making attributes of Location variables.
Created a new Core database, called Places, replacing DataModel. Replacing attributes of the Location variables into Place variables.
Added addPlace and saveContext functions, which will be moved to ViewModel later.
Now able to addPlace and saveContext, has persistency.

Add the delPlace function, which deletes places, will be moved to ViewModel later.
To create a movePlace function, need to add a position attribute to Place entity.
Added navigationBaritems for editmode, so places can be moved and deleted. Added plus button into navigatiobaritems.
Issue with movePlace function, will need to come back later.

Removed Add button, as new plus button is in navbaritems.
Want to create a Search feature, so that users can find places.
Changed variable names for better understanding of what is happening in the code.
Created a very basic search bar, which will be updated in later milestones.

Noticed that Persistence was not being tracked, identified by the question mark. Added it through Source Control.
In Places, added entity called PlaceInformation, where attributes info/Detail/Image/Name/Latitude/Longitude were also added within that entity.
Added relationship between the entities, where Place owns PlaceInformation and vice versa.
DetailView will allow the user to change/add information about the place.
Aesthetic changes to ContentView... such as removing Clear button and putting TextField and Search NavLink into same HStack.

Added guard to prevent user to type in an empty locationName.
DetailView will display all the information of each place.
When editing, the user will be able to change the information, if not editing, they are shown the details.
Since I have set latitude and longitude to floats, this means their value must be changed to a string and then back to a number.
Commented out DetailView, maybe try adding image, so in ViewModel?

### 29/04/23
Removed entity PlaceInformation, as attributes can just be added in Place entity, reduces overall confusion. Removed any relationships between entities.
In ViewModel, added an extension to entity Place. Added important variables, for example, allowing long and lat to be strings for user input and changes, but then returned to original data type (floats). This will be used in the new DetailView.
In DetailView, added back some of the uncommented ("Old Code") before adding extension into ViewModel. Modified according to ViewModel.
Added NavLink in ContentView, so that when the user taps a place, they are directed to the place's individual details.

Tried to use saveContext() for DetailView, however, it is out of scope and a prvate func in ContentView. Created saveData func in ViewModel to be used throughout app.
Works within DetailView, so removed saveContext and replaced with saveData in ContentView. This works correctly and anything changed is saved when the app is refreshed also.

Next step is to be able to load images for each place. In ViewModel, added func to get the places images. Returns a default image if there is no allocated image for place. Able to add image to place, and display, however, not formatted correctly.
For RowView, created var in ViewModel that includes the name and description of place. This is shown with the image of place, referred to in ContentView. Need to format correctly.

Noticed that I was unable to add another place in ContenttView, changed func addPlace to fix issue. Removed guard func, as the textfield will only be used for Search. When user adds new place, name has default of New Location and a call to action to navigate to DetailView. However, when locationName is changed in DetailView, unable to see change in ContentView. Will come back to issue later.
In ViewModel, change var shown in ContentView. In RowView, Changed lineLimit to 2, to fit longer locationNames and locationDetails.
In DetailView, made each variable have their own HStack, changing textfield text to a gray colour and pushing text input by user to the right. LocationDetail is the exception, using the caption font. 
In RowView, made image format similar to image format in DetailView (rounded).
In DetailView, when user is editing, user will be prompted by "Enter...", with the text being changed to gray. 

Adding edit button to navigation bar in DetailView, to keep consistency with app.

30/04/23
As per M1 requirements, need to ensure the title of DetailView is editable (which should be the name of place) and that back button is the title of ContentView.
Added in Navtitle, that if there is no locationName, the default is Location Details, but if there is, it is the locationName of place. This is also persistent. However, still an issue with viewing the new changes in ContentView.
To change the default back buttton in DetailView, used presentationMode and ensured the default back button was hidden. Created custom back button in NavBarItems. 

Added sort, where list of places are sorted alphabetically according to placeName.
Commented out onMove and associated function, as it does not seem to be required for this Milestone. 
Note that there is still an issue between DetailView and ContentView to show changes in DetailView. Only exception are images.

Added comments to all func/methods/extensions used throughout app so far.

Created test (and commented) in FavouritePlacesTests, which checks that each view (Content/Detail/Search) is not nil. Thus, ensuring each view are properly initialised and each view is not empty. If they are empty, throws an error. Test suceeded.

## Second Milestone
### 10/05/23
Need to load default places, as currently the places only save on my device, but will not appear for others. Added the loadDefaultPlace function with 3 places that are automatically displayed for user.
In ContentView, changed the title of the 2 other default places, only shows Mt Tamborine 3x in a row. Will need to fix later.

### 19/05/23
Created LocationView, that will be used to show map and allows user to interact with map.
In DetailView, each place should have a picture of its google map location and the name of the location. This will replace the longitude and latitude textfield/text in DetailView. I first comment out long/lat.
DetailView needs to be connected to LocationView, as each place will have its own map. Used NavigationLink to do so.

To display map, LocationView uses MapKit and requires a longitude, latitude, rangeMeter and degreeDelta. Current values are default, so each place currently has the same map view (will change soon).
Added text of where the address and long/lat will later be a textfield, so that a user can search/find places. A slider has been added, but does not work yet.
Added NavigationTitle and NavigationBar to LocationView.

### 20/05/23
To make sure each place has its own map, we need to bind longitude and latitude to its own LocationView. Used @Binding in LocationView, so any changes will be made to DetailView. locationName uses @Binding also, for the NavTitle and address text (soon to be textfield).

To keep UI consistency, made sure that the back button of LocationView had the same icon as LocationView. 
Formatted Text (long, lat and name), aligned text for best UI practices.
Made sure back button uses the name of place, easier for the user to understand they are returning the places information screen.

Removed unneccessary comments in Views.
Formatted LocationView when user changes between editing and viewing LocationView. Such as changing text to textfields for long/lat and name. Aesthetic changes done also, like font and foregound colour.

Realised that my default places do appear in app (not just Mt Tamborine 3x in a row), this is because they only load if there is 0 places created by user. At the time, it did not update as the user had 3 places (Mt Tamborine 3 times!). Added new favourite places to default data.
Noticed that latitude and longitude are not appearing in LocationView, even though they should. Made sure that ifEditing in DetailView, the lat and long are saved.

Noticed that is not a requirement to change the name of a place in LocationView, as it may cause confusion. Changed TextField for name back to Text. 

###21/05/23
In order to be able to save longitude and latitude changes, I imported CoreData and declared var place to be used in LocationView. place.strLong equals to pLongitude and vice versa. Made sure to pass place from ContentView, to DetailView and then to LocationView. Any long and lat changes are now saved. Map not working yet.

I need to way to update the map according to changes in longitude and latitude, as well as name.
Created a DataModel, which will hold the class used for each place's map (MapLocation). As each variable is published, this means that views can react if they change.
Created a LocationViewModel, which will handle any functions or extensions used for LocationView. Both new swift files grouped under Map folder.
To be able to use DataModel, needs to be referred to in FavouritePlacesApp. It also must be referred to in ContentView so the model's class can be passed and updated throughout the views. In each view, the model is referred to.
Commented out code that needs to be updated, now that I am using the class's map. Can view and interact with map.

Another requirement of M2 is to see a small snippet of the location, from the place's map.
I used an instance of the MKCoordinatorRegion, which is based off the place's long and lat values (also being set as the center of the map snippet).

I realised that in DetailView, the reason why changes were not updating was due to not using onDisappear. Made sure to saveData(). This fixed the issue, but I am still unable to see changes in ContentView.

Back to the map in LocationView, commented code was uncommented and adjusted according to new use of class. 
In LocationViewModel, in order to use the class, we need to make an extension, so that lat and long of that class can be converted to Double. This will allow lat and long to be used for place's map. This is to also ensure they stay within the range of a realistic longitude and latitude.
Able to see long and lat change when interacting with map.

I need to be able to make sure that when a user changes mLongitude or mLatitude, this impacts the place's coordinates. 
In LocationView, created a function called checkMap(). checkMap calls the updateFromRegion function in LocationViewModel, which uses the longitude and latitude as the center of the map. It also ensures that mLat/Long is equal to the place's lat/long. Long and lat change, but the user cannot input their own lat and long yet to change map. Added another function in LocationView, fromLocToAddress(), which uses reverseGecoding to find name of location.

I can currently change coordinates and name according to map position, but not according to user input.
In checkLocation() from LocationView, we make sure that mLongStr/mLatStr is equal to mLat/mLong. 
Uncommented slider to be able to zoom on map. Added checkZoom(), which uses the funcs from LocationViewModel to function.
Created func checkAddress(), which uses fromAddressToLoc() in LocationViewModel. fromAddressToLoc also refers to updateViewLoc. Please see comments and documentation for explanation of how the map operates.

Simplified UI of LocationView.
Using saveData() throughout LocationView to have persistency in app.

Attempting to bind DetailView and LocationView, so that initial long and lat show on map for each place. Unable to do so.
### Thank you for the extension! 21st of May, 2023, 11:59pm

## Milestone 3
### 27/05/23
Added app icon.

Each place still has the same LocationView (map). To fix this issue, I used .task to checkMap() everytime the view (LocationView) appears. I then used .onAppear, which is also executed when LocationView appears, that sets up initial values of mLat and mLong, based on the values of the place object. It also called checkLocation() and checkMap(). Using .onDisappear, it ensures that every time the LocationView disappears, anything executed while the LocationView appears, is saved. 

Another issue is the zoom in LocationView. It is important that the zoom is persistent. 
In Entity Place, added attribute placeZoom, so that zoom can be updated and used across the app using CoreData. Made sure that when in Editmode of LocationView, when user has access to the zoom slider, if zoom slider is changed (mZoom), placeZoom is equal to mZoom. Added mZoom to onAppear, so that is changed when LocationView appears, and any changes are saved when LocationView disappears.

### 28/05/23
The major requirement in Milestone 3 is for each place to have their own sunset and sunrise times (shown in DetailView). To do so, first need to recognize each places timezone, and will use Swaggers Time API - https://timeapi.io/swagger/index.html.
In DataModel, added var timeZone to class MapLocation, to handle timezone of each place.
In ViewModel, added extension of Place (CoreData), to handle the timeZone var to be a string or another data type and handle the display view.
Now need to fetch the timezone using the chosen API, created a func and struct for timezone, the struct stores the decode values. 
Errors occured, need to add attributes placeTimeZone, placeSunset and placeSunrise, to store these values in CoreData as well as enable persistency. 
Referred to strTimeZone (locationTZ) in DetailView and used timeZoneDisplay to test that API is working. It should show Brisbane timezone.
Used .onAppear to update locationTZ to equal strTimeZone. Each place currently shows the Brisbane timezone.

Need to ensure that each place has own timezone. In ViewModel, changed feault Brisbane lat and long to each places own lat and long. Each place now has appropriate timezone.
Now that we have the timezone of each place, the sunset and sunrise can be found. Need to use another API - https://sunrise-sunset.org/api. In ViewModel, added structs and fetch function similar to time zone. 
Also created a similar display for sunset and sunrise times, to refer to in DetailView. Requires a function to convert GMT to TimeZone, refer to comments and documentation for more info.

Formatting DetailView and the displays of sunrise, sunset and timezone (in ViewModel) for better UI. Formatted LocationView as well.

In FavouritePlacesTests, removed Milestone 1 testing, as it is no longer relevant. Added two functions, one that checks that the map updates and is set up appropriately. The other checks the format of mLat, mLong are both String values, with 5 decimal places, as dictated in MapLocation.

Made sure any complicated code has a comment, and removed any unneccessary code.
Created SwiftDoc, access via Product -> Build Documentation.

One issue was that DetailView changes are not updated in ContentView. After looking through code, remembered that I have a separate RowView that displays both image and name of place. In RowView, there is no methods to update name if changed in DetailView. An easy fix was to use RowView for the image only,and reference name in ContentView. Formatted to ensure good UI.

Thank you for the extension! 31st of May, 11:59pm
## Video for Milestone 3: https://youtu.be/aVw9PiIq-us
