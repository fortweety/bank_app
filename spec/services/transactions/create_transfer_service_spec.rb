RSpec.describe Transactions::CreateTransferService do
  subject { described_class }

  let(:user_from) { create(:user) }
  let(:user_to) { create(:user) }

  let(:params) do
    {
      from_id: user_from.id,
      to_id: user_to.id,
      amount: '100'
    }
  end

  context 'valid params' do
    before do
      user_from.account.update(balance: BigDecimal('100'))
    end

    it 'should update user balance' do
      expect { subject.call(params) }
        .to change { Account.find_by(user_id: user_to.id).balance }.from(BigDecimal('0')).to(BigDecimal('100'))
        .and change { Account.find_by(user_id: user_from.id).balance }.from(BigDecimal('100')).to(BigDecimal('0'))
        .and change { Transaction.where(variety: 'transfer').count }.from(0).to(1)
    end

    it 'should errors be empty on return' do
      result = subject.call(params)

      expect(result.failure?).to be_falsey
      expect(result.transaction).to be_kind_of(Transaction)
      expect(result.transaction.variety).to eql('transfer')
    end
  end

  context 'invalid params' do
    it 'not create transaction on wrong params' do
      expect { subject.call({}) }
        .not_to change { Transaction.where(variety: 'transfer').size }.from(0)
    end
  end
end
