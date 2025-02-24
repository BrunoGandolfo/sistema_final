class ApplicationController < ActionController::Base
  helper_method :current_user

  private

  def current_user
    @current_user ||= Usuario.find_by(id: session[:user_id])
  end
end
