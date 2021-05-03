email = 'admin@knucks.io'
password = 'password'
todoist_list_name = Rails.application.secrets.todoist_list_name
todoist_auth_token = Rails.application.secrets.todoist_auth_token

user = User.find_or_create_by!(email: email) do |record|
  record.password = password
  record.password_confirmation = password
end

todo_list = user.todo_lists.find_or_create_by!(name: todoist_list_name)

todoist = todo_list.find_or_create_by!(auth_token: todoist_auth_token) do |record|
  record.list_name = todoist_list_name
end

"User: #{user.email} : Todo List : #{todo_list.name} : Todoist : #{todoist.list_name}"