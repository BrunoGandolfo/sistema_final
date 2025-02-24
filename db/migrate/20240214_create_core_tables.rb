class CreateCoreTables < ActiveRecord::Migration[7.0]
  def change
    create_table :usuarios do |t|
      t.string :nombre, null: false
      t.string :email, null: false, unique: true
      t.string :rol, null: false, limit: 20, check: "rol IN ('admin', 'socio', 'colaborador')"
      t.boolean :activo, default: true
      t.datetime :ultimo_acceso

      t.timestamps
    end

    create_table :clientes do |t|
      t.string :nombre, null: false

      t.timestamps
    end

    create_table :proveedores do |t|
      t.string :nombre, null: false

      t.timestamps
    end

    create_table :tipos_cambio do |t|
      t.string :moneda, null: false, limit: 3
      t.decimal :valor, precision: 10, scale: 4, null: false
      t.datetime :fecha, null: false, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end

    # Creación de la tabla 'ingresos', corregir claves foráneas
    create_table :ingresos do |t|
      t.references :usuario, null: false, foreign_key: { to_table: :usuarios }  # Referencia a usuarios
      t.references :cliente, null: false, foreign_key: { to_table: :clientes }  # Referencia a clientes
      t.references :tipo_cambio, null: false, foreign_key: { to_table: :tipos_cambio }  # Referencia a tipos_cambio
      t.decimal :monto, precision: 15, scale: 2, null: false
      t.string :moneda, null: false, limit: 3, check: "moneda IN ('UYU', 'USD')"
      t.datetime :fecha, null: false, default: -> { 'CURRENT_TIMESTAMP' }, check: "fecha <= CURRENT_TIMESTAMP"
      t.string :sucursal, null: false, limit: 20, check: "sucursal IN ('Mercedes', 'Montevideo')"
      t.string :area, null: false, limit: 50, check: "area IN ('Juridica', 'Notarial', 'Contable', 'Recuperación de Activos', 'Otros')"
      t.string :concepto, null: false, limit: 255

      t.timestamps
    end

    # Creación de la tabla 'gastos', corregir claves foráneas
    create_table :gastos do |t|
      t.references :usuario, null: false, foreign_key: { to_table: :usuarios }  # Referencia a usuarios
      t.references :proveedor, null: false, foreign_key: { to_table: :proveedores }  # Referencia a proveedores
      t.references :tipo_cambio, null: false, foreign_key: { to_table: :tipos_cambio }  # Referencia a tipos_cambio
      t.decimal :monto, precision: 15, scale: 2, null: false
      t.string :moneda, null: false, limit: 3, check: "moneda IN ('UYU', 'USD')"
      t.datetime :fecha, null: false, default: -> { 'CURRENT_TIMESTAMP' }, check: "fecha <= CURRENT_TIMESTAMP"
      t.string :sucursal, null: false, limit: 20, check: "sucursal IN ('Mercedes', 'Montevideo')"
      t.string :area, null: false, limit: 50, check: "area IN ('Juridica', 'Notarial', 'Contable', 'Recuperación de Activos', 'Gastos Generales')"
      t.string :concepto, null: false, limit: 255

      t.timestamps
    end

    # Creación de la tabla 'retiros_utilidades'
    create_table :retiros_utilidades do |t|
      t.datetime :fecha, null: false, check: "fecha <= CURRENT_TIMESTAMP"
      t.decimal :tipo_cambio, precision: 10, scale: 4, null: false
      t.decimal :monto_uyu, precision: 15, scale: 2
      t.decimal :monto_usd, precision: 15, scale: 2
      t.string :sucursal, null: false, limit: 20, check: "sucursal IN ('Mercedes', 'Montevideo')"

      t.timestamps
    end

    # Creación de la tabla 'distribuciones_utilidades'
    create_table :distribuciones_utilidades do |t|
      t.datetime :fecha, null: false, check: "fecha <= CURRENT_TIMESTAMP"
      t.decimal :tipo_cambio, precision: 10, scale: 4, null: false
      t.string :sucursal, null: false, limit: 20, check: "sucursal IN ('Mercedes', 'Montevideo')"
      t.decimal :monto_uyu_agustina, precision: 15, scale: 2
      t.decimal :monto_usd_agustina, precision: 15, scale: 2
      t.decimal :monto_uyu_viviana, precision: 15, scale: 2
      t.decimal :monto_usd_viviana, precision: 15, scale: 2
      t.decimal :monto_uyu_gonzalo, precision: 15, scale: 2
      t.decimal :monto_usd_gonzalo, precision: 15, scale: 2
      t.decimal :monto_uyu_pancho, precision: 15, scale: 2
      t.decimal :monto_usd_pancho, precision: 15, scale: 2
      t.decimal :monto_uyu_bruno, precision: 15, scale: 2
      t.decimal :monto_usd_bruno, precision: 15, scale: 2

      t.timestamps
    end
  end
end
