Given(/^Team1 has worked recently on github$/) do
  GithubInfo.stub(:recent_activity_counts).with(days: Foreman.github_history_range) { Array.new(60, 1) }
end

Given(/^Team2 has done no work recently on github$/) do
  GithubInfo.stub(:recent_activity_counts).with(days: Foreman.github_history_range) { Array.new(0, 0) }
end

When(/^the foreman calculates productivity for (.*)$/) do |team|
  @scores ||= {}
  @scores[team] = Foreman.team_score
end

Then(/^the score for (.*) should be (.*)$/) do |team, descriptor|
  case descriptor
  when "positive"
    @scores[team].should be > 0
  when "zero"
    @scores[team].should == 0
  end
end
