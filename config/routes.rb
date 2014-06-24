Rails.application.routes.draw do

  root 'viewer#index'
  get  'arcanas'  => 'viewer#arcanas'
  get  'list'     => 'viewer#list'
  get  'pt/:code' => 'viewer#pt'
end
