using namespace System.Net

param($Request, $TriggerMetadata)

Try {
    $GitHubAction = $Request.Body

    if ($GitHubAction.repository.id -eq "225537685") {

        $CommitAuthor = $GitHubAction.head_commit.author.name

        $PetDataArray = @()

        foreach ($file in $GitHubAction.head_commit.added) {
            $PetData = @{ 
                "FileName" = $file
                "partitionKey" = "secretsantapetphotos"
                "sendername" = $CommitAuthor
                "PhotoAdded"= Get-Date
                "rowKey" = (new-guid).guid 
            }
            $PetDataArray += $PetData
        }
        Push-OutputBinding -Name secretsantapets -Value $PetDataArray
        $HttpResponse = [HttpResponseContext]@{ 
            StatusCode = [HttpStatusCode]::OK
            Body = "Pet Added"
           }   

    }
    else {
        $HttpResponse = [HttpResponseContext]@{ 
            StatusCode = [HttpStatusCode]::BadRequest
            Body = "Repository not valid"
        }
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

