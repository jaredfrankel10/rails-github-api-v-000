class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create
  def create
    response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: ENV['GITHUB_CLIENT_ID'], client_secret:  ENV['GITHUB_SECRET'], code: params[:code]}, {'Accept' => 'application/json'}
 
     auth_hash = JSON.parse(resp.body)
     session[:token] = auth_hash["access_token"]
     user_resp = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}
     user_value = JSON.parse(user_resp.body)
     session[:username] = user_value["login"]

     redirect_to '/'
  end
end
