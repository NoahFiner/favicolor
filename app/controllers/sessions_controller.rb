class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:neutral] = "You're already logged in."
      redirect_to current_user
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in(user)
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = "Account not activated. Check your email for an activation link."
        redirect_to root_url
      end
    else
      flash[:danger] = "Invalid email/password combination."
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
