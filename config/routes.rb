Rails.application.routes.draw do
  root 'viewer#ptedit'

  namespace :api do
    get  'search',  to: 'arcanas#search'
    get  'ptm',     to: 'arcanas#ptm'
    get  'codes',   to: 'arcanas#codes'
    get  'name',    to: 'arcanas#name_search'
    post 'request', to: 'arcanas#request_mail'
  end

  get  'cc3',        to: 'viewer#cc3'
  get  'about',      to: 'viewer#about'
  get  'changelogs', to: 'viewer#changelogs'
  get  'db',         to: 'viewer#database'
  get  'data/:code', to: 'viewer#detail'
  get  'data/:code/:name', to: 'viewer#detail'
  get  ':code', to: 'viewer#ptedit', code: /[A-Z0-9]+/
end
