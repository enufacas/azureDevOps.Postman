$organization = ($env:SYSTEM_TEAMFOUNDATIONCOLLECTIONURI -replace "https://dev\.azure\.com/(.*)/", '$1').split('.')[0]

newman run AzureDevOps.Postman.postman_collection.json -e AzureDevOpsEnvironment.postman_environment.json --env-var "AccessToken=$env:SYSTEM_ACCESSTOKEN" --env-var "organization=$organization" --env-var "project=$env:System_TeamProject" -r cli --reporter-cli-no-summary --reporter-cli-no-success-assertions >cli.log
