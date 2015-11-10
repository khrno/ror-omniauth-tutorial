# require 'twitter_client'
class SessionsController < ApplicationController
  def new
  end

  def create
    auth_hash = request.env["omniauth.auth"]

    if session[:user_id]
      User.find(session[:user_id]).add_provider(auth_hash)


    else
      auth = Authorization.find_or_create(auth_hash)

      session[:user_id] = auth.user.id



    end
    # render :text => "You can login using #{auth_hash["provider"].capitalize} too!"

    if auth_hash["provider"] == "twitter"
      logger.info "Token: " + auth_hash["credentials"]["token"]
      logger.info "Secret: " + auth_hash["credentials"]["secret"]
      config = {
          consumer_key:    auth_hash["credentials"]["token"],
          consumer_secret: auth_hash["credentials"]["secret"],
      }

      @client = ::Twitter::REST::Client.new do |config|
        config.consumer_key = "KXt2vqosFVQZdvXievvcXXgO8"
        config.consumer_secret = "nRX6rDSoLbHaDiuBRfGI21C1Qqn6loilytbwa66GXekL89HDKI"
        config.access_token = "31307687-6F47KlrUgbZwyCL8jfK2nJkqx3oYbyjIEVD8rGFVl"
        config.access_token_secret = "OyLlqR7OYLlLk1MUqcQgkqd5QrGAnZcXhjTQJRxJZDrGY"
      end

      screen_names = []
      next_cursor = -1
      while next_cursor != 0
        cursor = @client.followers(:cursor => next_cursor)
        cursor.each do |follower|
          ap follower.screen_name
          screen_names.append(follower.screen_name)
        end
        next_cursor = cursor.next_cursor
        sleep(2000)
      end

      render :text => "# Followers indexed: #{screen_names.count}"
    end
  end

  def destroy
    session[:user_id] = nil
    render :text => "You've logged out!"
  end

  def failure
    render :text => "Sorry, but you didn't allow access to our app!"
  end
end
