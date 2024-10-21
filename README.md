# Build-a-Custom-Dock

****I've created a fork of bluemoosegoose's script with some minor improvements for more administrative control on lab devices***

This Guide allows you to craft a custom MacOS dock for your environment. I wrote this to be deployed from Jamf Pro but you can use any MDM.

Verified working on Sequoia 15.0.1 and is backwards compatible to Catalina.

The custom dock will be built once, on first login, for any user that logs in to the Mac.

After the dock has been built once, it will not run again automatically, which is the intended behavior because we want our users to have our custom dock during initial login and then give them the ability to make changes.

If you want to re-run the custom dock again, this is possible and can be scoped to a policy or placed in Self-Service. Continue reading for more info.



**How to Build a Custom MacOS Dock**

1.	Download and install the latest version of dockutil: https://github.com/kcrawford/dockutil/releases
2.	Upload the package to Jamf Pro (i.e.. “dockutil-3.1.3.pkg”)

**Create a bash script that will utilize the dockutil binary**

3.	Download **"BuildtheDock.sh"** from the repository.
4.	Feel free to modify lines 44+ of "buildthedock.sh" to create your own custom dock, do not modify the dockscrap file command at the end of the script. 
5.	If you want to add a webloc web shortcut to the dock with a custom icon you need to create the .webloc file on your test mac and place the file in the filepath location of your choosing, package it with Jamf Composer, upload the PKG to Jamf Pro and then add that PKG to the main Policy (Step 18 of this guide). Ensure the line in your  “BuildtheDock.sh” looks like this (and replace the filepath and name with your specific webloc):

$DOCKUTIL_BINARY --add '/Library/Application Support/Dock Icons/Office 365.webloc' --label 'Office 365' --no-restart

6.	Copy the **"BuildtheDock.sh"** into your jamf script repository, this will allow us to more easily modify the script if dock icons need to be updated, rather than composer packaging the script.

**Create a Launch Agent (.plist) that will run the above script when loaded**

7.	Download launchd Package Creator: https://github.com/ryangball/launchd-package-creator
8.	Install and open launchd Package Creator.
9.	Choose “Launch Agent” and name the Identifier “com.*insert your org name*.buildadock”
10.	Version: “1.0” ### this doesn't really matter, it can be whatever version you want it to be
11.	Click “Select Path” and navigate to the location you saved “BuildtheDock.sh”
12.	Check “Do not package the Target (use existing path in plist)”
13.	Check “RunAtLoad”
14.	Click “Create PKG”, name it “buildadockagent” and save it to your Downloads (or some other location you can access) Verify it created successfully in this location.
15.	Upload "buildadockagent.pkg" to Jamf.

**Create a bash script to run the launch agent as the current user**

16.	Upload **“BuildtheDock_ReLoad LaunchAgent.sh"** from this repository into your Jamf Pro.

**Putting it all together**

17.	Create a Jamf Policy and name it
18.	Attach the 2 packages we just created (or 3+ if you have weblocs in your script):

  #1. Dockutil-3.0.2.pkg  
  #2. Buildadockagent.pkg    
  #3. Office365.webloc.pkg (optional)  

![image](https://user-images.githubusercontent.com/104439807/165319011-d4cc4cba-e839-47f4-b137-36f5c62780d6.png)


19.	Attach the Script **“BuildtheDock_Reload LaunchAgent.sh”** and set the Priority to run After other actions.

![image](https://user-images.githubusercontent.com/104439807/165331996-6653c5b4-f49a-4807-a0c6-e56278e761f9.png)


20.	Scope the Policy to your devices to run on recurring check-in, once per device. 

*Note*: This will only run ONCE for each User unless you proceed to the following steps.

**How to Re-load the Dock Anytime you Want**

Deleting the "dockscrap.txt" file from "/Users/Shared/DockFile" will allow the script to run at User logon which will rebuild the dock again (and recreate the "dockscrap.txt" file). You can automate this in Jamf Pro to reload the dock as many times as you want by doing the following:

1. Upload "A_Delete Dockscrap.sh" (found in this repository) to Jamf Pro.
2. Clone your "Build Custom Dock" Policy. Name it something else...like "Reload Custom Dock - Self Service"
3. Add the "A_Delete Dockscrap.sh" to the policy. 
4. In this Policy you should have your 3+ PKG's (outlined in the original Policy explained above) and 2 scripts: "A_Delete Dockscrap.sh" (must run 1st) and "BuildtheDock_ReLoad LaunchAgent" (must run 2nd). In the Policy, set both scripts to run "After" the PKG's install. It's important to keep the naming convention as just described, or else Jamf will not run the scripts in the correct order and it will fail.
6. Scope to Self-Service.
   * note: on Lab devices, I typically bundle A_Delete Dockscrap.sh with the original policy, it'll delete nothing the first time, since the dockscrap file doesn't exist yet, but if the policy needs to be re-run because I made changes to the dock, it will delete the dockscrap. (new application, or lab coordinator wanted apps in a different location) 
![image](https://user-images.githubusercontent.com/104439807/165342728-a6e54d98-2805-4991-b007-1bc4667f4c4c.png)


**Endnotes:**

To follow along with the install as the policy is being run:

1. Watch dockutil binary get installed here: /usr/local/bin/dockutil
2. Watch the "BuildtheDock.sh" file get installed here: /Library/Scripts/BuildtheDock.sh
3. Watch the  .plist file get installed here: /Library/LaunchAgents/com.fhda.buildadock.plist
4. Watch dockscrap.txt file get installed here : /Users/Shared/DockFile/dockscrap.txt
5. Check the log at: /Users/$currentuser/Library/docklog.txt
