ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'usuario', 'usuarios'
  inflect.irregular 'cliente', 'clientes'
  inflect.irregular 'proveedor', 'proveedores'
  inflect.irregular 'tipo_cambio', 'tipos_cambio'
  inflect.irregular 'ingreso', 'ingresos'
  inflect.irregular 'gasto', 'gastos'
  inflect.irregular 'retiro_utilidad', 'retiros_utilidades'
  inflect.irregular 'distribucion_utilidad', 'distribuciones_utilidades'
end
