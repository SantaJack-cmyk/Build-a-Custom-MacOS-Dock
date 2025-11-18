#!/bin/bash

LAUNCH_AGENT_PLIST="/Library/LaunchAgents/com.IT.buildadock.plist"

DOCK_BUILD_WAIT_TIME=7 

logged_in_user=$(/usr/sbin/scutil <<< "show State:/Users/ConsoleUser" | \
                  /usr/bin/awk '/Name :/ && !/loginwindow/ { print $3 }' | \
                  /usr/bin/tr -d '[:space:]')

if [[ -z "$logged_in_user" ]]; then
    echo "ERROR: Could not determine the logged-in user's name. Exiting."
    exit 1
fi
user_uid=$(/usr/bin/id -u "$logged_in_user")

if [[ ! -f "$LAUNCH_AGENT_PLIST" ]]; then
    echo "ERROR: Launch Agent file not found at $LAUNCH_AGENT_PLIST. Exiting."
    exit 1
fi

echo "--- Script starting for user: $logged_in_user (UID: $user_uid) ---"

DOMAIN_TARGET="gui/$user_uid"

echo "1. Attempting to BOOTOUT (unload) Launch Agent (if loaded)..."

sudo -u "$logged_in_user" /bin/launchctl bootout "$DOMAIN_TARGET" "$LAUNCH_AGENT_PLIST" 2> /dev/null

echo "Bootout command executed."

/bin/sleep 1 # Brief pause

echo "2. Attempting to BOOTSTRAP (load) Launch Agent..."
sudo -u "$logged_in_user" /bin/launchctl bootstrap "$DOMAIN_TARGET" "$LAUNCH_AGENT_PLIST"

if [[ $? -ne 0 ]]; then
    echo "ERROR: Failed to bootstrap (load) Launch Agent."
    exit 1
else
    echo "Successfully bootstrapped Launch Agent."
fi

echo "3. Pausing for $DOCK_BUILD_WAIT_TIME seconds to allow Dock to rebuild..."
/bin/sleep "$DOCK_BUILD_WAIT_TIME"

echo "--- Script complete. ---"
exit 0
