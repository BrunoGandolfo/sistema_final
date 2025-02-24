# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_02_18_123858) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clientes", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "distribuciones_utilidades", force: :cascade do |t|
    t.datetime "fecha", null: false
    t.decimal "tipo_cambio", precision: 10, scale: 4, null: false
    t.string "sucursal", limit: 20, null: false
    t.decimal "monto_uyu_agustina", precision: 15, scale: 2
    t.decimal "monto_usd_agustina", precision: 15, scale: 2
    t.decimal "monto_uyu_viviana", precision: 15, scale: 2
    t.decimal "monto_usd_viviana", precision: 15, scale: 2
    t.decimal "monto_uyu_gonzalo", precision: 15, scale: 2
    t.decimal "monto_usd_gonzalo", precision: 15, scale: 2
    t.decimal "monto_uyu_pancho", precision: 15, scale: 2
    t.decimal "monto_usd_pancho", precision: 15, scale: 2
    t.decimal "monto_uyu_bruno", precision: 15, scale: 2
    t.decimal "monto_usd_bruno", precision: 15, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "gastos", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.bigint "proveedor_id", null: false
    t.bigint "tipo_cambio_id", null: false
    t.decimal "monto", precision: 15, scale: 2, null: false
    t.string "moneda", limit: 3, null: false
    t.datetime "fecha", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "sucursal", limit: 20, null: false
    t.string "area", limit: 50, null: false
    t.string "concepto", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "date_trunc('month'::text, fecha)", name: "idx_gastos_mes"
    t.index "date_trunc('quarter'::text, fecha)", name: "idx_gastos_trimestre"
    t.index ["fecha", "monto"], name: "idx_gastos_max", order: :desc
    t.index ["proveedor_id"], name: "index_gastos_on_proveedor_id"
    t.index ["sucursal", "fecha", "monto"], name: "idx_gastos_sucursal_fecha"
    t.index ["tipo_cambio_id"], name: "index_gastos_on_tipo_cambio_id"
    t.index ["usuario_id"], name: "index_gastos_on_usuario_id"
  end

  create_table "ingresos", force: :cascade do |t|
    t.bigint "usuario_id", null: false
    t.bigint "cliente_id", null: false
    t.bigint "tipo_cambio_id", null: false
    t.decimal "monto", precision: 15, scale: 2, null: false
    t.string "moneda", limit: 3, null: false
    t.datetime "fecha", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "sucursal", limit: 20, null: false
    t.string "area", limit: 50, null: false
    t.string "concepto", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "date_trunc('month'::text, fecha)", name: "idx_ingresos_mes"
    t.index "date_trunc('quarter'::text, fecha)", name: "idx_ingresos_trimestre"
    t.index ["cliente_id", "fecha"], name: "idx_ingresos_cliente_fecha"
    t.index ["cliente_id"], name: "index_ingresos_on_cliente_id"
    t.index ["fecha", "area"], name: "idx_ingresos_fecha_area"
    t.index ["sucursal", "area", "fecha"], name: "idx_ingresos_sucursal_area_fecha"
    t.index ["sucursal", "fecha", "monto"], name: "idx_ingresos_sucursal_fecha"
    t.index ["tipo_cambio_id"], name: "index_ingresos_on_tipo_cambio_id"
    t.index ["usuario_id"], name: "index_ingresos_on_usuario_id"
  end

  create_table "proveedores", force: :cascade do |t|
    t.string "nombre", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "retiros_utilidades", force: :cascade do |t|
    t.datetime "fecha", null: false
    t.decimal "tipo_cambio", precision: 10, scale: 4, null: false
    t.decimal "monto_uyu", precision: 15, scale: 2
    t.decimal "monto_usd", precision: 15, scale: 2
    t.string "sucursal", limit: 20, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fecha", "sucursal"], name: "idx_retiros_fecha_sucursal"
  end

  create_table "tipos_cambio", force: :cascade do |t|
    t.string "moneda", limit: 3, null: false
    t.decimal "valor", precision: 10, scale: 4, null: false
    t.datetime "fecha", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nombre", null: false
    t.string "email", null: false
    t.string "rol", limit: 20, null: false
    t.boolean "activo", default: true
    t.datetime "ultimo_acceso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
  end

  add_foreign_key "gastos", "proveedores"
  add_foreign_key "gastos", "tipos_cambio"
  add_foreign_key "gastos", "usuarios"
  add_foreign_key "ingresos", "clientes"
  add_foreign_key "ingresos", "tipos_cambio"
  add_foreign_key "ingresos", "usuarios"
end
