Rails.application.routes.draw do
  resources :places

  # root to: 'jp_cities#search'
  root to: 'primary_schools#search'
  get '/primary_schools' => 'primary_schools#search', as: :primary_schools
end
