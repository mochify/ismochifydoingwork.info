class Foreman
  def self.github_history_range # Not 100% about the "ruby-ness" of this
    60
  end

  def self.team_score
    activity = GithubInfo.recent_activity_counts(days: github_history_range)
    days_active = activity.count { |c| c > 0 }
    (days_active.to_f / github_history_range) * 100
  end
end
