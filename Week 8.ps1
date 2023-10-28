# Storyline: Review the Secuirty Enevnt Log

# Directory to save files:
$myDir = "C:\Users\champuser\Desktop\"

#List all the avaible Windows Event logs
Get-EventLog -list 

# Create a prompt to allow user to select the Log to view 
$readLog = Read-host -Prompt "Please select a lot to review from the list above"

# Prompt that allows user to specify a keyword or phrase to search on
$userPrompt = Read-host -Prompt "Please enter a keyword or phrase to search on within the log" 

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$userPrompt*"}| export-csv -NoTypeInformation `
-Path "$myDir\securityLogs.csv" 