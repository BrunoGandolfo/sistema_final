class PaginasController < ApplicationController
  # Saltamos la autenticación para las páginas públicas (bienvenida y tablero)
  skip_before_action :authenticate_user!, only: [:bienvenida, :tablero, :home]

  def bienvenida
    render :bienvenida
  end

  def tablero
    render :tablero
  end

  def home
    render :home
  end
end
