class MetricsController < ApplicationController
  # Eliminamos el filtro que requiere acceso completo para todos
  # before_action :require_full_access
  
  def index
    # En el futuro se integrarán los cálculos reales de métricas
    respond_to do |format|
      format.html # Esto usará la vista app/views/metrics/index.html.erb
      format.json { render json: { metrics: [] }, status: :ok }
    end
  end
end
