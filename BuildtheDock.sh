#!/bin/bash

#Jamf creates the dockscrap file that the script will need, and give it rwx permissions for all users
mkdir /Users/Shared/DockFile
chflags hidden /Users/Shared/DockFile
touch /Users/Shared/DockFile/dockscrap.txt
chmod ugo+rwx /Users/Shared/DockFile/dockscrap.txt


OUTFILE="/Library/Scripts/BuildtheDock.sh"
(
cat <<'EOF'
#!/bin/bash

#Make sure to name script BuildtheDock.sh in order for it to run correctly. 

#Change Sleep variable, the bigger the dock the longer the sleep variable. 2 seconds is good for most standard docs, 5 seconds is good for bigger docks with full suites of apps
/bin/sleep 5

#Set Variable for Docutil Binary
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
sleep 2 

#Build the Dock
# Get the major macOS version (e.g., "26" from "26.0.1")
MACOS_MAJOR_VERSION=$(/usr/bin/sw_vers -productVersion | /usr/bin/cut -d '.' -f 1)

# Conditionally add Apps.app or Launchpad.app based on OS version
if [[ "$MACOS_MAJOR_VERSION" >= 26 ]]; then
    echo "Adding Apps.app (macOS 26+)"
    $DOCKUTIL_BINARY --add '/System/Applications/Apps.app' --no-restart
else
    echo "Adding Launchpad.app (macOS < 26)"
    $DOCKUTIL_BINARY --add '/System/Applications/Launchpad.app' --no-restart
fi

$DOCKUTIL_BINARY --add '/System/Applications/Launchpad.app' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Google Chrome.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Firefox.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft Edge.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Adobe Acrobat Reader.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft Word.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft Excel.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Microsoft PowerPoint.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/zoom.us.app/' --allhomes --no-restart
$DOCKUTIL_BINARY --add '/Applications/Utilities/Adobe Creative Cloud/ACC/Creative Cloud.app/' --allhomes --no-restart

$DOCKUTIL_BINARY --add '~/Downloads' --view fan --display stack
echo Added Downloads-Fan View-Stack Display

#Write the current username to the dockscrap file

echo "$USER" >> /Users/Shared/DockFile/dockscrap.txt
EOF
) > "$OUTFILE"
