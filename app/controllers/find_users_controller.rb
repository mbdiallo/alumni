class FindUsersController < ApplicationController
  before_action :set_find_user, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /find_users
  # GET /find_users.json

  def index
    @search_results = User.ransack(params[:q])
    @users = @search_results.result.includes(:jobs)
  end

  def file_content

    @search_results = User.ransack(params[:q])
    @user = @search_results.result


    respond_to do |format|

      is_current_city = params[:q][:is_current_city]


        if is_current_city == "1"
          @users = @user.where(city: params[:city], country: params[:country])
        else
          @users = @search_results.result
        end
        format.html{}
        format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_find_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def find_user_params
      params(:find_user).require(:campu_id_eq, :faculty_id_eq, :programme_id_eq, :batch_id_eq)
    end
end
