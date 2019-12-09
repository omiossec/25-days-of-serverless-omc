# CHALLENGE 9, AUTOMATE YOUR GITHUB ISSUES

## Github Action

This challenge can be resolved with GitHub Action

```yaml
name: issue-auto

on: [issues]

jobs:
  displaymsg:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/first-interaction@v1
      with:
        repo-token: ${{ secrets.GITHUB_TOKEN }}
        issue-message: '<Your Message>'
```

## PowerShell Core in Azure Function

Or an Azure Function With PowerShell Core
For that you need 
A personal token for the GitHub API

To use the GitHub Api (https://api.github.com) you will need to sent your token via HTTP Headers. Bus, as we need to deal with Issues we have some trouble with date time. There is an HTTP header to deal with that.
Also, Github will reject any request without a user-agent header

```powershell
    $HttpHeaders = @{
            "Authorization" = "token $($ENV:GitHubPersonalToken)"
            "Europe/Paris"  = "Europe/Paris"
            "User-Agent"    = "MyApplication"
            }
```

to reply to an issue you need to post a json to  POST /repos/<GitHubAccount>/<ReposName>/issues/<IssueID>/comments

```json
{
  "body": "Me too"
}
```

on the webhook you need to check that the action, the state, the issue.title, and the user.login to build the message

