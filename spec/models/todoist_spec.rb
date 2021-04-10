require 'rails_helper'

describe Todoist, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:auth_token) }
  it { is_expected.to validate_presence_of(:list_name) }
end