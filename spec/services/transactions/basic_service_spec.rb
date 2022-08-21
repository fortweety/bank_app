RSpec.describe Transactions::BasicService do
  subject { described_class }

  let(:user) { create(:user) }

  let(:params) do
    {
      from_id: user.id,
      to_id: user.id,
      amount: '100'
    }
  end

  let(:invalid_params) do
    {
      from_id: User.last&.id || 1000,
      to_id: User.last&.id || 1000,
      amount: '-100'
    }
  end

  context 'valid params' do
    it 'should errors be empty on return' do
      result = subject.call(params)

      expect(result.failure?).to be_falsey
    end
  end

  context 'invalid params' do
    describe 'required params missing' do
      it 'empty params' do
        result = subject.call({})
        expect(result.failure?).to be_truthy
        expect(result.errors).to include(
          'missed required params: from_id,to_id,amount'
        )
      end

      it 'un exsisting users and not positive value for amount' do
        result = subject.call(invalid_params)
        expect(result.failure?).to be_truthy
        expect(result.errors).to include(
          "user from 1000 unexist",
          "user to 1000 unexist",
          "amount must be positive and bigger that 0"
        )
      end

      it 'wrong type for amount' do
        wrong_type_params = invalid_params.clone
        wrong_type_params[:from_id] = user.id
        wrong_type_params[:to_id] = user.id
        wrong_type_params[:amount] = 45.55

        result = subject.call(wrong_type_params)
        expect(result.failure?).to be_truthy
        expect(result.errors).to include(
          "wrong type/format of amount"
        )
      end
    end
  end
end