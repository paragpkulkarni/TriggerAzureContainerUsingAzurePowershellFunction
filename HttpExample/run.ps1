using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

# Write to the Azure Functions log stream.
Write-Host "PowerShell HTTP trigger function processed a request."

# Interact with query parameters or the body of the request.
$name = $Request.Query.Name
if (-not $name) {
    $name = $Request.Body.Name
}

$body = "This HTTP triggered function executed successfully. Pass a name in the query string or in the request body for a personalized response."

$secpasswd = ConvertTo-SecureString "your secret password" -AsPlainText -Force
$mycred = New-Object System.Management.Automation.PSCredential ("YourusernameForAct", $secpasswd)

if ($name) {
    New-AzContainerGroup -ResourceGroupName "myResourceGroup" -Name $name -Image yourprivateacr.azurecr.io/your image name:latest -IpAddressType Public -RegistryCredential $mycred

    if ($?) {
        $body = "This HTTP triggered function executed successfully. Started container group $name"
    }
    else  {
        $body = "There was a problem starting the container group."
    }
}


# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = [HttpStatusCode]::OK
    Body = $body
})
