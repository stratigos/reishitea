Rails.application.routes.draw do

  # index page route
  root 'welcome#index'

  # 'static' pages
  get 'reishi-information' => 'welcome#info', as: 'info'
  get 'about'              => 'welcome#about'

  # orders
  get  'orders/index'
  post 'orders/create'
  
end
