require_relative '../../lib/github_info'

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
end
