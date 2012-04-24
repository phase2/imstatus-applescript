-- Adium and Skype: Multiple IM and single IRC account statuses
on alfred_script(q)
	
	set q to q & " "
	set q to split(q, space)
	
	if appIsRunning("Skype") then
		tell application "Skype"
			set statusCommand to "SET PROFILE MOOD_TEXT" & item 2 of q
			if item 1 of q is "away" then
				send command "SET USERSTATUS DND" script name "IMStatus"
				send command statusCommand script name "IMStatus"
			else if item 1 of q is "back" then
				send command "SET USERSTATUS ONLINE" script name "IMStatus"
				send command statusCommand script name "IMStatus"
			end if
		end tell
	end if
	
	if appIsRunning("Adium") then
		tell application "Adium"
			if item 1 of q is "away" then
				set AppleScript's text item delimiters to " "
				go away with message items 2 thru -1 of q as string
				
				repeat with oneWindow in every chat window
					repeat with oneChat in every chat of oneWindow
						set chatName to (name of oneChat) as string
						set accountType to the name of the service of the account of oneChat
						if accountType is "IRC" and chatName = "#treehouseagency" then
							my setChatNick(oneChat, item 2 of q)
						end if
					end repeat
				end repeat
			else if item 1 of q is "back" then
				set AppleScript's text item delimiters to " "
				go available with message items 2 thru -1 of q as string
				
				repeat with oneWindow in every chat window
					repeat with oneChat in every chat of oneWindow
						set chatName to (name of oneChat) as string
						set accountType to the name of the service of the account of oneChat
						if accountType is "IRC" and chatName = "#treehouseagency" then
							my setChatNick(oneChat, item 2 of q)
						end if
					end repeat
				end repeat
			end if
		end tell
	end if
end alfred_script

-- Helper
on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning

-- Another helper
on setChatNick(theChat, theStatus)
	tell application "Adium"
		set currentNick to (the display name of the account of theChat as string)
		set nickParts to my split(currentNick, {"-"})
		set myNick to item 1 of nickParts
		
		if theStatus is not "" then
			send theChat message "/nick " & myNick & "-" & theStatus
		else
			send theChat message "/nick " & myNick
		end if
	end tell
end setChatNick

to split(someText, delimiter)
	set AppleScript's text item delimiters to delimiter
	set someText to someText's text items
	set AppleScript's text item delimiters to {""} --> restore delimiters to default value
	return someText
end split
