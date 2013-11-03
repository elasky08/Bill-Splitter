require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  group = FactoryGirl.create(:group, name: "Paula's Group", id:26)
  user = FactoryGirl.create(:user, name: "Paula", id:25)

  test "create group" do
    test_group = FactoryGirl.build(:group, name: "Paula's Test Group")
    assert_equal Group.new.class, test_group.class, "This is not a group"
	assert_equal "Paula's Test Group", test_group.name, "The group name is not being set"
  end

  test "add user" do
    assert (not group.includes_user?(user)), "The user should not be added yet"
    assert group.add_user(user), "Add User Should return True"
    assert (group.includes_user?(user)), "The user should be added"
  end

  test "remove user" do
    assert (not group.includes_user?(user)), "The user should not be added yet"
    assert group.add_user(user), "Add User Should return True"
    assert (group.includes_user?(user)), "The user should be added" 
    group.remove_user(user)
    assert (not group.includes_user?(user)), "The user should not be in group"
  end

  test "get membership" do
    assert (not group.includes_user?(user)), "The user should not be added yet"
    assert group.add_user(user), "Add User Should return True"
    assert (group.includes_user?(user)), "The user should be added"
    membership = group.get_membership(user) 
	assert_equal group.id, membership.group_id, "Group is not in membership with user"
	assert_equal user.id, membership.user_id, "Group is not in membership with user"
    
  end

  test "add item" do
    assert group.add_user(user), "Add User Should return True"
    item = group.edit_item_by_name("Steak", 5.00)
    item_two = group.edit_item_by_name("Bacon", 7.00)
    assert_equal 12.00, group.get_items_total, "Total should be equal to 5"
    
  end

  test "get user item and totals" do
    assert group.add_user(user), "Add User Should return True"
    item = group.edit_item_by_name("Ham", 6.00)  
    item.add_user(user)
    assert_equal item.name, group.get_user_items(user).first.name, "The item should be added to user"
    assert_equal item.cost, group.get_user_total(user), "The cost should be equal"    

  end

  test "get payment" do
  	user_two = FactoryGirl.create(:user, name: "Steve", id:26)
    assert group.add_user(user), "Add User Should return True"
    assert group.add_user(user_two), "Add User Should return True"

    membership = group.get_membership(user)
    membership.payment = 12.00
    
    assert_equal membership.payment, group.get_payments_total, "The payments should be equal"
    

  end






end
