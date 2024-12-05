class AtaskStock::Controllers::Api::V1::StockController < AtaskStock::Controllers::ApplicationController
  before_action :validate_params_id, only: [ :show ]

  api :GET, "/v1/stock/prices", "Show All Stock Prices"
  formats [ "json" ]
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      "data": [
        {
          "id": 1,
          "name": "Astra Agro Lestari Tbk.",
          "description": "Stock of Astra Agro Lestari Tbk.",
          "code": "AALI",
          "available_lot": 100,
          "current_price_per_lot": 1000,
          "created_at": "2024-12-08T07:12:29.511Z",
          "updated_at": "2024-12-08T07:12:29.511Z"
        },
        {
          "id": 2,
          "name": "Mahaka Media Tbk.",
          "description": "Stock of Mahaka Media Tbk.",
          "code": "ABBA",
          "available_lot": 150,
          "current_price_per_lot": 1500,
          "created_at": "2024-12-08T07:12:29.515Z",
          "updated_at": "2024-12-08T07:12:29.515Z"
        }
      ]
    }
  )
  def index
    success(AtaskStock::Models::Stock.all)
  end

  api :GET, "/v1/stock/prices/:id", "Show Specific Stock Price"
  formats [ "json" ]
  example "Success Response (JSON) :"
  example JSON.pretty_generate(
    {
      "data": {
        "id": 1,
        "name": "Astra Agro Lestari Tbk.",
        "description": "Stock of Astra Agro Lestari Tbk.",
        "code": "AALI",
        "available_lot": 100,
        "current_price_per_lot": 1000,
        "created_at": "2024-12-08T07:12:29.511Z",
        "updated_at": "2024-12-08T07:12:29.511Z"
      }
    }
  )
  def show
    success(AtaskStock::Models::Stock.find(params[:id]))
  end

  private

  def validate_params_id
    params.expect(:id)
  end
end
