using namespace System.Net

# Input bindings are passed in via param block.
param($Request, $TriggerMetadata)

try {

    $Dish = $Request.Body

    if ($null -ne $dish.key -AND $null -ne $Dish.DishName) {

        $FunctionStorageConfigHash = ConvertFrom-StringData -StringData $ENV:AzureWebJobsStorage.Replace(";","`r`n")

        $ctx = New-AzStorageContext -StorageAccountName $FunctionStorageConfigHash.AccountName -StorageAccountKey $FunctionStorageConfigHash.AccountKey
    
        $cloudTable = (Get-AzStorageTable -Name "foodlist" -Context $ctx).CloudTable    
    
        $data = Get-AzTableRow -table $cloudTable -PartitionKey dishforparty -RowKey $Dish.key

        $data.dish = $Dish.DishName

        $data | Remove-AzTableRow -Table $cloudTable | Out-Null
    
            $HttpResponse = [HttpResponseContext]@{ 
                StatusCode = [HttpStatusCode]::OK
                Body = "Ok"
               }   
    }

   
}
catch {

        $HttpResponse = [HttpResponseContext]@{ 
        StatusCode = [HttpStatusCode]::InternalServerError
        Body = "Error while processing the request"
       } 
       Write-Error -Message " Exception Type: $($_.Exception.GetType().FullName) $($_.Exception.Message)"
}
finally {
    Push-OutputBinding -Name Response -Value $HttpResponse 
}

