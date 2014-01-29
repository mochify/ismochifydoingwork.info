class ReportController < ApplicationController
  def index
    @productivity_score = Foreman.org_score
  end
end
