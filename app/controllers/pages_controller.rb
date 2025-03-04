class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  
  def home
    if current_user
      redirect_to dashboard_path
    else
      # Renderiza la vista de bienvenida con botones de login/registro
      render :home
    end
  end
  
  def tablero
    authenticate_user!
    render :tablero
  end
end
