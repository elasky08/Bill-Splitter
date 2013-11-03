Primary author: Charles Liu (cliu2014)

# Security #

## 1 Summary of Security Requirements ##

+ **Access control:** The biggest security requirement is access control. Only users that are a part of a group should be able to view or edit the contents of the group.

+ **User permissions:** For this application, given our assumptions that users are not malicious towards each other, all members of a group should be able to see what everyone ordered and make edits to the list. In addition, only the creator of the group should be able invite people to the group and delete the group. These actions, especially delete, are riskier than simply editing the list of items purchased, so we restrict the number of people that can access it. To accomplish this, controllers should grab the resources through the user object so that, if any group does not belong to a user, it will appear nonexistent.

+ **No information to outside users:** For users that are not authorized to view a group, they have no reason to know that it exists. Thus, we will return the same error message as if they has submitted a nonexistent URL (similar to a 404 Not Found error). We assume that everyone can easily communicate with each other, so if one person needs to be invited, they can simply ask the group creator, instead of building an invite-request process which could potentially be spammed.

+ **General website security details:** For the major classes of attacks, we shall employ standard techniques such as hash+salt for passwords, stripping `<script>` tags, escaping input that is used in SQL queries, and CSRF tokens. Luckily, Rails handles many of these things for us.

## 2 How Standard Attacks are Mitigated ##

+ **Password security:** The Devise plugin is used for authentication. The plugin employs BCrypt, which securely encrypts passwords with the application key. In addition, BCrypt uses salts to further randomize the password digests. Should more security be needed, BCrypt supports calculating a digest multiple times, which makes reversing the process even harder.

+ **SQL injection attacks:** All transactions with the database are done via ActiveRecord, so no user input is executed directly as a query string. Our database calls are limited by the security vulnerabilities of ActiveRecord

+ **Script injection attacks:** We employ Rails' default HTML tag escaping mechanism to prevent JavaScript from being rendered in views. We also use Rails strong parameters to explicitly state which parameters are allows to be sent over a form.

+ **Cross-site request forgery attacks:** We use the default CSRF protection mechanisms built into Rails, which sends a CSRF token to be sent with all non-GET requests to prevent CSRF attacks. All requests, including non-GET AJAX requests, are protected by a CSRF token in the headers. Making requests to our AJAX endpoints outside of the site (to simulate a CSRF) was tested and the security mechanism was successful in preventing the attack.

+ **Security over the wire:** HTTPS is used throughout the site (except in development environments) so that the server-client communication is protected by TLS.

## 3 Threat Model and Assumptions ##

+ **Assumptions:** For this application, we make the assumption that, within each group, members are not adversaries against each other. That is, people are using this application to facilitate figuring out how much they should pay, but everyone is willing to pay their fair share. Furthermore, in the vast majority of cases, the members of the group can all easily communicate (sitting at the same table, for example), so discrepancies can be worked out easily.

+ **Confirmations to ensure inputs are correct:** Even with this assumption, there are mechanisms that should be built to make sure that the cost splitting does not have errors, whether malicious or accidental. In particular, when a user clicks the button to see how much  they should pay, they will see a "personalized receipt" which contains all of their items and the portions. This allows everyone to confirm that their costs are correct and correct any discrepancies with the rest of the group before paying.

+ **Data sensitivity:** The data that is stored in the app is not very sensitive. While access control will be implemented, we should make sure that our app does not sacrifice too much usability for security of the data. The most sensitive data is probably the login information, especially if users use the same usernames and passwords across different sites. 

+ **Outside attacks:** Even though the data is not sensitive, we want to be sure that only people that are invited to the group can see the details of the orders and money. We want to make sure that no one not in the group (even if they are a user of the app), can view, modify, or delete anything. We want to make sure that our app defends against the common website attacks including query and Javascript injection, CSRF, brute-force login, etc. This will make sure that no outside person can gain unauthorized viewing/editing or impersonate a member of a group.