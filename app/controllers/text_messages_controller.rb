# Phone Number, Todos, Todo Item
class TextMessagesController < ActionController::API
  def create
    begin
      url_params = request.body.read

      service = ::SmsReceiverService.new(params: url_params)
      task_response_status, task_response = service.perform

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
      }, status: :unprocessable_entity
    end
  end
end