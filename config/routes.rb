Rails.application.routes.draw do

  root 'viewer#ptedit'
  get  'conditions' => 'viewer#conditions'
  get  'db'      => 'viewer#database'
  get  'arcanas' => 'viewer#arcanas'
  get  'ptm'     => 'viewer#ptm'
  get  'codes'   => 'viewer#codes'
  get  'about'   => 'viewer#about'
  get  'changelogs' => 'viewer#changelogs'
  post 'request' => 'viewer#request_mail'
  get  ':code'   => 'viewer#ptedit'

end
