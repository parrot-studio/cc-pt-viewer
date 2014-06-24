Rails.application.routes.draw do

  root 'viewer#index'
  get  'arcanas'  => 'viewer#arcanas'
  get  ':code'    => 'viewer#pt'
end
