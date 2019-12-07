using namespace System.Net

param($Request, $TriggerMetadata)

$headers = @{"Authorization" = "Client-ID $($ENV:unsplashkey)"}

$Query = $Request.Query.Name

try {

    if ($null -ne $Query) {

        $EncodedQuery = [System.Web.HttpUtility]::UrlEncode($Query)
        $imagesResult = Invoke-RestMethod -Method Get -Uri "https://api.unsplash.com/search/photos?page=1&query=$($EncodedQuery)" -Headers $headers
    
    
        $RandomImage = get-random -Maximum $imagesResult.results.Count -Minimum 0 
        $ImageData = Invoke-WebRequest -Method Get -Uri $imagesResult.results[$RandomImage].Urls.full
    
        $HttpResponse = [HttpResponseContext]@{ 
        StatusCode = [HttpStatusCode]::OK
        Body = $ImageData.Content
        ContentType = $ImageData.Headers["Content-type"] 
       }   
    
        
    }
    else {
        $HttpResponse = [HttpResponseContext]@{ 
            $status = [HttpStatusCode]::BadRequest
            $body = "Please pass a name on the query string or in the request body."
        } 
    }

} catch {
    $HttpResponse = [HttpResponseContext]@{ 
        $status = [HttpStatusCode]::InternalServerError
        $body = "Error while processing the request"
    }
}
finally {
    Push-OutputBinding -Name Response -Value $HttpResponse
}









   