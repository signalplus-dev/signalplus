class ApplicationController < ActionController::Base
  force_ssl if Rails.env.production?
  protect_from_forgery with: :exception
  after_filter :flash_to_http_header

  private

  def flash_to_http_header
    return unless request.xhr?
    return if flash.empty?
    response.headers['X-FlashMessages'] = flash.to_hash.to_json
    flash.discard  # don't want the flash to appear when you reload page
  end
end
