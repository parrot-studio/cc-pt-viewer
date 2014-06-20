Rails.application.routes.draw do

  root 'viewer#index'
  get  'datas'    => 'viewer#datas'
  get  'search'   => 'viewer#search'
  get  'pt/:code' => 'viewer#pt'
end
