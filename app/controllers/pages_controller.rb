class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]
  
  def home
    if current_user
      redirect_to dashboard_path
    else
      # Renderizar la vista home en lugar de redireccionar
      render :home
    end
  end
  
  def tablero
    authenticate_user!
    render :tablero
  end
end
