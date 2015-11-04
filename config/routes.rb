Rails.application.routes.draw do
  api_version(module: "V1", :header => {:name => "Accept", :value => "application/agh.edu.pl; version=1"}) do
    match '/version' => 'stats#version', via: :get 
    resources :products
    resources :categories
  end
  
  resources :products
  resources :categories
  root to: 'visitors#index'
end
