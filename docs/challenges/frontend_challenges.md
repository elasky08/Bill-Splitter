Primary Author: Charles Liu (cliu2014)

## Using AJAX Actions ##
The majority of the front-end challenges deal with whether things should be in their own page or taken care of as AJAX. There are benefits and drawbacks to both:

+ Using AJAX actions make the UI seem smoother. There are fewer refreshes and the user generally doesn't have to wait for a round trip with the server.
+ However, each page can only have so many things without becoming too cluttered. In addition, standalone pages have more flexibility in terms of screen space, and forms etc. can take up larger areas and have more fields. Standalone pages are generally also easier to implement since Rails makes things easier, and we don't have to deal with creating and deleting DOM elements on the fly.
+ The modal that is used for the "display bill" feature is a tradeoff between the two, that gives lots of space to display things while not triggering refreshes all the time.

AJAX is used throughout so that the app is more responsive. By having everything done through AJAX, we send very little data over the wire. The only two "pages" are the list of all groups, and the list of items per group. Thus, whenever the user is working within a single group, there is no refresh needed.

## Refreshing and sychronization ##
We anticipate that users will want to simultaneously edit the page so that the items can be entered as quickly as possible. The first thing that is done to resolve this is to require unique item names. That way, if the same item is entered by two different users, it is only saved once.

However, different users may have reached the page at different times, when the group had different items in it. Thus, a user could visit a group, someone else could add a bunch of items, and the first user would have no idea. Then, if the first user tries to add the same items, his list will be unresponsive, since the items weren't added successfully.

What we want is to have the lists of groups and items refresh dynamically. One way to do this is via websockets. Unfortunately, Heroku doesn't support the default Rails websockets, and using external APIs such as Pusher tends to be more complicated.

The solution that I settled on involves simply refreshing the page every 5 seconds. There is not too much network overhead, since the amount of data sent back and forth is very small. 5 seconds seems to be a reasonable tradeoff between "real-time" and not making a horribly large number of requests.

## Items split across all users ##
Some items, such as tax, tip, appetizers, etc. are split between everyone. In those cases, it's very cumbersome to type in everyone's email. Thus, we made the "split across everyone" checkbox.

With the checkbox, it then became confusing, because the form was still showing. We thus finally decided that unchecking the checkbox also toggled the add user form to show or hide. Thus, it is very clear that an item is either split across everyone (checkbox checked), or split across the specified people (entered in the table).
