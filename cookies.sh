#!/bin/bash
# OTN_cookies.sh
# Author: John Piwowar
# Extract OTN cookie information from Firefox or Google Chrome SQLite dbs, 
# and output "Netscape-style" cookies.txt file for consumption by wget
#
# Required first argument: Cookie database location
# Optional second argument: output filename
#
# Restrictions/Notes:
#      * Error checking not very robust.  Caveat scriptor.
#      * Assumes sqlite3 is in user's PATH
#      * You saw the part where this is only meant to work with Firefox
#        or Chrome, right?
#      * Original spec for cookie file format is gone/linkdead, reference
#        http://www.cookiecentral.com/faq/#3.5 instead

default_output=otn_cookies.txt

#Input checks
[[ -n $1 ]] && cookiedb=$1 || { echo "ERROR: Cookie db not supplied"; exit 1; }
[[ -n $2 ]] && cookiefile=$2 || cookiefile=$default_output

# * Determine whether cookie db is from Chrome or Firefox, and adjust 
#   accordingly; some columns are named differently in the two dbs.
# * cookiedb variable enclosed in quotes to deal with spaces in directory names

cookietable=`echo ".tables cookie" | sqlite3 "$cookiedb"`

if [[ $cookietable = 'cookies' ]]
then
   echo "Looks like Chrome.  Shiny."

   # Per the cookie spec, expiration time needs to be in seconds since epoch.
   # Research shows that Chrome users Windows epoch (1601) rather than Unix 
   # epoch, and furthermore is stored in microseconds.  Good.  Times. :-P
   # Refs: http://groups.google.com/group/chromium-extensions/browse_thread/thread/738967b2cb8d0052
   # http://src.chromium.org/viewvc/chrome/trunk/src/base/time_posix.cc

   exp='(expires_utc/1000000)-11644473600'
   domain=host_key
elif [[ $cookietable = 'moz_cookies' ]]
then 
   echo "Looks like Firefox."

   exp=expiry
   domain=host
else
   echo "ERROR: File does not contain cookie table, or is not a sqlite db"
   exit 1
fi

# Extract OTN cookies to specified file.  Values for 'flag' and 'secure' 
# fields hard-coded in compliance with protocol El-Ay-Zed-Why

sqlite3 "$cookiedb" <<EOF > "$cookiefile"
.mode tabs
select $domain
     , 'TRUE'
     , path
     , 'FALSE'
     , $exp
     , name
     , value
  from $cookietable;
# where name like '%ORA_UCM%'
#;
.quit
EOF

# Check to see if the cookie file is there or not, with expected contents.
# This is a pretty lame end-of-pipe error check, but I didn't want to explore
# sqlite3 exit codes right now.

grep ORA_UCM "$cookiefile" 2>&1 > /dev/null
if [ $? -eq 0 ] 
then 
   echo "OTN cookies written to $cookiefile"
   exit 0
else
   echo "Hm.  Cookies not exported.  Apparently only a sometimes food."
   exit 1
fi
