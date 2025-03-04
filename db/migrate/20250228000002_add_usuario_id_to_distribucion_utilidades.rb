class AddUsuarioIdToDistribucionUtilidades < ActiveRecord::Migration[7.0]
  def change
    add_reference :distribuciones_utilidades, :usuario, null: false, foreign_key: true
  end
end
