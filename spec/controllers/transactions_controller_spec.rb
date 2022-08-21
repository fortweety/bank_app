require 'rails_helper'

RSpec.describe TransactionsController, type: :controller do
  describe 'POST #create' do
    let!(:user_from) { create(:user) }
    let!(:user_to) { create(:user) }

    context 'valid data' do
      before do
        login_user(user_from)
        user_from.account.update(balance: BigDecimal('100'))
      end

      it 'flash notice and redirect to root path' do
        post :create, params: {
          transaction: {
            to_id: user_to.id,
            amount: '15'
          }
        }
        expect(controller).to set_flash[:notice]
        expect(response).to redirect_to transaction_path(id: assigns(:transaction).transaction.id)
      end
    end


    context 'invalid data' do
      before do
        login_user(user_from)
      end

      context 'not enougth amount' do
        it "flash alert" do
          post :create, params: {
            transaction: {
              to_id: user_to.id,
              amount: '15'
            }
          }
          expect(controller).to set_flash[:alert]
        end
      end
    end

    context 'without login' do
      it "flash alert and redirect to login" do
        post :create, params: {
          transaction: {
            to_id: user_to.id,
            amount: '15'
          }
        }
        expect(controller).to set_flash[:alert]
        expect(response).to redirect_to user_session_path
      end
    end
  end
end