require 'date'

class Foreman
  def self.github_history_range # Not 100% about the "ruby-ness" of this
    60
  end

  def self.org_score
    activity = GithubInfo.activity_counts(from: Date.today - github_history_range, to: Date.today)
    days_active = activity.count { |c| c > 0 }
    (days_active.to_f / github_history_range) * 100
  end
end
