Concepts
========

+ **Itemized Bill** - the list containing all items ordered and their costs. At a restaurant, for example, this would be the itemized receipt. Itemized bills do not specify how much each person owes. BillSplitter takes an itemized bill and figures out the amount each person is responsible for.

+ **Individual Order** - an item ordered and part of the itemized bill that is consumed by exactly one person. Individual orders are easy to deal with; the person who ordered it simply pays for the entire order.

+ **Group Order** - an item ordered and split by a number of different people. We deal with the common case (e.g. food, hotel room) where everyone is equally responsible for paying for the order. Notice that not *every* member of the group must partake in a group order. For example, three of the five people going to dinner together could agree to share an appetizer.

+ **Spotting** - to pay for someone else, usually with the expectation that the money is returned. Common examples include paying for someone at a restaurant, paying for someone using your credit card and having them pay back in cash, etc.

+ **Payment** - a transfer of money from one person to the "pool". The sum of payments must equal the total cost of the itemized bill. A person's payment may be more or less than the cost that they are responsible for, if they spot someone, or someone spots them.
