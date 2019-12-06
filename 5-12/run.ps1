using namespace System.Net

param($Request, $TriggerMetadata)

$SantaLetter = $Request.Body 

if ($null -ne $SantaLetter.ChildName -AND $null -ne $SantaLetter.Message ) {


        $headers = @{"Ocp-Apim-Subscription-Key" = $ENV:textapikey}

        $sentiment_url = $ENV:textapiurl + "/text/analytics/v2.1/sentiment"
        $language_api_url = $ENV:textapiurl + "/text/analytics/v2.1/languages"

    
        try {
            $dataLanguage = @{"documents"= @( @{"id"="1"; "text"=$SantaLetter.message}) } | convertTo-Json
            
            $languageResponse = Invoke-RestMethod -Method post -ContentType "application/json" -Headers $headers -uri $language_api_url -Body  $dataLanguage
        }
        catch {
            Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                StatusCode = [HttpStatusCode]::BadRequest
                Body = "Language detection fail" })
        }
        
        if ($null -ne $languageResponse.documents.detectedLanguages.iso6391Name) {
            $dataSentiment = @{"documents"= @( @{"id"="1"; "language"= $languageResponse.documents.detectedLanguages.iso6391Name;"text"=$SantaLetter.message}) } | convertto-Json
        
            try {
                $SentimentResponse = Invoke-RestMethod -Method post -ContentType "application/json" -Headers $headers -uri $sentiment_url -Body  $dataSentiment
                

                $SentimentAnalysResult = [math]::Round($SentimentResponse.documents.score * 100, 1)

                if ($SentimentAnalysResult -gt 50) {
                    $ChildResult = "Good"
                } else {
                    $ChildResult = "Bad"
                }
        
                $status = [HttpStatusCode]::OK
                $body = "Child $($SantaLetter.ChildName) result $($ChildResult) $($SentimentAnalysResult)"


            }
            catch {
                Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
                    StatusCode = [HttpStatusCode]::BadRequest
                    Body = "Sentiment detection fail" })
            }
        }
        

         

        #$SentimentResponse = 
        
        
 
} else {

    $status = [HttpStatusCode]::BadRequest
    $body = "No Message or Childname"
}




# Associate values to output bindings by calling 'Push-OutputBinding'.
Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
    StatusCode = $status
    Body = $body
})
