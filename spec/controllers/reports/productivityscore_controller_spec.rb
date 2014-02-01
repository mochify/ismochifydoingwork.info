require "spec_helper"
require "json"

describe Reports::ProductivityscoreController do
  it "returns the list of recent commit counts" do
    Foreman.stub(:org_score) { 12 }

    get :index
    JSON.parse(response.body, :symbolize_names => true)[:score].should == 12
  end

  it "returns a pithy comment along with the score" do
    Foreman.stub(:org_score) { 12 }

    get :index
    JSON.parse(response.body, :symbolize_names => true).keys.sort.should == [:comment, :score]
  end
end
