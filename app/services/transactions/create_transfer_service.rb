class Transactions::CreateTransferService < Transactions::BasicService
  def initialize(params)
    super
    @variety = 'transfer'
  end

  attr_reader :transaction

  def call
    return self if self.failure?
    ActiveRecord::Base.transaction do
      create_transaction
      transfer_money
    end
    self
  end

  private

  def create_transaction
    @transaction = ::Transaction.new(
      from_id: @from.account.id,
      to_id: @to.account.id,
      amount: @amount,
      variety: @variety
    )
    fail_and_rollback_transaction!(@transaction.errors) unless @transaction.save
  end

  def transfer_money
    @account_from = @from.account
    @account_from.lock!
    @account_to = @to.account
    @account_to.lock!
    fail_and_rollback_transaction!('sender has not enougth money for this transaction') unless sender_balance_valid?
    @account_from.balance -= @amount
    fail_and_rollback_transaction!(@account_from.errors) unless @account_from.save
    @account_to.balance += @amount
    fail_and_rollback_transaction!(@account_to.errors) unless @account_to.save
  end

  def sender_balance_valid?
    (BigDecimal(@account_from.balance) - @amount) >= BigDecimal('0')
  end
end