class UserProfilesController < ApplicationController
  before_action :set_user_profile, only: [:show, :edit, :update, :destroy, :upload_profile_picture, :privacy, :settings]
  before_filter :authenticate_user!
  # GET /user_profiles
  # GET /user_profiles.json

  def index
    @user = User.find(current_user.id)
    @jobs = @user.jobs
  end

  # GET /user_profiles/1
  # GET /user_profiles/1.json
  def show
  end

  # GET /user_profiles/new
  def new
  end

  #find users
  def view_profile
   id = params[:user_profile_id]
   session[:user_id] = id
   @user = User.find_by_id(id)
   @jobs = Job.where(:user_id => id)
  end

  # GET /user_profiles/1/edit
  def edit
    @jobs = Job.all.paginate(:page => 1, :per_page => 30)
  end

  def privacy
    @user = User.new
  end

  # POST /user_profiles
  # POST /user_profiles.json
  def create
    @user = User.new(user_profile_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'Your photo was successfully added.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  #Upload profile picture
  def upload_profile_picture
    @user = User.find(current_user.id)
    @user.avatar = params[:file]
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_profiles_url }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

#profile settings
  def settings
    respond_to do |format|
      if @user.update(user_profile_params)
        format.html { redirect_to user_profiles_url, notice: 'privacy options were successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /user_profiles/1
  # PATCH/PUT /user_profiles/1.json
  def update
    respond_to do |format|
      if @user.update_attributes(user_profile_params)
        format.html { redirect_to user_profiles_url, notice: 'User profile was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  # DELETE /user_profiles/1
  # DELETE /user_profiles/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to user_profiles_url, notice: 'User profile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_profile
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_profile_params
      params.require(:user).permit(:name, :id_number, :phone, :avatar, :email, :city, :country, :location_privacy_option, :contact_privacy_option, :job_privacy_option, :social_privacy_option,:facebook,:twitter,:linkedin,:instagram, :is_job_seeker)
    end
end
