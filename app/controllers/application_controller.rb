class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  if ENV["PRIMARY_SCHOOL_SEARCH_AUTH_ID"] && ENV["PRIMARY_SCHOOL_SEARCH_AUTH_PW"]
    http_basic_authenticate_with name: ENV["PRIMARY_SCHOOL_SEARCH_AUTH_ID"], password: ENV["PRIMARY_SCHOOL_SEARCH_AUTH_PW"]
  end
end
