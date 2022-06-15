# openToMoreInfo

With some additional components, it is possible to have users click on the "Update Device" button in Nudge and be taken directly to the "More Info" list of available minor updates to apply.

![Example of System Preferences/Software Update/More Info window](https://support.forgetcomputers.com/hc/article_attachments/4415135648013/bigSur_MoreInfo.png)

## WHY
Many users in our environment complain of confusion when running Nudge, because of Apple's placement of macOS upgrade banners. Instructing users to look for a smaller "More Info" button, of which there can be two thanks to the upgrade banner, is cumbersome. We've included screenshots to help guide users, but it would be much more convenient to bypass the first page altogether and have the Nudge button take users as far as possible to minimize mistakes and support desk tickets.

## LIMITATIONS
At the moment, this workflow only works in Nudge Swift, as I have not yet been able to find a way to get Nudge Python to invoke the launcher app. The AppleScript logic itself is tested in 10.15.7, so this may eventually be supported.

## VERSIONS
Loading Available Updates.scpt
• Original build
• Opens the Systems Preferences app, clicks "More Info"

Loading Available Updates_v2.scpt
• First revision
• Opens the System Preferences app, clicks "More Info", then "Install", then approves the EULA prompt
• This represents a true "one click" workflow from Nudge, but may not be appropriate for all environments

## COMPONENTS
In order to make this function, a few items need to be in place:

### 1. Signed AppleScript app

You'll embed some AppleScript commands into an application bundle and sign it with your developer ID so that it will not get caught/barred by Gatekeeper upon execution

### 2. PPPC for app

The app you've built requires a few permissions to be set in order to function

### 3. "actionButtonPath" key in configuration

You'll need to define a path using the `file` URI that points at your app. Please note that because we're using this key, this does limit Nudge's functionality to only minor updates by default, and users will have to cancel out of the "More Info" window to view the macOS upgrade banner if they want to click on it

## WALKTHROUGH

### 1. Create your AppleScript

In Script Editor on your device, [paste this code](https://github.com/xirianlight/openToMoreInfo/blob/main/Loading%20Available%20Updates.scpt)

Select File → Export

Set File Format to "Application"

For code signing, you have two options:

* Set Code Sign to your Developer ID if you're comfortable with the app being visible in the Dock while running (this is helpful for testing and validation)

* Set Code Sign to "Don't Code Sign" when you've finished testing - you'll be editing the .app bundle and signing it manually to hide the Dock icon while it is running.

###  1a. Hide the app from the Dock

Locate your created app and open dig through the package to Contents/Info.plist

Add the following key and save:

`<key>LSUIElement</key>`

`<true/>`

In Terminal, run the following command, targeting your app bundle and replacing the text in quotes with the full name of your developer ID:

`codesign --force --sign "Apple Development: John Doe (1234567890)" -v /path/to/bundle.app`

Your app should now be signed and ready for MDM distribution. If you receive an error about 'resource fork, Finder information, or similar detritus not allowed', run the following command to strip extended attributes from your bundle, then try signing again:

`xattr -cr /path/to/bundle.app`

### 2. PPPCs for your app bundle

Feel free to use the [example PPPC available here](https://github.com/xirianlight/openToMoreInfo/blob/main/PPPC%20-%20Loading%20Available%20Updates.mobileconfig), or create your own. Required permissions include:

* Accessiblity
* Apple Events → System Events
* Apple Events → System Preferences

### 3. Add the actionButtonPath variable to your Nudge configuration

In your Nudge settings, define the userInterface : actionButtonPath variable using the File URI pointing to where you'll deploy your app. Example in JSON:

`"actionButtonPath":"file:///Library/myCompany/data/nudgeAssets/Loading%20Available%20Updates.app",`

Once this is complete, you can further update your Nudge preferences to test and observe how the app behaves. 

## NOTES

The script as published will time out and terminate after a maximum of 90 seconds has elapsed.

Implementing the actionButtonPath key may cause you trouble if you normally use Nudge for major OS upgrades

If the PPPC is not present on a target workstation and you run this, the user will be hit with multiple PPPC prompts and the script will fail

At this time, this method only works for Nudge Swift, not Nudge Python

There isn't a fallback for what Nudge will do if the targeted application isn't present, which can cause problems. I recommend including flavor text in your Nudge window to educate the user on how to get to System Preferences → Software Update manually if they wish to trigger the update at their convenience.
