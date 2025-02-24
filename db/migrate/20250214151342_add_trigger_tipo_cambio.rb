class AddTriggerTipoCambio < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE OR REPLACE FUNCTION asignar_tipo_cambio()
      RETURNS TRIGGER AS $$
      DECLARE
        ultimo_tipo_cambio INTEGER;
      BEGIN
        -- Si no se especificó un tipo de cambio, obtenemos el último registrado para la moneda correspondiente
        IF NEW.tipo_cambio_id IS NULL THEN
          SELECT id INTO ultimo_tipo_cambio
          FROM tipos_cambio
          WHERE moneda = NEW.moneda
          ORDER BY fecha DESC
          LIMIT 1;

          -- Si encontramos un tipo de cambio, lo asignamos
          IF ultimo_tipo_cambio IS NOT NULL THEN
            NEW.tipo_cambio_id := ultimo_tipo_cambio;
          ELSE
            RAISE EXCEPTION 'No hay tipo de cambio registrado para la moneda %', NEW.moneda;
          END IF;
        END IF;
        RETURN NEW;
      END;
      $$ LANGUAGE plpgsql;

      -- Crear triggers para ingresos, gastos, retiros_utilidades y distribuciones_utilidades
      CREATE TRIGGER trigger_tipo_cambio_ingresos
      BEFORE INSERT ON ingresos
      FOR EACH ROW EXECUTE FUNCTION asignar_tipo_cambio();

      CREATE TRIGGER trigger_tipo_cambio_gastos
      BEFORE INSERT ON gastos
      FOR EACH ROW EXECUTE FUNCTION asignar_tipo_cambio();

      CREATE TRIGGER trigger_tipo_cambio_retiros_utilidades
      BEFORE INSERT ON retiros_utilidades
      FOR EACH ROW EXECUTE FUNCTION asignar_tipo_cambio();

      CREATE TRIGGER trigger_tipo_cambio_distribuciones_utilidades
      BEFORE INSERT ON distribuciones_utilidades
      FOR EACH ROW EXECUTE FUNCTION asignar_tipo_cambio();
    SQL
  end

  def down
    execute <<-SQL
      DROP TRIGGER IF EXISTS trigger_tipo_cambio_ingresos ON ingresos;
      DROP TRIGGER IF EXISTS trigger_tipo_cambio_gastos ON gastos;
      DROP TRIGGER IF EXISTS trigger_tipo_cambio_retiros_utilidades ON retiros_utilidades;
      DROP TRIGGER IF EXISTS trigger_tipo_cambio_distribuciones_utilidades ON distribuciones_utilidades;
      DROP FUNCTION IF EXISTS asignar_tipo_cambio;
    SQL
  end
end
