require 'uri'
require 'net/http'
require 'twilio-ruby'

class TextMessagesController < ActionController::API
  # Phone Number, Todos, Todo Item
  def create
    begin

      # twilio returns a string io
      url_params = request.body.read
      data = CGI::parse(url_params).deep_transform_keys! { |key| key.underscore.to_sym }

      # Check If Phone Number Matches My Phone Number Before Sending Message Through To Twilio
      # Receive Data In And Parse The Data Looking For The Message Content
      message = data.fetch(:body, nil).fetch(0, nil)
      raise StandardError, 'Message is empty' if message.blank?

      # Message comes in
      #
      # We want to connect to Todoist API
      base_url = "https://api.todoist.com/rest/v1"
      projects_url = URI("#{base_url}/projects")

      https = Net::HTTP.new(projects_url.host, projects_url.port)
      https.use_ssl = true

      request = Net::HTTP::Get.new(projects_url)
      auth_token = Rails.application.secrets.todoist_auth_token
      bearer_token = "Bearer #{auth_token}"

      request["Authorization"] = bearer_token

      response = https.request(request)
      projects_data = JSON.parse(response.read_body)

      # Find the project by the name
      project_data = projects_data.select do |el|
        el['name'].eql?(Rails.application.secrets.todoist_list_name)
      end

      # Create a task under the project using the project ID and the message
      project_id = project_data.first.fetch('id', nil)

      raise StandardError, 'No project' if project_id.nil?

      tasks_url = URI("#{base_url}/tasks")

      https = Net::HTTP.new(tasks_url.host, tasks_url.port)
      https.use_ssl = true

      request = Net::HTTP::Post.new(tasks_url)
      request["Content-Type"] = "application/json"
      request["Authorization"] = bearer_token
      request.body = { content: message, project_id: project_id }.to_json

      response = https.request(request)
      response_status = response.code.to_i

      if response_status.eql?(200)
        task_data = JSON.parse(response.read_body)

        render json: { success: true }, status: :ok
      else
        render json: {
          success: false,
          message: 'Task not created. Something blue up',
        }, status: :unprocessable_entity
      end
    rescue StandardError => e
      Rails.logger.info(e)
      render json: { success: false }, status: :unprocessable_entity
    end
  end
end