require_relative '../../lib/foreman'
require_relative '../../lib/github_info'

describe Foreman do
  it "returns 0 when there has been no activity on github" do
    GithubInfo.stub(:recent_activity_counts).with(days: Foreman.github_history_range) { [] }
    Foreman.team_score.should == 0
  end

  it "returns 100 when there has been activity on github every day" do
    GithubInfo.stub(:recent_activity_counts).with(days: Foreman.github_history_range) { Array.new(60, 1) }
    Foreman.team_score.should == 100
  end

  it "returns a positive number when there is any activity on github" do
    GithubInfo.stub(:recent_activity_counts).with(days: Foreman.github_history_range) { Array.new(30, 0) + Array.new(30, 1) }
    Foreman.team_score.should == 50
  end
end
