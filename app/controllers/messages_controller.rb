class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.where(receiver: current_user.id).includes(:user).order('created_at DESC')
    @message = Message.new
  end

  def sent
    @messages = @messages = current_user.messages.order('created_at DESC')
  end
  # GET /messages/1
  # GET /messages/1.json
  def show
  end

  # GET /messages/new
  def new

    if !session[:user_id].nil?
      @receiver= User.find_by_id(session[:user_id])
    end

    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id

    if !params[:message][:receiver].nil?
      @message.receiver = params[:message][:receiver]
    else
      @message.receiver = session["user_id"]
    end

    respond_to do |format|
      if @message.save
        MessageMailer.notify(@message).deliver_now
        format.html { redirect_to sent_messages_path, notice: 'Message was successfully sent.' }
        format.json { render :show, status: :created, location: @message }
      else
        format.html { render :new }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { render :edit }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:subject, :body, :receiver)
    end
end
