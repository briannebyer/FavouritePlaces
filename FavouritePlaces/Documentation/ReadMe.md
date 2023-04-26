#  Favourite Places by Brianne Byer
## First Milestone
### 26/04/23
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



