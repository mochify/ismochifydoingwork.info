class Reports::ProductivityscoreController < ApplicationController
  def index
    render :json => {:score => Foreman.org_score}
  end
end
