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
      screen_names = []
      next_cursor = -1

      while next_cursor != 0
        cursor = $twitter.followers(cursor: next_cursor, count: 200)
        cursor.each do |follower|
          ap follower.screen_name
          screen_names.append(follower.screen_name)
        end
        next_cursor = cursor.send(:next_cursor)
        logger.info next_cursor
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
