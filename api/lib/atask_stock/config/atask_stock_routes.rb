Rails.application.routes.draw do
  scope module: "atask_stock/controllers" do
    namespace :api do
      namespace :v1 do
        namespace :stock do
          get "prices", to: "index"
          get "prices/:id", to: "show"
        end
      end
    end
  end
end
