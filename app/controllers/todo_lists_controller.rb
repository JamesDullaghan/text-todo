class TodoListsController < DashboardController
  def create
    if params[:title].present?
      todo_lists.find_or_create_by!(title: params[:title])
    else
      flash[:error] = ::I18n.t('todo_list.create.error')

      render controller: 'dashboard', action: 'index'
    end
  end

  private

  def todo_lists
    @_todo_lists ||= current_user.todo_lists
  end

  def permitted_params
    params.permit(:title)
  end
end