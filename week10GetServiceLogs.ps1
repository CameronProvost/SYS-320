# Storyline: View the event logs, check for valid log, and print the results

function get_services() { 
    cls

    # grab running services & create an array
    $runningServices = Get-Service | Where { $_.Status -eq "running" }
    $arrRunning = @()

    # Array for running services
    foreach ($tempRunning in $runningServices) {
        $arrRunning += $tempRunning
    }




    # grab stopped services & create an array
    $stoppedServices = Get-Service | Where { $_.Status -eq "stopped" }
    $arrStopped = @()

    # Array for stopped services
    foreach ($tempStopped in $stoppedServices) {
        $arrStopped += $tempStopped
 
    }

    # Prompt for the user choose which prossess to view:
    $readServices = Read-Host -Prompt "Do you want view all, running, or stopped services? Or 'q' to quit."

    # Checks if the user wants to quit:
    if ($readServices -match "^[qQ]$") {
        break
    
    # ouputs the running services
    } elseif ($readServices -match "^running$") {
        write-host -BackgroundColor Green -ForegroundColor white "Please wait. It might take a few moments to retrieve running services."
        sleep 2

    $arrRunning | Out-Host

    Read-Host -Prompt "Press enter when done."
    get_services

    # ouputs the stopped services
    } elseif ($readServices -match "^stopped$") {
        write-host -BackgroundColor Green -ForegroundColor white "Please wait. It might take a few moments to retrieve stopped services."
        sleep 2
    
    $arrStopped | Out-Host

    Read-Host -Prompt "Press enter when done."
    get_services

    # ouputs all services
    } elseif ($readServices -match "^all$") {
        write-Host -BackgroundColor Green -ForegroundColor White "Please wait. It might take a few moments to retrieve all services."
        sleep 2

        $arrRunning | Out-Host
        $arrStopped | Out-Host

      Read-Host -Prompt "Press enter when done."
      get_services

    } else {

    Write-Host -BackgroundColor Red -ForegroundColor White " Invalid option. Try again."
    sleep 2

    get_services

    }
} # End of get_services()


get_services



#Below is the code from the example video using event logs

<#
# Storyline : View the event logs, check for valid log, and print the results

function select_log() {
    
    cls

    # List all event logs
    $theLogs = Get-EventLog -list  | select Log
    $theLogs | Out-Host

    # Initialize the arry to store the logs
    $arrLog =@()

    foreach ($tempLog in $theLogs) {

        # Add each log to the array
        # NOTE: these are stored in the array as a hashtable in the format:
        # @[Log=LOGNAME]
        $arrLog += $tmpLog 

    }
    # Test to be sure array is being populated
    #$arrLog

    # Prompt the user for the log to view or quit.
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"

    # Check if the user wants to quit
    if ($readLog -match "^[qQ]$") {
    #Stop executing and close the script
    break

    }

    log_check -logToSearch $readLog

}


function log_check() {

    # String the user types in within the select_log function
    Param([string]$logToSearch)
    # Formate the user input.
    # Example: @{Log=Security}
    $theLog = "^@{Log=" + $logToSearch + "}$"

    # Search the array for the exact hashtable string
    if ($arryLog -match $theLog){
        
        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retreive the log entries."
        sleep 2
        # Call the function to view the log.
        view_log -logToSearch $logToSearch


    } else {  
        
        write-host -BackgroundColor red -ForegroundColor white "The log specified doesn't exist."
        sleep 2
        select_log
        
        }


}



function view_log() {

    cls
    

    # Get the logs
    Get-EventLog -Log $logToSearch -Newest 10 -after "11/27/2023"

    # Pause the screen and wait until the user is ready to procceed.
    read-host -Prompt "Press enter when you are done"

    # Go back to select_log 
    select_log




}

# Run the select_log as the first function
select_log
#>