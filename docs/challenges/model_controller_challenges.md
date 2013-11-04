Primary Author: Jonathan Allen(jallen01)

New Item Conflicts
------------------
  
We require that all items in a group must have unique names. This poses some race condition problems because users are adding items simultaneously. To solve this problem, any new items that are created with the same name, just bring up the old items edit screen, which is what most users would want to happen. Furthermore, we throw an error if the user tries to rename an existing item with a name already used. Otherwise, we would have to merge the partition lists, which would be messy and confusing to the user.

Group-User Relation
-------------------

The relation between users and groups was tricky to model. Each user can be a member of multiple groups, and must be able to make payments to each group individually. To create this many-to-many relationship, we made a join table (Membership) which included the payment as a column. 

Unfortunately, the group also has a a group owner relation, which does not go through this join table. This poses a problem, because the group owner cannot make a payment to the group. To get around this problem, we automatically ceated an entry in the group_users table for the group owner, and check that it still exists every timre the group is saved.

Furthermore, users must also be able to share items attached to the group. Adding items to the GroupUsers entries would have been tricky, so we instead decided to do the reverse and add users to the Items table with a many-to-many join table called Partitions.

All of these decisions, make the user model passive, and we end up only queried the model when the user account information is needed. The Group and Item models have all the methods for adding users to groups and adding users to items.

Naming Problems
---------------
  
In our original design, we named the group-user relation GroupUser. This turned out to be a poor naming choice, because it was easy to confuse it with other group paths. We renamed it to Membership to avoid this confusion. We also renamed UserItem to Partition.

