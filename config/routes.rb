Rails.application.routes.draw do
  root 'pages#home'
  post 'pages#validate'
end
