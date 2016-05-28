class MauthController < ApplicationController
  layout 'mauth'

  def index
  end

  def privacy_policy
    render 'privacy-policy'
  end
end
