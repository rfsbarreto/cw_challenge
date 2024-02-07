class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['CLOUDWALK_USERNAME'] && password == ENV['CLOUDWALK_TOKEN']
    end
  end
end
