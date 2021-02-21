# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  name                   :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  username               :string           default(""), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe '#username' do
    it {
      expect(subject).to validate_length_of(:username)
        .is_at_most(20)
        #.with_message(I18n.t('activerecord.errors.models.user.attributes.username.too_long', count: 15))
    }

    it {
      expect(subject).to validate_length_of(:username)
        .is_at_least(4)
        #.with_message(I18n.t('activerecord.errors.models.user.attributes.username.too_short', count: 4))
    }

    it {
      expect(user).to validate_uniqueness_of(:username)
        .case_insensitive
        #.with_message(I18n.t('activerecord.errors.models.user.attributes.username.taken'))
    }

    it {
      expect(subject).to allow_values(
        'user_1', 'u12345', '__user_2', 'USERNAME', 'USeR_NaM3', '_Us3rN4M3__'
      ).for(:username)
    }

    it {
      expect(subject).not_to allow_value('123456').for(:username)
                                                  .with_message(I18n.t('activerecord.errors.models.user.attributes.username.numeric_only'))
    }

    it {
      expect(subject).not_to allow_values(
        'user!', 'use#rn4m3', '#user', '!$%*()', 'user@',
        'user!name', 'user name', 'user-name', 'user12@'
      )
        .for(:username)
        .with_message(I18n.t('activerecord.errors.models.user.attributes.username.invalid'))
    }
  end

  describe '#name' do
    it {
      expect(subject).to validate_presence_of(:name)
        #.with_message(I18n.t('activerecord.errors.models.user.attributes.name.blank', attribute: 'Name'))
    }

    it {
      expect(subject).to validate_length_of(:name)
        .is_at_most(50)
        #.with_message(I18n.t('activerecord.errors.models.user.attributes.name.too_long', count: 50))
    }
  end
end