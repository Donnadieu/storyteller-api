require "rails_helper"

RSpec.describe UserStoriesController, type: :routing do
  xdescribe "routing" do
    it "routes to #index" do
      expect(get: "/user_stories").to route_to("user_stories#index")
    end

    it "routes to #show" do
      expect(get: "/user_stories/1").to route_to("user_stories#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user_stories").to route_to("user_stories#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user_stories/1").to route_to("user_stories#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user_stories/1").to route_to("user_stories#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user_stories/1").to route_to("user_stories#destroy", id: "1")
    end
  end
end
