class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    # Renderiza la vista new.html.erb (login)
  end

  def create
    user = Usuario.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      render json: { message: "Inicio de sesión exitoso", user: user }, status: :ok
    else
      render json: { error: "Email o contraseña inválidos" }, status: :unauthorized
    end
  end

  def destroy
    session.delete(:user_id)
    render json: { message: "Sesión cerrada" }, status: :ok
  end
end
