class UnifyTipoCambioReferences < ActiveRecord::Migration[7.0]
  def change
    # Para retiros_utilidades: reemplazar el campo decimal por una referencia
    remove_column :retiros_utilidades, :tipo_cambio, :decimal, precision: 10, scale: 2
    add_reference :retiros_utilidades, :tipo_cambio, null: false, foreign_key: true

    # Para distribuciones_utilidades: reemplazar el campo decimal por una referencia
    remove_column :distribuciones_utilidades, :tipo_cambio, :decimal, precision: 10, scale: 2
    add_reference :distribuciones_utilidades, :tipo_cambio, null: false, foreign_key: true
  end
end
