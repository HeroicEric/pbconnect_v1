require "spec_helper"

describe Update do

  before(:each) do
    @user = Factory(:user, name: "Elliot Stabler")
    @attr = {
      content: "captured a criminal."
    }
  end

  describe "validations" do
    it "creates if given valid attributes" do
      @user.updates.create!(@attr)
    end

    it "validates the presence of content" do
      update = @user.updates.build(@attr.merge(content: ""))
      update.should_not be_valid
    end

    it "validates the presence of user_id" do
      update = Update.new(@attr)
      update.should_not be_valid
    end
  end

  describe "user associations" do
    before(:each) do
      @update = @user.updates.create(@attr)
    end

    it "should have a user attribute" do
      @update.should respond_to(:user)
    end

    it "should be associated to the correct user" do
      @update.user_id.should == @user.id
      @update.user.should == @user
    end
  end

end