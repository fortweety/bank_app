require 'rails_helper'

RSpec.describe User, type: :model do
  context 'create user' do
    describe 'valid data' do
      it 'creates user' do
        expect { User.create_user('example@example.com', 'asdf1234') }.to change { User.all.count }.by(1)
        .and change { Account.all.count }.from(0).to(1)
      end
    end

    describe 'invalid data' do
      it 'user with this email exists' do
        user = create(:user)
        expect { User.create_user(user.email, 'asdf1234') }.not_to change { User.all.count }.from(1)
      end
    end
  end

  context 'deposite to user' do
    let(:user) { create(:user) }
    describe 'valid data' do
      it 'should deposite 555.55 to balance' do
        User.add_deposite(user.id, '555.55')
        user.account.reload
        expect(user.account.balance).to eql(BigDecimal('555.55'))
      end
    end

    describe 'invalid data' do
      it 'should not update account balance because negative amount' do
        User.add_deposite(user.id, '-555.55')
        user.account.reload
        expect(user.account.balance).to eql(BigDecimal('0'))
      end

      it 'undefined user id' do
        expect(User.add_deposite(1000, '-555.55')).to be_nil
      end
    end
  end

  context 'user transactions' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }

    before do
      User.add_deposite(user.id, '555.55')
      2.times do
        Transactions::CreateTransferService.call(
          from_id: user.id,
          to_id: another_user.id,
          amount: '100'
        )
      end
      Transactions::CreateTransferService.call(
          from_id: another_user.id,
          to_id: user.id,
          amount: '15'
        )
    end

    it 'should have 4 transactions' do
      expect(user.transactions.size).to eql(4)
    end
  end
end
