FactoryGirl.define do
  sequence :user_name do |n|
    "User #{n}"
  end

  factory :user, aliases: [:owner] do |user|
    name { generate(:user_name) }
    email { "#{name.gsub(" ", "-")}@example.com" } 
    password "abcd1234"
    password_confirmation "abcd1234"
  end

  sequance :group_name do |n|
    "Group #{n}"
  end

  factory :group do |group|
    owner

    name { generate(:group_name) }
  end

  sequence :item_name do |n|
    "Item #{n}"
  end

  factory :item do
    group

    name { generate(:item_name) }
    cost "25.50"
  end

  factory :user_item do
    user
    item
  end

  factory :group_user do
    group
    user

    payment "10.25"
  end
end