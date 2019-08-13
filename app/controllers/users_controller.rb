class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_token, except: [:login, :create]
  before_action :authorize_user, except: [:login, :create, :index]

  # GET /users
  def index
    @users = User.select('first_name, last_name, email, username, id').all
    render json: @users
  end

  # GET /users/1
  def show
    booked_sessions = Booking.joins(:session).select('session_id as id, name, modality, length, trainer, img_url, description, booked_date').where("user_id = #{ @user.id }").order('booked_date ASC')
    render json: { user: @user, bookings: booked_sessions }
  end

  def login
    user = User.find_by(username: params[:user][:username])
    puts user
    if user && user.authenticate(params[:user][:password])

      token = create_token(user.id, user.username)
      cookies.signed[:jwt] = { value: token, httponly: true }
      render json: {status: 200, token: token, user: user }
    else
      render json: {status: 401, message: "Unauthorized"}
    end
 end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.select('first_name, last_name, email, username, id').find(params[:id])
    end

    def create_token(id, username)
      JWT.encode(payload(id, username), ENV['JWT_SECRET'], 'HS256')
    end

def payload(id, username)
  {
    exp: (Time.now + 30.minutes).to_i,
    iat: Time.now.to_i,
    iss: ENV['JWT_ISSUER'],
    user: {
      id: id,
      username: username
    }
  }
end
    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :username, :password)
    end
end
