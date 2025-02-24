class Usuario < ApplicationRecord
  # Habilita la autenticación segura (requiere password_digest)
  has_secure_password

  # Configura el enum para los roles usando strings
  enum :rol, { colaborador: "colaborador", socio: "socio", admin: "admin" }
  # Alias opcional para usar 'role' en lugar de 'rol'
  alias_attribute :role, :rol

  # Validaciones
  validates :nombre, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  # Callbacks
  before_save :downcase_email

  # Sobrescribir método rol= para lanzar ArgumentError cuando se asigna un rol inválido
  def rol=(value)
    if value.nil? || Usuario.rols.keys.include?(value.to_s)
      super
    else
      raise ArgumentError, "#{value} no es un rol válido"
    end
  end

  # Método de autenticación delegado en el modelo
  def self.authenticate(email, password)
    user = find_by(email: email.to_s.downcase)
    user if user && user.authenticate(password)
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
