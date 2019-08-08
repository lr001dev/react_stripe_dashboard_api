class WelcomeController < ApplicationController
  def index
    render json: { status: 200, message: "React Fitness" }
  end
end
