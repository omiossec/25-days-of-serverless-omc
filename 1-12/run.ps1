using namespace System.Net

param($Request, $TriggerMetadata)

try {

    $dreidel = @(
        @{
            "Name"= "Nun"
            "char" = "נ"
        }
        @{
            "Name"= "Gimmel"
            "char" = "ג"
        }
        @{
            "Name"= "Hay"
            "char" = "ה"
        }
        @{
            "Name"= "Shin"
            "char" = "ש"
        }
    )
    
    $spinRun = Get-Random -Maximum $dreidel.Length -Minimum 0
    $HttpResponse = [HttpResponseContext]@{ 
        StatusCode = [HttpStatusCode]::OK
        Body = $dreidel[$spinRun] | ConvertTo-Json
        ContentType = "Application/json" 
       }       
}
catch {
    $HttpResponse = [HttpResponseContext]@{ 
        StatusCode = [HttpStatusCode]::BadRequest
        Body = "Error while processing the request"
       } 
}
finally {
    Push-OutputBinding -Name Response -Value $HttpResponse 
}