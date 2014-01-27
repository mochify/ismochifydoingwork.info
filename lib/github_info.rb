require 'octokit'
require 'faraday/http_cache'
require 'date'

class GithubInfo
  Octokit.configure do |c|
    c.access_token = ENV.fetch("MOCHIFYDOINGWORK_OAUTH")
  end

  stack = Faraday::RackBuilder.new do |builder|
    builder.use Faraday::HttpCache
    builder.use Octokit::Response::RaiseError
    builder.adapter Faraday.default_adapter
  end

  Octokit.middleware = stack

  class << self
    def root_repositories
      repositories = Octokit.organization_repositories(ENV.fetch("MOCHIFYDOINGWORK_ORGNAME"))
      repositories.select { |repo| !repo.fork }
    end

    def all_repositories
      repositories = root_repositories
      forks = repositories.map { |repo|
        Octokit.forks(repo.full_name)
      }.flatten

      repositories + forks
    end

    def all_repo_commits
      today = Date.today()

      begin
        # Try to fish a score out of the cache first.  We should be comfortable with day-based cache.
        OctoCache.get_repo_commits(today.to_s)
      rescue OctoCache::NotFound
        commits = all_repo_commits!
        OctoCache.save_repo_commits(today.to_s, commits)
        commits
      end
    end

    def all_repo_commits!
      repositories = all_repositories

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
end
