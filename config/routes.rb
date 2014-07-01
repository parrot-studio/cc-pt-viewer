Rails.application.routes.draw do

  root 'viewer#index'
  get  'arcanas' => 'viewer#arcanas'
  get  'ptm'     => 'viewer#ptm'
  get  ':code'   => 'viewer#index'
end
