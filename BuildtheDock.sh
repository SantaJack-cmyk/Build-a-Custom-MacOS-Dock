#!/bin/bash

mkdir /Users/Shared/DockFile
chflags hidden /Users/Shared/DockFile
touch /Users/Shared/DockFile/dockscrap.txt
chmod ugo+rwx /Users/Shared/DockFile/dockscrap.txt


OUTFILE="/Library/Scripts/BuildtheDock.sh"
(
cat <<'EOF'
!/bin/bash

#Make sure to name script BuildtheDock.sh in order for it to run correctly. 
/bin/sleep 2

#Set Variable for DockUtil Binary
DOCKUTIL_BINARY=/usr/local/bin/dockutil

#Set Variable for Current User
currentuser=$USER

#Create a log file of this script
exec > /Users/$currentuser/Library/docklog.txt 2>&1

#Log the Variables
echo currentuser-variable = $currentuser
echo dockutil-variable = $DOCKUTIL_BINARY

############################################################

#Check to see if Dock has been built already
dockscrap=/Users/Shared/DockFile/dockscrap.txt
echo "The dockscrap file is set to" $dockscrap
grep -q -F "$USER" "/Users/Shared/DockFile/dockscrap.txt" && echo 'User Found, Exiting' && exit 0 || echo 'User Not Found, Continue to Build the Dock!'

############################################################

#Clear the Dock
echo Removing all Dock Items
$DOCKUTIL_BINARY --remove all --no-restart

#Build the Dock
$DOCKUTIL_BINARY --add '/System/Applications/Launchpad.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Google Chrome.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Firefox.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/System/Cryptexes/App/System/Applications/Safari.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/OneDrive.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft Outlook.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft Word.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft Excel.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft PowerPoint.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/zoom.us.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Utilities/Adobe Creative Cloud/ACC/Creative Cloud.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '~/Downloads' --view fan --display stack
echo Added Downloads-Fan View-Stack Display


#Create the dockscrap file and write the current username to the file

echo "$USER" >> /Users/Shared/DockFile/dockscrap.txt
EOF
) > "$OUTFILE"
