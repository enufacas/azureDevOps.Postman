# AzureDevOps.Postman

This project uses a Postman collection to pull Azure DevOps Build stats from the Rest API and send a summary Slack message about the last 24 hours of activity. It is all ultimately wrapped in an Azure DevOps pipeline, and the end result looks something like this.

![example slack message](exampleSlackMessage.png)

Additional context in the companion blog post here: <https://www.esmith.dev> not done yet

## tldr + Just want to try it

Azure Pipeline drives a
(Postman Collection -> Newman CLI -> Sending Slack Message with build stats)

If you want to see it in action against your collection.

1. Clone the repo and create a new pipline pointing it at the [azure-pipelines.yml](azure-pipelines.yml)
2. Create a variable to hold your slack token $(slackToken)
3. Update the slack channel name in the [SendSlackMessage.ps1](SendSlackMessage.ps1) script

## ldr + Some more detail

The Postman Collection and Environment file

- A single request is defined in the Postman collection to pull build stats from the Azure DevOps Rest API. Credit to [this repository containing an Azure DevOps Collection by hkamel](https://github.com/hkamel/azuredevops-postman-collections) for the base collection and starting environment config.
- I recommend opening the [postman_collection.json](AzureDevOps.Postman.postman_collection.json) and [postman_environment.json](AzureDevOpsEnvironment.postman_environment.json) files directly in postman if you want to look around a bit at the request and test definition.
- Within the request a *pre-request* script creates a date to use and places it in an environment variable
- Within the request I defined *Tests* which log to the postman console and compute the number of builds, passing builds, failings builds, and canceled builds over the last 24 hours.
- The Postman Collection and Environment file have been exported and generalized.

Okay now that we have the collection how do we run it?

- The [azure-pipelines.yml](azure-pipelines.yml) contains these tasks
  - `npm install newman` which downloads newman, a postman CLI tool.
  - The [RunNewmanCLI.ps1](RunNewmanCLI.ps1) script which executes the collection, passing environment varaible specific to your Azure DevOps collection and project.
  - The [SendSlackMessage.ps1](SendSlackMessage.ps1) script grabs the build stats from the cli.log output in the previous step, and then sends a slack message via a rest method call.
    - This step requires that you define a secret variable in your pipeline with a slack token.  

## The Postman visualize feature

The postman collection also contains an example of using the visualize (beta) feature, which you can see if you run the request within postman. You can check out how the chart is built in the *tests* tab of postman.
![example postman visualize feature](buildOutComeVisualized.png)
