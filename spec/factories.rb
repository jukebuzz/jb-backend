FactoryGirl.define do
  factory :user do
    uid { Faker::Number.number(10) }
    name { Faker::Name.name }
    nickname { Faker::Internet.user_name }
    email { Faker::Internet.email }
    active_room nil
  end

  factory :room do
    name { Faker::Internet.domain_word }
    association :owner, factory: :user

    factory :room_with_members do
      transient do
        members_count 5
      end

      after :create do |room, evaluator|
        room.users << create_list(:user, evaluator.members_count, active_room: room)
      end
    end
  end

  factory :membership do
    user
    room
  end
end
