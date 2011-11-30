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

    it "validates the presence of user_id" do
      update = Update.new(@attr)
      update.should_not be_valid
    end

    describe "content validations" do
      it "validates the presence of content" do
        update = @user.updates.build(@attr.merge(content: ""))
        update.should_not be_valid
      end

      it "should be at least 3 characters" do
        update = @user.updates.build(@attr.merge(content: "ab"))
        update.should_not be_valid
      end

      it "should be 140 characters or less" do
        update = @user.updates.build(@attr.merge(content: "a"*141))
        update.should_not be_valid
      end
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

  describe "#self.from_self_and_followed_by(user)" do
    it "includes the updates from given user" do
      @update = @user.updates.create(@attr)
      Update.from_self_and_followed_by(@user).should include(@update)
    end

    it "includes the updates from followed users" do
      @followed_user = Factory(:user)
      @user.follow(@followed_user)
      @update = @followed_user.updates.create(@attr)
      Update.from_self_and_followed_by(@user).should include(@update)
    end

    it "doesnt include updates from nonfollowed users" do
      @nonfollowed_user = Factory(:user)
      @user.following?(@nonfollowed_user).should be_false
      @update = @nonfollowed_user.updates.create(@attr)
      Update.from_self_and_followed_by(@user).should_not include(@update)
    end
  end

end