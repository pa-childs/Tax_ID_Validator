Rails.application.routes.draw do

  root              to: 'pages#home'
  post 'validate',  to: 'pages#validate'
  get  'about',     to: 'pages#about'

end
