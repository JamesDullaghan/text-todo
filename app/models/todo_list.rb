# application goes text -> many different todo lists
class TodoList < ApplicationRecord
  belongs_to :user

  has_one :todoist, dependent: :destroy
  has_many :items, dependent: :destroy

  # todoist_list_name, todoist_auth_token
  delegate :list_name, :auth_token, to: :todoist, prefix: true, allow_nil: false

  # Display name of the todo list
  validates :title, presence: true
end