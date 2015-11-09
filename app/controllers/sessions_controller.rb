class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    if session[:user_id]
      User.find(session[:user_id]).add_provider(auth_hash)

      render :text => "You can login using #{auth_hash["provider"].capitalize} too!"
    else
      auth = Authorization.find_or_create(auth_hash)

      session[:user_id] = auth.user.id

      render :text => "Welcome #{auth.user.name}!"

    end


    # @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
    #
    # if @authorization
    #   render :text => "Welcome back #{@authorization.user.name}! You have already signed up."
    # else
    #   user = User.new :name => auth_hash["info"]["name"], :email => auth_hash["info"]["email"]
    #   user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    #   user.save
    #
    #   render :text => "Hi #{user.name}! You've signed up"
    # end
  end

  def destroy
    session[:user_id] = nil
    render :text => "You've logged out!"
  end

  def failure
    render :text => "Sorry, but you didn't allow access to our app!"
  end
end
