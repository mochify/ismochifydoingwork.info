class Reports::ProductivityscoreController < ApplicationController
  def index
    score = Foreman.org_score
    render :json => {:score => score, :comment => Foreman.pithy_score_comment(score)}
  end
end
