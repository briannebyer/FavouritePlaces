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

