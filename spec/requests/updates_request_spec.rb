require "spec_helper"

describe "Updates request" do

  it "lists recent updates on profile page" do
    @user = Factory(:user, name: "Elliot Stabler")
    @update1 = Factory(:update, user: @user, created_at: 1.hour.ago)
    @update2 = Factory(:update, user: @user, created_at: 3.hours.ago)
    @update3 = Factory(:update, user: @user, created_at: 2.hours.ago)
    login_user(@user)
    visit user_path(@user)
    page.should have_content "#{@update1.content}"
    page.should have_content "#{@update2.content}"
    page.should have_content "#{@update3.content}"
  end

  context "an authenticated user" do

    before(:each) do
      @user = Factory(:user)
      login_user(@user)
    end

    it "creates updates from the dashboard" do
      visit '/'
      fill_in "update_content", with: "Odafin Tutuola is my hero."
      click_button "Share"
      page.should have_content "Update shared successfully!"
      current_path.should == "/"
    end

  end

end