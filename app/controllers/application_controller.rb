class ApplicationController < ActionController::Base

  around_action :switch_locale
  
  def switch_locale(&action)
    # Set the locale to be used in URLs
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    # Include locale in the query string
    # This is overridden in routes.rb to organize the URL
    { locale: I18n.locale }
  end

end
