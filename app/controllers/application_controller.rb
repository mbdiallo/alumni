class ApplicationController < ActionController::Base
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:student_id, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.permit(:sign_in) { |u| u.permit(:student_id, :email, :password, :password_confirmation, :remember_me) }
  end

  def set_global_search_variable
    @users = Graduation.search(params[:q])
  end

  def after_sign_in_path_for(resource)
    if current_user.is_graduate
      #graduate path
      user_profiles_path
    elsif current_user.is_employer
      #admin path
      search_employers_path
    else
      members_path
    end
  end
end
