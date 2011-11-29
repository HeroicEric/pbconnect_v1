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
end