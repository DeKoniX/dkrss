class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :store_current_location, unless: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  around_action :with_time_zone, if: 'current_user.try(:time_zone)'

  private

  def store_current_location
    store_location_for(:user, request.url)
  end

  def after_sign_out_path_for(resource)
    request.referrer || root_path
  end

  protected

  def with_time_zone(&block)
    time_zone = current_user.time_zone
    logger.debug "Используется часовой пояс пользователя: #{time_zone}"
    Time.use_zone(time_zone, &block)
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) << :time_zone
  end

end
