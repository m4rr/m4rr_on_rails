class StarsController < ApplicationController
  layout 'stars'

  def index
  end

  def privacy_policy
    render 'privacy-policy'
  end
end
