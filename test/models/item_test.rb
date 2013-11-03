require 'test_helper'

class ItemTest < ActiveSupport::TestCase
  item = FactoryGirl.create(:item, name: "Steak", cost:26)
  user = FactoryGirl.create(:user, name: "Paula", id:25)
  user_two = FactoryGirl.create(:user, name: "Joe", id:23)

  test "create group" do
    assert_equal Item.new.class, item.class, "This is not an item"
	assert_equal "Steak", item.name, "The item name is not being set"
	assert_equal BigDecimal.new("26"), item.cost, "The item cost is not being set"
  end

  test "add user" do
    assert (not item.includes_user?(user)), "The user should not be added yet"
    assert_equal 0, item.count_users, "There should be zero users"

    assert item.add_user(user), "Add User Should return True"
    assert_equal 1, item.count_users, "There should be one user"
    assert (item.includes_user?(user)), "The user should be added"
  end

  test "remove user" do
    assert (not item.includes_user?(user)), "The user should not be added yet"
    assert item.add_user(user), "Add User Should return True"
    assert (item.includes_user?(user)), "The user should be added" 
    assert_equal 1, item.count_users, "There should be one user"
    item.remove_user(user)
    assert (not item.includes_user?(user)), "The user should not be in group"
  	assert_equal 0, item.count_users, "There should be zero users"
  end

  test "get partition" do
    assert item.add_user(user), "Add User Should return True"
    partition = item.get_partition(user) 
	assert_equal item.id, partition.item_id, "User does not eat this item"
	assert_equal user.id, partition.user_id, "User does not eat this item"
    
  end

  test "get cost" do
    assert item.add_user(user), "Add User Should return True"
    assert item.add_user(user_two)
	assert_equal 13, item.user_cost, "Cost does not meet expected"
    
  end



  
end
