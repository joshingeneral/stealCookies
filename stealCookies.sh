#!/bin/bash
cp ~/Library/Application\ Support/Firefox/Profiles/*/cookies.sqlite cookies.sqlite
./cookies.sh cookies.sqlite

echo "What URL would you like to wget?"
echo "1 = Gmail.com"
echo "2 = Facebook.com"
echo "3 = https://moodle.uncc.edu/"
echo "3 = Other"

# Set varibles 
read URLinput

# We would like to help the user some with the capture
if [ $URLinput == 1 ]
then
 URL="http://mail.google.com/mail/h/"
elif [ $URLinput == 2 ]
then 
 URL="https://www.facebook.com"
else
 echo "Please enter URL now:"
 read URL
fi


# However if it isn't any of the listed, then we just use what they gave us.

echo "Please select a number for User-Agent"
echo "1 = Firefox 4.0"
echo "2 = Android 2.1"
read agentNum

if [ $agentNum == 1 ]
then 
 userAgent="\"Mozilla/5.0\ (Windows NT\ 5.2; WOW64;\ rv:2.0)\ Gecko/20100101\ Firefox/4.0\"";
 echo "User Agent Set to:" $userAgent;

fi

if [ $agentNum == 2 ]
then
 userAgent="Android 2.1";
 echo "User Agent Set to:" $userAgent;
fi

#echo "How deep do you want to go?"
#read Recursion

echo "What would you like to call the output file?"
read OUT

wget --load-cookies=otn_cookies.txt  -U "$userAgent" "$URL" -O $OUT #-r $Recursion
