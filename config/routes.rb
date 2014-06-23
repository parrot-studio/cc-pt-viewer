Rails.application.routes.draw do

  root 'viewer#index'
  get  'arcanas'  => 'viewer#arcanas'
  get  'pt/:code' => 'viewer#pt'
end
