foreach($line in (Get-Content cli.log)) {
    if ($line.Contains("│")) {
        $stat = $line -replace "│" -replace "'" -replace '\s+', ''
        $a = $stat.Split("=")
        write-output $a
        New-Variable -Name $a[0] -Value $a[1]
    }elseif ($line.Contains("GET")){
        $url = $line -replace 'GET', '' -replace '\s+', '' -replace '\[.*\]', ''
    }
}
#Write-Output "There were $total builds over the last 24 hours. $passing passing, $failing failing, and $canceled canceled. To see the API call <$url|click here>"
$message = "There were ``$total`` builds over the last 24 hours. ``$passing`` passing, ``$failing`` failing, and ``$canceled`` canceled. To see the API call <$url|click here>"

#If you prefer can marshal the message to a variable and use it elsewhere
#Write-Host "##vso[task.setvariable variable=SlackMessage;]$message" 

$postSlackMessage = @{token=$env:SLACK_TOKEN;channel="#channel-name";text=$message;username="HAL";icon_url="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/HAL9000.svg/256px-HAL9000.svg.png"}
Invoke-RestMethod -Uri https://slack.com/api/chat.postMessage -Body $postSlackMessage