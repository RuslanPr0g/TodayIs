$outputFile = "git_commits_log.txt"

$commits = git log --reverse --pretty=format:"%ad | %an | %h | %s" --date=short

$commits | Out-File -FilePath $outputFile -Encoding UTF8

Write-Host "Commit log saved to $outputFile"
