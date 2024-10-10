# Function to display the welcome message
function Show-WelcomeMessage {
    Clear-Host
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "             Network Adapter Renamer by Pureinfotech                    " -ForegroundColor Yellow
    Write-Host " Full guide https://pureinfotech.com/rename-network-adapter-windows-11  " -ForegroundColor Yellow
    Write-Host " Website https://pureinfotech.com                                       "-ForegroundColor Yellow
    Write-Host "========================================================================" -ForegroundColor Cyan
    Write-Host "`nThis script allows you to view and rename your network adapters."
    Write-Host "Please follow the instructions carefully." -ForegroundColor Cyan
    Write-Host "You can exit the script at any time by selecting the exit option."
    Write-Host "Warning: This tool is offered as-is without any guarantee." -ForegroundColor Red
    Write-Host "Use it at your own risk." -ForegroundColor Red
    Write-Host "--------------------------------------------------`n" -ForegroundColor Cyan
}

# Function to display the list of network adapters on Windows
function Show-NetworkAdapters {
    Write-Host "Available Network Adapters:" -ForegroundColor Cyan
    $adapters = Get-NetAdapter | Select-Object -Property Name, Status
    for ($i = 0; $i -lt $adapters.Count; $i++) {
        $adapter = $adapters[$i]
        Write-Host "$($i + 1). $($adapter.Name) (Status: $($adapter.Status))"
    }
    Write-Host "$($adapters.Count + 1). Exit" -ForegroundColor Red
    return $adapters
}

# Function to rename network adapter on Windows
function Rename-NetworkAdapter {
    # Display the list of network adapters
    $adapters = Show-NetworkAdapters

    # Ask the user to choose an adapter or exit
    $adapterIndex = Read-Host "Enter the number of the network adapter to rename or type $($adapters.Count + 1) to exit"
    $adapterIndex = [int]$adapterIndex - 1

    # Check if the user wants to exit the tool
    if ($adapterIndex -eq $adapters.Count) {
        Write-Host "Exiting script. Goodbye!" -ForegroundColor Green
        exit
    }

    # Check if the chosen index is valid
    if ($adapterIndex -ge 0 -and $adapterIndex -lt $adapters.Count) {
        $selectedAdapter = $adapters[$adapterIndex].Name
        Write-Host "You selected: $selectedAdapter" -ForegroundColor Green

        # Ask the user for the new name for the adapter
        $newName = Read-Host "Enter the new name for the adapter"

        # Rename the network adapter
        Rename-NetAdapter -Name $selectedAdapter -NewName $newName

        # Clear the screen to remove the clutter
        Clear-Host

        # Notify the user that the adapter has been renamed
        Write-Host "Network adapter '$selectedAdapter' has been renamed to '$newName' successfully." -ForegroundColor Yellow

        # Fetch the updated list of network adapters adapters
        $updatedAdapters = Get-NetAdapter | Select-Object -Property Name, Status

        # Display the updated list, highlighting the renamed adapter
        Write-Host "`nUpdated Network Adapters:" -ForegroundColor Cyan
        for ($i = 0; $i -lt $updatedAdapters.Count; $i++) {
            $adapter = $updatedAdapters[$i]
            if ($adapter.Name -eq $newName) {
                Write-Host "$($i + 1). $($adapter.Name) (Status: $($adapter.Status))" -ForegroundColor Green
            } else {
                Write-Host "$($i + 1). $($adapter.Name) (Status: $($adapter.Status))"
            }
        }

        # Ask if the user wants to rename another network adapter
        $rerun = Read-Host "`nWould you like to rename another adapter? (Y/N)"
        if ($rerun -eq 'Y' -or $rerun -eq 'y') {
            Rename-NetworkAdapter  # Rerun the script
        } else {
            Write-Host "Exiting script. Goodbye!" -ForegroundColor Green
            exit
        }
    } else {
        Write-Host "Invalid selection. Exiting script." -ForegroundColor Red
        exit
    }
}

# Main execution for the script
Show-WelcomeMessage
Rename-NetworkAdapter
