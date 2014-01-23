require 'date'
require 'octokit'

class GithubInfo
  Octokit.configure do |c|
    c.access_token = ENV.fetch("MOCHIFYDOINGWORK_OAUTH")
  end

  def self.all_repositories
    repositories = (Octokit.organization_repositories(ENV.fetch("MOCHIFYDOINGWORK_ORGNAME")))
    forks = repositories.map { |repo|
      Octokit.forks(repo.full_name)
    }.flatten

    repositories + forks
  end

  def self.all_repo_commits
    repositories = self.all_repositories

    repo_weekly_commits = repositories.map { |repo|
      participation = Octokit.participation_stats(repo.full_name).all
      # If the repo is empty, the participation array comes back as []
      participation = participation.empty? ? [0] * 52 : participation
    }

    total_weekly_commits = repo_weekly_commits.reduce { |total_commits, repo_commits|
      total_commits.zip(repo_commits).map { |first, second| first + second }
    }

    total_weekly_commits
  end
end
