class ApplicationController < ActionController::API
   include ::ActionController::Cookies

  def authenticate_token
    puts "AUTHENTICATE JWT"
    render json: { status: 401, message: 'Unauthorized' } unless decode_token(bearer_token)
  end

  def bearer_token
    header = request.env["HTTP_AUTHORIZATION"]
    pattern = /^Bearer /
    header.gsub(pattern, '') if header && header.match(pattern)
  end

  def decode_token(token_input)
    jwt = cookies.signed[:jwt]
    JWT.decode(jwt, ENV["JWT_SECRET"], true, { :algorithm => 'HS256'})
  rescue
    render json: { status: 401, message: 'Unauthorized' }
  end

  def get_current_user
    return if !bearer_token
    decode_jwt = decode_token(bearer_token)
    User.find(decode_jwt[0]["user"]["id"])
  end

  def authorize_user
   render json: { status: 401, message: "Unauthorized" } unless get_current_user.id == params[:id].to_i
 end

end
