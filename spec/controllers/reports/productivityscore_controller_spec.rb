require "spec_helper"

describe Reports::ProductivityscoreController do
  it "returns the list of recent commit counts" do
    Foreman.stub(:org_score) { 12 }

    get :index
    response.body.should == {:score => 12}.to_json
  end
end
