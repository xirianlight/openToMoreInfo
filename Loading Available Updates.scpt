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
	end tell
end tell
