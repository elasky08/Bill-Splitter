Primary Author: Jonathan Allen(jallen01)

Group-User Relation
-------------------

The relation between users and groups was tricky to model. Each user can be a member of multiple groups, and must be able to make payments to each group individually. To create this many-to-many relationship, we made a join table (GroupUsers) which included the payment as a column. 

Unfortunately, the group also has a a group owner relation, which does not go through this join table. This poses a problem, because the group owner cannot make a payment to the group. To get around this problem, we automatically created an entry in the group_users table for the group owner, and check that it still exists every time the group is saved.

Furthermore, users must also be able to share items attached to the group. Adding items to the GroupUsers entries would have been tricky, so we instead decided to do the reverse and add users to the Items table with a many-to-many join table called UserItems.

All of these decisions, make the user model passive, and we end up only queried the model when the user account information is needed. The Group and Item models have all the methods for adding users to groups and adding users to items.

Many-To-Many Controllers
------------------------

Another challenge we faced, was how to control the many-to-many relations, GroupUsers and UserItems. Our first thought was to just add methods to the groups controller and the items controller, but we decided instead to create controllers for these join tables, so that we could keep most of our methods RESTful (eg. can post to group_user_url to create a GroupUser relation).

