Apipie.configure do |config|
  config.api_controllers_matcher = [
    "#{Rails.root}/app/controllers/**/*.rb",
    "#{Rails.root}/lib/**/*_controller.rb"
  ]
end
