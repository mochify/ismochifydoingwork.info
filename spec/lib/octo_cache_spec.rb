require_relative '../../lib/octo_cache'

describe OctoCache do
  it "should return repo commit info if it exists for a certain date" do
    OctoCache.save_repo_commits('2000-01-01', [1] * 52)
    OctoCache.get_repo_commits('2000-01-01').should == [1] * 52
  end

  it "should throw the appropriate exception if it doesn't exist for a certain date" do
    expect { OctoCache.get_repo_commits('2000-01-02') }.to raise_error(OctoCache::NotFound)
  end
end
