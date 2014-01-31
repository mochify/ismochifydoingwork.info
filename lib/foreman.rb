class Foreman
  # number of weeks to look back to calculate score
  # Not 100% about the "ruby-ness" of this
  def self.github_history_range
    8
  end

  def self.recent_github_activity
    activity = GithubInfo.all_repo_commits
    relevant_activity = activity[(52 - self.github_history_range)..51]
  end

  def self.pithy_score_comment(score)
    # Foreman.pithy_score_comment(0).should == "Not even slightly."
    # Foreman.pithy_score_comment(30).should == "Just barely."
    # Foreman.pithy_score_comment(80).should == "Surprisingly, yes."
    # Foreman.pithy_score_comment(100).should == "Yes, but they're probably lying."
    if score == 100
      "Yes, but they're probably lying."
    elsif score > 50
      "Surprisingly, yes."
    elsif score > 0
      "Just barely."
    else
      "Not even slightly."
    end
  end

  def self.org_score
    relevant_activity = self.recent_github_activity

    weeks_active = relevant_activity.count { |c| c > 0 }
    (weeks_active.to_f / github_history_range) * 100
  end
end
