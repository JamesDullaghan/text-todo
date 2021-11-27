# Text Message TODO with Twilio and Todoist

This is some mock code thrown together in an hour or so to be able to create tasks from SMS message

### Setup

* You will need ngrok setup to test
* You will need to set some environment variables
* You will need an account with Todoist

```zsh
export TODOIST_AUTH_TOKEN="Token From Todoist Web Ui"
export TODOIST_LIST_NAME="The list name of the list you wish to use"
```

### Work

1. Log into [twilio](twilio.com) and go to the Numbers page in the Console.
2. Click on your SMS-enabled phone number or purchase a number.
3. Find the Messaging section. The default `CONFIGURE WITH` is what you’ll need: `Webhooks/Twiml.`
4. In the `A MESSAGE COMES IN` section, select `Webhook` and paste in the URL you want to use `/text_messages`. Set the HTTP verb to POST. Save your number settings.
5. In the number section of the application contains the apps you can connect to (Twiml and otherwise) and set the apps to the following (based on what you named the Twiml app)
6. In production, switch the urls in Twilio to use the url of the production server instead of the ngrok url

There may be more things, figure it out and send a PR to fix the readme!
