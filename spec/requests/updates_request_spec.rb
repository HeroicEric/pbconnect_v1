require "spec_helper"

describe "Updates request" do

  describe "on the user profile page" do
    before(:each) do
      @user = Factory(:user, name: "Elliot Stabler")
      @update1 = Factory(:update, user: @user, created_at: 1.hour.ago)
      @update2 = Factory(:update, user: @user, created_at: 3.hours.ago)
      @update3 = Factory(:update, user: @user, created_at: 2.hours.ago)
      @updates = [@update1, @update2, @update3]
      login_user(@user)
      visit user_path(@user)
    end

    it "lists recent updates on profile page" do
      @updates.each do |update|
        page.should have_content update.content
      end
    end

    it "lists links to the users who made the updates" do
      @updates.each do |update|
        page.should have_link(update.user.name, href: user_path(update.user))
      end
    end
  end

  context "an authenticated user" do

    before(:each) do
      @user = Factory(:user)
      login_user(@user)
    end

    describe "success" do
      it "creates updates from the dashboard" do
        visit '/'
        fill_in "update_content", with: "Odafin Tutuola is my hero."
        click_button "Share"
        page.should have_content "Update shared successfully!"
        current_path.should == "/"
      end
    end

    describe "failure" do
      it "reloads page when update isn't valid" do
        visit '/'
        click_button "Share"
        page.should have_content "Uh oh!"
      end
    end

  end

end