class MetricsController < ApplicationController
  before_action :require_full_access

  def index
    # Por ahora retorna un placeholder; en el futuro se integrarán los cálculos reales de métricas.
    render json: { metrics: [] }, status: :ok
  end
end
