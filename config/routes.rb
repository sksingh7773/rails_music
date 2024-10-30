# config/routes.rb
Rails.application.routes.draw do
  get 'bands/search', to: 'bands#search'
  get 'bands/location', to: 'bands#location'
end
