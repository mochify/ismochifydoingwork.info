class OctoCache
  class NotFound < RuntimeError
  end

  @storage = ActiveSupport::Cache::MemoryStore.new

  class << self
    def construct_repo_key(date)
      "octocache.repo:" + date + ":commit"
    end

    def save_repo_commits(date, commits)
      @storage.write(construct_repo_key(date), commits)
    end

    def get_repo_commits(date)
      stored_result = @storage.read construct_repo_key(date)

      if stored_result.nil?
        raise NotFound
      end

      stored_result
    end

    private :construct_repo_key
  end
end
