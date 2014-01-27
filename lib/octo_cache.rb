require 'redis'
require 'json'

class OctoCache
  class NotFound < RuntimeError
  end

  @redis = Redis.new(:url => ENV.fetch("MOCHIFYDOINGWORK_REDISURL"))

  class << self
    def construct_repo_key(date)
      "octocache.repo:" + date + ":commit"
    end

    def save_repo_commits(date, commits)
      @redis.set construct_repo_key(date), commits.to_json
    end

    def get_repo_commits(date)
      redis_result = @redis.get construct_repo_key(date)

      if redis_result.nil?
        raise NotFound
      end

      JSON.parse(redis_result)
    end

    private :construct_repo_key
  end
end
