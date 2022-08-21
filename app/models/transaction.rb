class Transaction < ApplicationRecord
  belongs_to :from, :class_name => 'Account', :foreign_key => :from_id
  belongs_to :to, :class_name => 'Account', :foreign_key => :to_id

  TYPES_ALLOWED = %w(deposite transfer)

  validates_presence_of :to_id, :from_id, :amount, :variety
  validates :variety, inclusion: { in: TYPES_ALLOWED }
  validates :amount, numericality: { greater_than: 0 }

end
