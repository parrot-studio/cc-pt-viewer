Rails.application.routes.draw do

  root 'viewer#index'
  get  'arcanas' => 'viewer#arcanas'
  get  'ptm'     => 'viewer#ptm'
  get  'codes'   => 'viewer#codes'
  get  'about'   => 'viewer#about'
  get  'changelogs' => 'viewer#changelogs'
  get  ':code'   => 'viewer#index'

end
