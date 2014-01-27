require_relative '../../lib/github_info'

require 'timecop'
require 'vcr'
require 'vcr_helper'

describe GithubInfo do
  it "only pulls original repositories that are not forks" do
    VCR.use_cassette("github-all-repos") do
      repositories = GithubInfo.root_repositories

      repositories_all_original = repositories.all? { |repo| !repo.fork }

      repositories_all_original.should == true
    end
  end

  it "gives counts of recent github activity by week" do
    VCR.use_cassette("github-all-repo-commits") do
      participation = GithubInfo.all_repo_commits

      # Not the most solid/definitive of tests, but gives a bit of confidence integrating.
      participation.length.should == 52
    end
  end

  it "hits the cache for available information" do
    VCR.use_cassette("github-all-repo-commits") do
      OctoCache.should_receive(:get_repo_commits)
      participation = GithubInfo.all_repo_commits
    end
  end

  it "saves to the cache with new entries" do
    VCR.use_cassette("github-all-repo-commits") do
      Timecop.freeze(Date.today + 7) do # bit shady but +7 should be sufficient to make sure the key is empty.
        OctoCache.should_receive(:get_repo_commits)
        participation = GithubInfo.all_repo_commits
      end 
    end
  end
end
