$summaryObject = Get-Content -Raw -Path 'Azure-DevOps-Json.json' | ConvertFrom-Json

$total = $summaryObject.environment.values | Where-Object { $_.key -eq "totalEnv" } | Select-Object -ExpandProperty value
$succeeded = $summaryObject.environment.values | Where-Object { $_.key -eq "succeededEnv" } | Select-Object -ExpandProperty value
$failed = $summaryObject.environment.values | Where-Object { $_.key -eq "failedEnv" } | Select-Object -ExpandProperty value
$canceled = $summaryObject.environment.values | Where-Object { $_.key -eq "canceledEnv" } | Select-Object -ExpandProperty value
$minTime = $summaryObject.environment.values | Where-Object { $_.key -eq "minTime" } | Select-Object -ExpandProperty value

$message = "There were ``$total`` builds since ``$minTime``. ---> ``$succeeded`` succeeded, ``$failed`` failed, and ``$canceled`` were canceled."

#We will marshal the message to a variable and use it elsewhere
Write-Host "##vso[task.setvariable variable=SlackMessage;]$message" 

#If you prefer you could just send the plain slack message from the context of this script
# $postSlackMessage = @{token=$env:SLACK_TOKEN;channel="@user,#channel-name";text=$message;username="HAL";icon_url="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/HAL9000.svg/256px-HAL9000.svg.png"}
# Invoke-RestMethod -Uri https://slack.com/api/chat.postMessage -Body $postSlackMessage
