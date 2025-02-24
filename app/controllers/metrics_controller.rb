class MetricsController < ApplicationController
  before_action :require_full_access
  
  def index
    render json: { metrics: [] }, status: :ok
  end
end
