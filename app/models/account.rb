class Account < ApplicationRecord
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
