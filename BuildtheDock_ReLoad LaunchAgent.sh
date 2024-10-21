#!/bin/bash

#Set Variable for Current User
currentuser=$USER
echo currentuser-variable = $currentuser

#Make Sure the Launch Agent is Unloaded which allows for re-run
#change the launch agent name to your own name created in Launchd Package Creator
sudo -u $currentuser launchctl unload -w /Library/LaunchAgents/com.ets.buildadock.plist
echo Finished unloading launchagent

#Give it some time
/bin/sleep 2

#Load the Launch Agent
#change the launch agent name to your own name created in Launchd Package Creator
sudo -u $currentuser launchctl load -w /Library/LaunchAgents/com.ets.buildadock.plist
echo Finished loading launchagent

#Allow the Dock to build before the Jamf Policy says it's Done
/bin/sleep 7
