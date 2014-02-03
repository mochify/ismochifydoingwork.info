require 'octokit'
require 'faraday/http_cache'
require 'date'

class GithubInfo
  Octokit.configure do |c|
    c.access_token = ENV.fetch("MOCHIFYDOINGWORK_OAUTH", "OAUTH_NOT_FOUND")
  end

  stack = Faraday::RackBuilder.new do |builder|
    builder.use Faraday::HttpCache
    builder.use Octokit::Response::RaiseError
    builder.adapter Faraday.default_adapter
  end

  Octokit.middleware = stack

  class << self
    def root_repositories
      repositories = Octokit.organization_repositories(ENV.fetch("MOCHIFYDOINGWORK_ORGNAME", "ORG_NOT_FOUND"))
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
        octokit_response = Octokit.participation_stats(repo.full_name)
        retries = 0

        # for expensive operations like participation stats, sometimes github returns a 202 and tells us to come back
        # later, in which case the response is nil.  Apparently octokit doesn't handle this automatically (it does die
        # on non-2xx and 3xx codes, but not on 202), so we have to; however, I'm only willing to wait a few seconds
        # before moving on.
        while (octokit_response.nil? && retries < 15) do
          octokit_response = Octokit.participation_stats(repo.full_name)
          retries += 1
          sleep(1)
        end
        octokit_response ||= {:all => []}

        participation = Octokit.participation_stats(repo.full_name).all
        # If the repo is empty, the participation array comes back as [], so fill it with 0s
        participation = participation.empty? ? [0] * 52 : participation
      }

      total_weekly_commits = repo_weekly_commits.reduce { |total_commits, repo_commits|
        total_commits.zip(repo_commits).map { |first, second| first + second }
      }

      total_weekly_commits
    end
  end
end
