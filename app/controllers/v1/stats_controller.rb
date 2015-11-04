class V1::StatsController < V1::BaseController
  def version
    render json: 'AGH, Version 1, V20151105'
  end
end