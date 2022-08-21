class Transactions::CreateDepositeService < Transactions::BasicService
  def initialize(params)
    super
    @variety = 'deposite'
  end

  attr_reader :transaction

  def call
    return self if self.failure?
    ActiveRecord::Base.transaction do
      create_transaction
      update_accout_info
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

  def update_accout_info
    @account = @to.account
    @account.lock!
    @account.balance = BigDecimal(@account.balance) + @amount
    fail_and_rollback_transaction!(@account.errors) unless @account.save
  end
end