class Reports::Github::RecentcommitsController < ApplicationController
  def index
    render :json => Foreman.recent_github_activity
  end
end
