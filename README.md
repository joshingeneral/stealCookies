Steal Cookies
=============
This code was a small project I did to extend the bash script that John Piwowar built to 
get the OTN cookie data out of firefox or chrome.

Firefox is our target in this project and we basically add a menu to make for quickly parsing through and
logging in. 

Since Firefox uses a on disk sqlite database we can just copy it to our folder and start working right away. 

Instalation
-------------

Open stealCookies.sh and modify the URL of the Firefox profile accordingly. 

		
Usage
-----

	Run ./stealCookies.sh
	This will ask you some questions that should result in your downloading 
	a page (in this case a social network site) as the user. 


Troubleshooting
-----------------
You may have some trouble with the cookies.sh script, if this is the case you may have to 
open the sqlite database manually and grab the string to put in otn_cookies.txt in the following
format:
.facebook.com	TRUE	/	FALSE	1374011910	datr	Q-qlZFPC60mzY_NnqAmeaJie
