class Todoist < ApplicationRecord
  belongs_to :todo_list

  validates :auth_token, :list_name, presence: true
end