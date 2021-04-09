require 'uri'
require 'net/http'

class SmsReceiverService
  attr_reader :params,
              :data,
              :message

  def initialize(params:)
    @params = params
    @data = CGI::parse(params).deep_transform_keys! { |key| key.underscore.to_sym }
    @message = data.fetch(:body, nil).fetch(0, nil)
  end

  # Twilio Returns A String Io
  # Check If Phone Number Matches My Phone Number Before Sending Message Through To Twilio
  # Receive Data In And Parse The Data Looking For The Message Content
  def perform
    raise StandardError, 'Message is empty' if message.blank?
    # Message comes in
    #
    # We want to connect to Todoist API
    raise StandardError, 'No project' if project_id.nil?

    [task_response_status, parsed_task_response]
  end

  private

  def todoist_base_url
    @_base_url ||= ::TODOIST_BASE_URL
  end

  def todoist_list_name
    @_todoist_list_name ||= Rails.application.secrets.todoist_list_name

  end

  def projects_url
    @_projects_url ||= URI("#{todoist_base_url}/projects")
  end

  def tasks_url
    @_tasks_url ||= URI("#{todoist_base_url}/tasks")
  end

  def auth_token
    @_auth_token ||= Rails.application.secrets.todoist_auth_token
  end

  def bearer_token
    @_bearer_token ||= "Bearer #{auth_token}"
  end

  def projects_request
    request = Net::HTTP::Get.new(projects_url)
    request["Authorization"] = bearer_token
    @_projects_request ||= request
  end

  def projects_response
    https = Net::HTTP.new(projects_url.host, projects_url.port)
    https.use_ssl = true
    @_projects_response ||= https.request(projects_request)
  end

  def projects_data
    @_projects_data ||= JSON.parse(projects_response.body, quirks_mode: true)
  end

  def project
    # Find the project by the name
    @_project ||= projects_data.select do |el|
      el['name'].eql?(todoist_list_name)
    end
  end

  # Create a task under the project using the project ID and the message
  def project_id
    @_project_id ||= project.first.fetch('id', nil)
  end

  def task_request
    task_request = Net::HTTP::Post.new(tasks_url)
    task_request["Content-Type"] = "application/json"
    task_request["Authorization"] = bearer_token
    task_request.body = { content: message, project_id: project_id }.to_json
    @_task_request ||= task_request
  end

  def task_response
    https = Net::HTTP.new(tasks_url.host, tasks_url.port)
    https.use_ssl = true
    @_task_response ||= https.request(task_request)
  end

  def parsed_task_response
    @_parsed_task_response ||= JSON.parse(task_response.body, quirks_mode: true)
  end

  def task_response_status
    @_task_response_status ||= task_response.code.to_i
  end
end