class ApiTokensController < ApplicationController
  def show
  end

  def create
    Current.user.generate_api_token
    redirect_to api_token_path, notice: "API token has been generated."
  end

  def destroy
    Current.user.reset_api_token
    redirect_to api_token_path, notice: "API token has been revoked."
  end
end
