require "spec_helper"

describe Reports::Github::RecentcommitsController do
  it "returns the list of recent commit counts" do
    Foreman.stub(:recent_github_activity) { "[1,2,3,4,5]" }

    get :index
    response.body.should == [1, 2, 3, 4, 5].to_json
  end
end
