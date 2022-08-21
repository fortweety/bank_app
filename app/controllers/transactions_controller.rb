class TransactionsController < ApplicationController
  before_action :find_transaction, only: %i(show)

  def new
    @transaction = Transaction.new
    @users = User.where.not(id: current_user.id).pluck(:email, :id)
  end

  def create
    @transaction = Transactions::CreateTransferService.call(
      transaction_params.to_unsafe_h.merge(
        { from_id: current_user.id }
      )
    )

    if @transaction.failure?
      flash[:alert] = @transaction.errors.join(', ')
    else
      flash[:notice] = 'operation successed'
      redirect_to transaction_path(id: @transaction.transaction.id)
    end
  end

  def show; end

  private

  def find_transaction
    @transaction = Transaction.find_by(id: params[:id])
    check_permissions
  end

  def check_permissions
    unless [@transaction.from_id, @transaction.to_id].include?(current_user.account.id)
      flash[:alert] = 'permission denied'
      redirect_to root_path
    end
  end

  def transaction_params
    params.require(:transaction).permit(:to_id, :amount)
  end
end