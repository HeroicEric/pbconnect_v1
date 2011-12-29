require 'spec_helper'

describe "Users request" do
  it "shows profile" do
    user = Factory(:user, name: "Elliot Stabler", email: "establer@svu.gov")
    visit user_path(user)
    page.should have_content(user.name)
  end

  describe "GET /users" do

    before(:each) do
      @user1 = Factory(:user)
      @user2 = Factory(:user)
    end

    context "an authorized user" do
      it "lists users" do
        login_user(@user1)
        visit users_path
        page.should have_content @user1.name
        page.should have_content @user2.name
      end
    end

    context "an unauthorized user" do
      it "should redirect to login page" do
        visit users_path
        page.should have_content "Sign in"
      end
    end
  end

  describe "follows" do
    context "on a user profile page" do
      before(:each) do
        @ollie = Factory(:user)
        @ryan = Factory(:user)
        login_user(@ollie)
      end

      it "follows the user" do
        visit user_path(@ryan)
        click_button "Follow"
        @ollie.following_users.should include(@ryan)
        @ryan.user_followers.should include(@ollie)
      end

      it "unfollows the user" do
        @ollie.follow(@ryan)
        visit user_path(@ryan)
        click_button "Unfollow"
        @ollie.following_users.should_not include(@ryan)
        @ryan.user_followers.should_not include(@ollie)
      end
    end
  end
end