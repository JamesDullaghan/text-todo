require 'twilio-ruby'

class VoiceMessagesController < ActionController::API
  def create
    binding.pry

    twiml = Twilio::TwiML::MessagingResponse.new do |r|
      r.message(body: 'Ahoy! Thanks so much for your message.')
    end
  end
end