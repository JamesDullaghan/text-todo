require 'twilio-ruby/security/request_validator'

# Phone Number, Todos, Todo Item
class TextMessagesController < ActionController::API
  # skip_before_filter :verify_authenticity_token

  def create
    # Figure out what the incoming phone number is registered from twilio and check against the registered number
    if twilio_number_matches_incoming? && whitelisted_number_matches_incoming?
      begin
        service = ::SmsReceiverService.new(params: body)
        task_response_status, task_response = service.perform

        # Something wrong with the response
        if task_response_status.eql?(200)
          render json: {
            success: true,
            data: task_response,
          }, status: :ok
        else
          render json: {
            success: false,
            message: ::I18n.t('sms.error'),
          }, status: :unprocessable_entity
        end
      rescue StandardError => e
        Rails.logger.info(e)

        render json: {
          success: false,
          message: e.to_s,
        }, status: :unprocessable_entity
      end
    else
      render json: {
        success: false,
        message: ::I18n.t('sms.invalid_number'),
      }, status: :unprocessable_entity
    end
  end

  private

  # We need to find the current user through todo list name or some kind of variable
  def todo_lists
    @_todo_lists ||= current_user.todo_lists
  end

  def todo_list
    @_todo_list ||= if params[:list_name].present?
      todo_lists.find_by!(name: params[:list_name])
    else
      todo_lists.find_by!(name: Rails.application.secrets.todoist_list_name)
    end
  end

  def whitelisted_number_matches_incoming?
    return false unless from.present?
    return false unless whitelisted_from_numbers.present?

    whitelisted_from_numbers.inclue?(from)
  end

  def twilio_number_matches_incoming?
    twilio_phone_number = Rails.application.secrets.twilio_phone_number.to_s

    return false unless twilio_phone_number.present?

    to.eql?(twilio_phone_number)
  end

  def request_body
    @_request_body ||= request.body.read
  end

  def body
    @_body ||= CGI::parse(request_body).deep_transform_keys! do |key|
      key.underscore.to_sym
    end.with_indifferent_access
  end

  def to
    @_to ||= body['to']&.first&.gsub('+', '').to_s
  end

  def from
    @_from ||= body['from']&.first&.gsub('+', '').to_s
  end

  def twilio_signature
    request.headers['HTTP_X_TWILIO_SIGNATURE']
  end

  # def validate(url, params, signature)
  # Validate the twilio request using the twilio-ruby integration
  def validate_request
    validator = ::Twilio::Security::RequestValidator.new(
      auth_token: Rails.application.secrets.twilio_auth_token,
    )

    @_validate_request ||= validator.validate(
      request.url,
      request_body,
      twilio_signature,
    )
  end
end