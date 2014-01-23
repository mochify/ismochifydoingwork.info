class Foreman
  # number of weeks to look back to calculate score
  # Not 100% about the "ruby-ness" of this
  def self.github_history_range
    8
  end

  def self.org_score
    activity = GithubInfo.all_repo_commits
    relevant_activity = activity[(52 - self.github_history_range)..51]

    weeks_active = relevant_activity.count { |c| c > 0 }
    (weeks_active.to_f / github_history_range) * 100
  end
end
