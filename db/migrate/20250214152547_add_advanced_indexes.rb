class AddAdvancedIndexes < ActiveRecord::Migration[7.0]
  def change
    # Índices en columnas de fecha para búsquedas por trimestre y mes
    execute "CREATE INDEX idx_ingresos_mes ON ingresos (date_trunc('month', fecha));"
    execute "CREATE INDEX idx_gastos_mes ON gastos (date_trunc('month', fecha));"
    execute "CREATE INDEX idx_ingresos_trimestre ON ingresos (date_trunc('quarter', fecha));"
    execute "CREATE INDEX idx_gastos_trimestre ON gastos (date_trunc('quarter', fecha));"

    # Índice para identificar el área que más facturó en un período
    add_index :ingresos, [:fecha, :area], name: "idx_ingresos_fecha_area"

    # Índice para saber el cliente con más ingresos en el año
    add_index :ingresos, [:cliente_id, :fecha], name: "idx_ingresos_cliente_fecha"

    # Índices para retiros de utilidades por trimestre, semestre, año y comparación Montevideo vs. Mercedes
    add_index :retiros_utilidades, [:fecha, :sucursal], name: "idx_retiros_fecha_sucursal"

    # Índice para identificar el gasto más alto en un período
    execute "CREATE INDEX idx_gastos_max ON gastos (fecha DESC, monto DESC);"

    # Índices para rentabilidad por sucursal y área
    add_index :ingresos, [:sucursal, :fecha, :monto], name: "idx_ingresos_sucursal_fecha"
    add_index :gastos, [:sucursal, :fecha, :monto], name: "idx_gastos_sucursal_fecha"
    add_index :ingresos, [:sucursal, :area, :fecha], name: "idx_ingresos_sucursal_area_fecha"
  end
end
