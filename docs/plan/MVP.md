Primary Author: Charles Liu (cliu2014)

# Minimal Viable Product #

At its essence, BillSplitter is an app that allows its users that go out together to split costs easily. Our MVP is an app that handles the most basic case -- going out where everyone splits all costs equally.

In the MVP, users are able to log into the app and create groups. Each group is a set of people that shares the items. With the group, the user can add a list of items and their associated costs. Finally, a "tip calculator" allows for flexible tip and tax calculation and splits the bill evenly.

In particular, our MVP accomplishes at a basic level the features of bill and item splitting as well as the privacy concerns outlined in the features description (behavior/feature_descriptions.md). With the features implemented, the UI could definitely be polished aesthetically. AJAX is used throughout to make the app feel smooth and prevent unnecessary refreshes. User access control is functional -- users without adequate permissions cannot view pages -- although error messages could be polished.

The biggest issue that is postponed is the attaching of users to items. This will allow for greater flexibility in splitting items different ways. It is definitely a feature that we will implement in the final product. Furthermore, we postponed having users specify how much they actually paid, so they can spot their friends. This is not difficult to implement in the final version. 

In addition, for adding items, we would like to give the users more options. One option to give would be to specify quantity. In addition, with multiple users potentially adding simultaneously, we will enforce uniqueness on the item name (which is another reason why quantity will be necessary).

The current product is a good way for users to keep track of their orders and calculate how much to actually pay. More importantly though, it is easy to extend to include more features. Most of these features will be implemented as AJAX calls, and therefore will work with the current user interface. 

This MVP also allows us to test out the user interface. Because the additional features fit into the existing UI, we can get feedback on this UI and be reasonably confident that improvements will be relevant in the final product.

Finally, the MVP forced us to certify that our data model was correct. In the implementation of the MVP, we covered almost all aspects of our data model, with the exception of user-item connections. By making sure that our MVP's features were all implemented, we made sure our data model was complete and accurate.
