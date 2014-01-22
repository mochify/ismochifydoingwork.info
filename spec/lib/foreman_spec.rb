require_relative '../../lib/foreman'
require_relative '../../lib/github_info'

require 'timecop'

describe Foreman do
  before do
    Timecop.travel(Date.new(2014, 01, 01))
  end

  after do
    Timecop.return
  end

  it "returns 0 when there has been no activity on github" do
    GithubInfo.stub(:activity_counts).with(from: Date.new(2013, 11, 02), to: Date.new(2014, 01, 01)) { Array.new(0, 0) }
    Foreman.org_score.should == 0
  end

  it "returns 100 when there has been activity on github every day" do
    GithubInfo.stub(:activity_counts).with(from: Date.new(2013, 11, 02), to: Date.new(2014, 01, 01)) { Array.new(60, 1) }
    Foreman.org_score.should == 100
  end

  it "returns a positive number when there is any activity on github" do
    GithubInfo.stub(:activity_counts).with(from: Date.new(2013, 11, 02), to: Date.new(2014, 01, 01)) { Array.new(30, 0) + Array.new(30, 1) }
    Foreman.org_score.should == 50
  end
end
