Rails.application.routes.draw do

  # Scoped to place locale in URL instead of at the end
  # If now setting included in URL the default is used
  scope "(:locale)", locale: /en|es/ do

    root              to: 'pages#home'
    post 'validate',  to: 'pages#validate'
    get  'about',     to: 'pages#about'

  end
end
