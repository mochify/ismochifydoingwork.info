Given(/^Team1 has worked recently on github$/) do
  GithubInfo.stub(:recent_activity_counts).with(days: Foreman.github_history_range) { Array.new(60, 1) }
end

Given(/^Team2 has done no work recently on github$/) do
  GithubInfo.stub(:recent_activity_counts).with(days: Foreman.github_history_range) { Array.new(0, 0) }
end

When(/^the foreman calculates productivity for (.*)$/) do |org|
  @scores ||= {}
  @scores[org] = Foreman.org_score
end

Then(/^the score for (.*) should be (.*)$/) do |org, descriptor|
  case descriptor
  when "positive"
    @scores[org].should be > 0
  when "zero"
    @scores[org].should == 0
  end
end
