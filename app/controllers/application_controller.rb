class ApplicationController < ActionController::Base
  def pong
    render plain: 'pong'
  end
end
