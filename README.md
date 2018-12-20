GCPD Tracker System 
===
This is the finished code for Phase 5 of the Gotham City Police Department Tracker System.  This project was assigned in the fall of 2018 as a 67-272 project at Carnegie Mellon University, Information Systems department.  More information about the project can be found at [67272.cmuis.net](https://67272.cmuis.net).


Populating the dev database
---
You can populate the development database with a decent number of fictitious records with the command `rake db:populate`.  There are over 50 investigations generated, but only one is initially closed.

There is also a large set of criminals generated this time around, including many from Batman's famous 'Rogues Gallery'. Great reading and worth formatting appropriately.

Notes on tests
---
There is 100% test coverage for existing models and helpers, including abilities.


Cloning this repo
---
After cloning this repo to your laptop, switch into the project directory and remove the reference to `origin` with the following:

```
  git remote rm origin
```


Notes on new implementations
---
- Abilites have been included in controllers and views.
- Criminal, Suspect, Investigation Note, Crime Investigation, and User controllers and views have been added to the system.
- For easy user access, I have implemented best in place with helpful tooltips to show what the user can edit and change.
- Different types of users can see different things on their dashboard which may promote their differing paths to information.
- Assignments can now be added from both Officer and Investigation screens, and similarly Suspects can be added from both Criminal and Investigation screens.
- Changed the interface design a bit (with new circle buttons!!) so hopefully it looks better than the default.

