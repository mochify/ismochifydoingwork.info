require_relative '../../lib/foreman'
require_relative '../../lib/github_info'

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

  it "knows the recent github stats for the team" do
    GithubInfo.stub(:all_repo_commits) { Array.new(48, 0) + Array.new(4, 1) }
    Foreman.recent_github_activity.should == [0, 0, 0, 0, 1, 1, 1, 1]
  end

  it "has a pithy comment depending on the productivity" do
    # Not sure about the format of this test; is there some other, more useful/less brittle property to assert on?
    Foreman.pithy_score_comment(0).should == "Not even slightly."
    Foreman.pithy_score_comment(30).should == "Just barely."
    Foreman.pithy_score_comment(80).should == "Surprisingly, yes."
    Foreman.pithy_score_comment(100).should == "Yes, but they're probably lying."
  end
end
