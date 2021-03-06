Rails.application.routes.draw do

  # index page route
  root 'welcome#index'

  # 'static' pages
  get 'reishi-information' => 'welcome#info', as: 'info'
  get 'about'              => 'welcome#about'

  # orders
  namespace :orders do
    root action: 'index'
    get  'new'
    post 'create'
  end
  
end
