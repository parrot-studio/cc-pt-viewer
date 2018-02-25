Rails.application.routes.draw do
  root 'viewer#ptedit'

  namespace :api do
    get  'search'  => 'arcanas#search'
    get  'ptm'     => 'arcanas#ptm'
    get  'codes'   => 'arcanas#codes'
    get  'name'    => 'arcanas#name_search'
    post 'request' => 'arcanas#request_mail'
  end

  get  'cc3'        => 'viewer#cc3'
  get  'about'      => 'viewer#about'
  get  'changelogs' => 'viewer#changelogs'
  get  'db'         => 'viewer#database'
  get  'data/:code' => 'viewer#detail'
  get  'data/:code/:name' => 'viewer#detail'
  get  ':code' => 'viewer#ptedit'
end
