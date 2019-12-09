using namespace System.Net

param($Request, $TriggerMetadata)


$BaseAPIUri = "https://api.github.com"

$HttpHeaders = @{
    "Authorization" = "token $($ENV:GitHubPersonalToken)"
    "Time-Zone"  = "Europe/Paris"
    }

    $GitHubAction = $Request.Body

try {
    if ($GitHubAction.repository.id -eq $env:ReposID -AND $GitHubAction.action -eq "opened") {

        $CommentText = @{ "body" = "Thanks You `@$($GitHubAction.issue.user.login) for creating this issue `n`n  Have a Happy Holiday season !" } | convertTo-Json

        $CommentIssueAPIUri = $BaseAPIUri + "/repos/$($ENV:GitHubAccount)/$($ENV:ReposName)/issues/$($GitHubAction.issue.number)/comments"
        

        Invoke-RestMethod -Uri $CommentIssueAPIUri -Method Post -Headers $HttpHeaders -UserAgent $ENV:GitHubAccount -body $CommentText -ContentType "application/json" 
        

        $HttpResponse = [HttpResponseContext]@{ 
            StatusCode = [HttpStatusCode]::OK
            Body = "Comment Added"
           }   


    }
    else {
        $HttpResponse = [HttpResponseContext]@{ 
            StatusCode = [HttpStatusCode]::BadRequest
            Body = "Repository not valid"
        }
    }

}
Catch {
    $HttpResponse = [HttpResponseContext]@{ 
        StatusCode = [HttpStatusCode]::InternalServerError
        Body = "Error while processing the request"
       } 
}
finally {
    Push-OutputBinding -Name Response -Value $HttpResponse 
}




    
