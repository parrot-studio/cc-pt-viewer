Rails.application.routes.draw do

  root 'viewer#index'
  get  'arcanas' => 'viewer#arcanas'
  get  'ptm'     => 'viewer#ptm'
  get  'about'   => 'viewer#about'
  get  ':code'   => 'viewer#index'
end
