# Loading Available Updates
# Ross Matsuda | Ntiva | August 2022
# Script to open System Preferences/Settings, and click through all necessary buttons to begin a software update
# Apple Silicon Note: Logic included to delay if user needs to plug device in to power to continue
# Apple Silicon Note: Script finishes execution when the OS prompts the user for their password (volume owner) to authorize update
# Confirmed operational for macOS 11, 12, 13 - 10.15 and earlier not supported

# Get Major OS (works in Ventura (13), Monterey (12), Big Sur (11))
set _major to system attribute "sys1"

# Bailout if old version
if _major < 11 then
	log "Catalina or earlier detected"
end if

# Ventura
if (_major = 13) then
	log "Ventura detected"
	
	#tell application "System Settings"
	#	activate
	#end tell
	
	# Launch software Update preference pane
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
	
	# Click "Update Now" or "Restart Now" if present
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
			
			
			# Approve EULA
			repeat 60 times
				
				# Insert code here to pause if Battery warning pops
				if exists (static text "Please connect to power before continuing updates." of sheet 1 of window "Software Update" of application process "System Settings" of application "System Events") then
					delay 5
					
					# Nested loop to test for this text now being gone
					repeat 60 times
						if exists (static text "Please connect to power before continuing updates." of sheet 1 of window "Software Update" of application process "System Settings" of application "System Events") then
							delay 5
						else
							# The power warning is gone, starting script over
							# This is just copying the first repeat statement of the script
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
						end if
						
					end repeat #End of the battery warning loop
					
				end if
				
				# Proceed with actually agreeing to EULA
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
	
	# Launch System Preferences
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
			
			# Click More Info button
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
			# End Click More Info button
			# Click Install Now
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
			# End Click Install Now
			
			# Insert code here to pause if Battery warning pops
			delay 2
			if exists (static text "Please connect to power before continuing updates." of sheet 1 of window "Software Update" of application process "System Preferences" of application "System Events") then
				log "Power warning detected, entering power check repeat"
				delay 5
				
				# Nested loop to test for this text now being gone
				repeat 60 times
					if exists (static text "Please connect to power before continuing updates." of sheet 1 of window "Software Update" of application process "System Preferences" of application "System Events") then
						log "Internal loop for power check - warning detected"
						delay 5
					else
						# The power warning is gone, starting script over
						# This is just copying the first repeat statement of the script
						log "Internal loop - power warning no longer detected"
						
						# Click More Info button
						repeat 60 times
							log "Looking for More Info button"
							if exists (button "More Info…" of group 1 of window "Software Update" of application process "System Preferences" of application "System Events") then
								click button "More Info…" of group 1 of window "Software Update" of application process "System Preferences" of application "System Events"
								exit repeat
							end if
							# Ensure app still open
							tell application "System Events"
								if application process "System Preferences" exists then
									delay 0.5
								else
									exit repeat
								end if
							end tell
							delay 1
						end repeat
						# End Click More Info button
						
						# Click Install Now
						repeat 60 times
							log "Looking for Install Now button"
							if exists (button "Install Now" of sheet 1 of window "Software Update" of application process "System Preferences" of application "System Events") then
								click button "Install Now" of sheet 1 of window "Software Update" of application process "System Preferences" of application "System Events"
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
						# End Click Install Now	
						exit repeat
					end if
					
				end repeat #End of the battery warning loop
			end if # End of battery warning if statement
			
			# Accept EULA
			log "Reached EULA check"
			repeat 60 times
				if exists (button "Agree" of sheet 1 of window "Software Update" of application process "System Preferences" of application "System Events") then
					click button "Agree" of sheet 1 of window "Software Update" of application process "System Preferences" of application "System Events"
					log "EULA button clicked, done"
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
			# End of EULA block
			
		end tell
	end tell
end if
