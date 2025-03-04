# app/controllers/sessions_controller.rb

class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:new, :create]

  def new
    redirect_to dashboard_path if current_user
  end

  def create
    user = Usuario.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id

      if api_request?
        json_success('Inicio de sesión exitoso', {
          user: user.as_json(except: [:password_digest]),
          redirect_to: dashboard_path
        })
      else
        redirect_to dashboard_path, notice: 'Inicio de sesión exitoso.'
      end
    else
      if api_request?
        json_error('Email o contraseña inválidos', ['Email o contraseña inválidos'], :unauthorized)
      else
        redirect_to new_user_session_path, alert: 'Email o contraseña inválidos.'
      end
    end
  end

  def destroy
    session[:user_id] = nil

    if api_request?
      json_success('Sesión cerrada')
    else
      redirect_to root_path, notice: 'Sesión cerrada.'
    end
  end
end
