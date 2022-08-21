class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :account

  before_create :set_up_account

  validates :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  def self.create_user(email, password)
    user = User.new(email: email, password: password)
    user.save
  end

  def self.add_deposite(user_id, amount)
    transaction = Transactions::CreateDepositeService.call(
      amount: amount,
      to_id: user_id,
      from_id: user_id
    )
    puts transaction.errors if transaction.failure?
  end

  def set_up_account
    self.account = Account.new
  end

  def transactions
    Transaction.includes(from: :user, to: :user)
      .where('from_id = :id or to_id = :id', { id: id })
      .order(created_at: :desc)
  end
end
