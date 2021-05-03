class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    render 'index', locals: {
      todo_lists: todo_lists,
    }
  end

  private

  def todo_lists
    @_todo_lists ||= current_user.todo_lists
  end
end