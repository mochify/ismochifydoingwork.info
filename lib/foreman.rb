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

    # Productivity for a given week is 100% if # commits >= 50.  Overall productivity is the average of the productivity
    # over all the relevant weeks
    min_commit_count = 50.0
    weekly_scores = relevant_activity.map { |c| [1.0, (c / min_commit_count)].min }

    ((weekly_scores.sum / weekly_scores.size.to_f) * 100).round(2)
  end
end
