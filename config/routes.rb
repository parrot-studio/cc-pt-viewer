Rails.application.routes.draw do

  root 'viewer#index'
  get 'datas' => 'viewer#datas'
end
