class RegistrationsController < ApplicationController
  def new
    # Renderiza la vista new.html.erb para el formulario de registro
  end

  def create
    # Se asigna por defecto el rol 'colaborador'
    user = Usuario.new(user_params.merge(rol: "colaborador"))
    if user.save
      # Se establece la sesión con el ID del usuario
      session[:user_id] = user.id
      render json: { message: 'Usuario registrado exitosamente', user: user }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:nombre, :email, :password, :password_confirmation)
  end
end
