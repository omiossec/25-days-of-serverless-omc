using namespace System.Net

param($Request, $TriggerMetadata)

Try {
    $Dish = $Request.Body
    if ($null -ne $dish.Name -AND $null -ne $Dish.DishName) {
         
        $RowKey = (new-guid).guid 
                $DishData = @{ 
                    "FriendName" = $dish.Name
                    "partitionKey" = "dishforparty"
                    "dish" = $dish.DishName
                    "rowKey" = $RowKey
                }
           

        
            Push-OutputBinding -Name foodlist -Value $DishData
      
        $body = "Dish added, key $($RowKey)"

        $HttpResponse = [HttpResponseContext]@{ 
            StatusCode = [HttpStatusCode]::OK
            Body = $body | convertto-Json
           }   
    }
    else {
        $HttpResponse = [HttpResponseContext]@{ 
            StatusCode = [HttpStatusCode]::BadRequest
            Body = "You need to provide a name and/or a dish"
        }
    }
}
catch {
    $HttpResponse = [HttpResponseContext]@{ 
        StatusCode = [HttpStatusCode]::InternalServerError
        Body = "Error while processing the request"
       } 
}
finally {
    Push-OutputBinding -Name Response -Value $HttpResponse 
}

