Primary Author: Charles Liu (cliu2014)

# Front-end Challenges #

The majority of the front-end challenges deal with whether things should be in their own page or taken care of as AJAX. There are benefits and drawbacks to both:

+ Using AJAX actions make the UI seem smoother. There are fewer refreshes and the user generally doesn't have to wait for a round trip with the server.
+ However, each page can only have so many things without becoming too cluttered. In addition, standalone pages have more flexibility in terms of screen space, and forms etc. can take up larger areas and have more fields. Standalone pages are generally also easier to implement since Rails makes things easier, and we don't have to deal with creating and deleting DOM elements on the fly.
+ The modal that is used for the "display bill" feature is a tradeoff between the two, that gives lots of space to display things while not triggering refreshes all the time.

Ultimately, I chose to use AJAX whenever possible (adding items, deleting items, etc.). There are some functions, such as creating groups and editing group name, that I would like to redo to fit into the new UI flow.

When creating a group, the "create group" page currently just takes a group name. It would be good to have the page also take a list of items, so it does not take two actions to complete a group. However, with the way that the group is represented on the backend, it is a lot more difficult, since each item needs to be created individually and added to an existing group. There is sort of a chicken-and-egg situation here: we want to create a group with items, but each item requires the group to be created.

The current way of creating groups was implemented because it was the easiest approach. In the final product, we plan on working around this and allowing items to be included when creating the group.