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
