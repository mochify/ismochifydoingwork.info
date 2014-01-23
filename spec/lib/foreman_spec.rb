require_relative '../../lib/foreman'
require_relative '../../lib/github_info'

require 'timecop'

describe Foreman do
  it "returns 0 when there has been no activity on github" do
    GithubInfo.stub(:all_repo_commits) { Array.new(52, 0) }
    Foreman.org_score.should == 0
  end

  it "returns 100 when there has been activity on github every day" do
    GithubInfo.stub(:all_repo_commits) { Array.new(52, 1) }
    Foreman.org_score.should == 100
  end

  it "returns a positive number when there is any activity on github" do
    GithubInfo.stub(:all_repo_commits) { Array.new(51, 0) + Array.new(1, 1) }
    Foreman.org_score.should == 12.5
  end
end
