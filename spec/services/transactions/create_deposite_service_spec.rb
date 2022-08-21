RSpec.describe Transactions::CreateDepositeService do
  subject { described_class }

  let(:user) { create(:user) }

  let(:params) do
    {
      from_id: user.id,
      to_id: user.id,
      amount: '100'
    }
  end

  context 'valid params' do
    it 'should update user balance' do
      expect { subject.call(params) }
        .to change { Account.find_by(user_id: user.id).balance }.from(BigDecimal('0')).to(BigDecimal('100'))
        .and change { Transaction.where(variety: 'deposite').count }.from(0).to(1)
    end

    it 'should errors be empty on return' do
      result = subject.call(params)

      expect(result.failure?).to be_falsey
      expect(result.transaction).to be_kind_of(Transaction)
      expect(result.transaction.variety).to eql('deposite')
    end
  end

  context 'invalid params' do
    it 'not create transaction on wrong params' do
      expect { subject.call({}) }
        .not_to change { Transaction.where(variety: 'deposite').size }.from(0)
    end
  end
end
