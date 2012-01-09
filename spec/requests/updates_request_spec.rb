require "spec_helper"

describe "Updates request" do

  describe "on the user profile page" do
    before(:each) do
      @user = Factory(:user, name: "Elliot Stabler")
      @update1 = Factory(:update, user: @user, created_at: 1.hour.ago)
      @update2 = Factory(:update, user: @user, created_at: 3.hours.ago)
      @update3 = Factory(:update, user: @user, created_at: 2.hours.ago)
      @updates = @user.updates
      login_user(@user)
      visit user_path(@user)
    end

    it "lists recent updates on profile page in the correct order" do
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

  describe "on the index page" do
    before(:each) do
      @user = Factory(:user)
      login_user(@user)
    end

    it "lists the feed of updates in DESC time order" do
      @another_user = Factory(:user)
      @user.follow(@another_user)
      @update1 = Factory(:update, user: @user, created_at: 1.hour.ago)
      @update2 = Factory(:update, user: @user, created_at: 3.hours.ago)
      @update3 = Factory(:update, user: @another_user, created_at: 2.hours.ago)
      visit root_url
      page.all(".update .content")[0].should have_content @update1.content
      page.all(".update .content")[1].should have_content @update3.content
      page.all(".update .content")[2].should have_content @update2.content
    end

    it "should only show the user feeds 10 most recent updates on page load" do
      11.times { Factory(:update, user: @user) }
      visit root_url
      page.all(".update").count.should == 10
    end

    it "creates updates from the dashboard" do
      visit root_url
      fill_in "update_content", with: "Odafin Tutuola is my hero."
      click_button "Share"
      page.should have_content "Update shared successfully!"
      current_path.should == "/"
      page.should have_content "Odafin Tutuola is my hero."
    end

    it "doesn't create an update when given invalid information" do
      visit root_url
      num_of_updates = Update.all.count
      click_button "Share"
      Update.all.count.should_not > num_of_updates
    end
  end
end