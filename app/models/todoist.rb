class Todoist < ApplicationRecord
  belongs_to :user

  validates :auth_token, :list_name, presence: true
end