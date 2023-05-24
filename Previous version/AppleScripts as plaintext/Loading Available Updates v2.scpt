# OpenToMoreInfo - Ross Matsuda
# This version will click through all prompts, including the EULA, to run the update as quickly as possible.

# Get Major OS (works in Ventura (13), Monterey (12), Big Sur (11))
set _major to system attribute "sys1"

# Bailout if old version
if _major < 11 then
	log "Catalina or earlier detected"
end if

# Ventura
if (_major = 13) then
	log "Ventura detected"
	# This version of the script has multiple repeat loops at the end:
	# Loop 1 - click "Update Now" or "Restart Now" to begin the download/install
	# Loop 2 - Approve the EULA for the update
	# Only validated in macOS 13
	# May require alteration when macOS 14 is released to ensure button definitions
	
	#tell application "System Settings"
	#	activate
	#end tell
	
	do shell script "open x-apple.systempreferences:com.apple.Software-Update-Settings.extension"
	
	tell application "System Events"
		repeat 60 times
			if exists (window 1 of process "System Settings") then
				delay 3
				exit repeat
			else
				delay 1
			end if
		end repeat
		
		if not (exists (window 1 of process "System Settings")) then
			return
		end if
	end tell
	
	tell application "System Events"
		tell process "System Settings"
			repeat 60 times
				
				if exists (button "Update Now" of group 2 of scroll area 1 of group 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Software Update" of application process "System Settings" of application "System Events") then
					click button "Update Now" of group 2 of scroll area 1 of group 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Software Update" of application process "System Settings" of application "System Events"
					exit repeat
				end if
				
				if exists (button "Restart Now" of group 2 of scroll area 1 of group 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Software Update" of application process "System Settings" of application "System Events") then
					click button button "Restart Now" of group 2 of scroll area 1 of group 1 of group 1 of group 2 of splitter group 1 of group 1 of window "Software Update" of application process "System Settings" of application "System Events"
					exit repeat
				end if
				
				tell application "System Events"
					if application process "System Settings" exists then
						delay 0.5
					else
						exit repeat
					end if
				end tell
				
				delay 1
			end repeat
			
			repeat 60 times
				if exists (button "Agree" of sheet 1 of window "Software Update" of application process "System Settings" of application "System Events") then
					click button "Agree" of sheet 1 of window "Software Update" of application process "System Settings" of application "System Events"
					exit repeat
				end if
				
				tell application "System Events"
					if application process "System Settings" exists then
						delay 0.5
					else
						exit repeat
					end if
				end tell
				
				delay 1
			end repeat
		end tell
	end tell
	
end if

# Monterey and Big Sur
if _major < 13 then
	log "Monterey or Big Sur detected"
	tell application "System Preferences"
		activate
	end tell
	
	tell application "System Events"
		repeat 60 times
			if exists (window 1 of process "System Preferences") then
				exit repeat
			else
				delay 1
			end if
		end repeat
		
		if not (exists (window 1 of process "System Preferences")) then
			return
		end if
		
		tell application "System Preferences"
			set the current pane to pane id "com.apple.preferences.softwareupdate"
		end tell
	end tell
	
	tell application "System Events"
		tell process "System Preferences"
			repeat 60 times
				
				if exists (button 1 of group 1 of window "Software Update") then
					click button 1 of group 1 of window "Software Update"
					exit repeat
				end if
				
				tell application "System Events"
					if application process "System Preferences" exists then
						delay 0.5
					else
						exit repeat
					end if
				end tell
				
				delay 1
			end repeat
			
			repeat 60 times
				if exists (button 1 of sheet 1 of window "Software Update") then
					click button 1 of sheet 1 of window "Software Update"
					exit repeat
				end if
				
				tell application "System Events"
					if application process "System Preferences" exists then
						delay 0.5
					else
						exit repeat
					end if
				end tell
				
				delay 1
			end repeat
			repeat 60 times
				if exists (button 1 of sheet 1 of window "Software Update") then
					click button 1 of sheet 1 of window "Software Update"
					exit repeat
				end if
				
				tell application "System Events"
					if application process "System Preferences" exists then
						delay 0.5
					else
						exit repeat
					end if
				end tell
				
				delay 1
			end repeat
		end tell
	end tell
	
end if
