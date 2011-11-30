require 'spec_helper'

describe "Application" do

  describe "GET '/'" do

    before(:each) do
      @user = Factory(:user)
    end
    
    context "authenticated user" do
      it "displays update feed" do
        login_user(@user)
        @update1 = Factory(:update, user: @user)
        @update2 = Factory(:update, user: @user)
        visit '/'
        page.should have_content @update1.content
        page.should have_content @update2.content
      end
    end

    context "unauthenticated user" do
      it "should not display the user's feed items" do
        @update1 = Factory(:update, user: @user)
        @update2 = Factory(:update, user: @user)
        visit '/'
        page.should_not have_content @update1.content
        page.should_not have_content @update2.content        
      end
    end

  end

  describe "following page" do

    before(:each) do
      @eric = Factory(:user, name: "Eric Kelly")
      @bill = Factory(:user, name: "Bill Nye")
      @fred = Factory(:user, name: "Fred Flinstone")
    end

    context "authenticated user" do
      it "should list the users that the current user is following" do
        @eric.follow(@bill)
        @eric.following?(@fred).should be_false
        login_user(@eric)
        click_link "account_following"
        page.should have_content "Bill Nye"
        page.should_not have_content "Fred Flinstone"
      end
    end

  end

end