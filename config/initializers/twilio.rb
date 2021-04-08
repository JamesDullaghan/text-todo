require 'twilio-ruby'

# put your own credentials here
account_sid = Rails.application.secrets.twilio_account_sid
auth_token = Rails.application.secrets.twilio_auth_token

# Set up a client to talk to the Twilio REST API
::CLIENT = Twilio::REST::Client.new account_sid, auth_token