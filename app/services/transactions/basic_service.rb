class Transactions::BasicService
  def self.call(*params)
    new(*params).call
  end

  def initialize(params)
    @errors = []
    params = params || {}
    validate(params)
  end

  attr_reader :errors

  def failure?
    @errors.any?
  end

  def call
    self
  end

  private

  def validate(params)
    return if validate_params_presence(params)
    validate_params_correct_type(params)
  end

  def validate_params_presence(params)
    @missed_required_fields = %w(from_id to_id amount) - params.keys.map(&:to_s)
    fail!("missed required params: #{@missed_required_fields.join(',')}") && true if @missed_required_fields.present?
  end

  def validate_params_correct_type(params)
    set_required_params(params)
    fail!("user from #{params[:from_id]} unexist") unless @from.present?
    fail!("user to #{params[:to_id]} unexist") unless @to.present?
    fail!('wrong type/format of amount') && return unless @amount
    fail!('amount must be positive and bigger that 0') if @amount <= BigDecimal(0)
  end

  def set_required_params(params)
    @from ||= User.preload(:account).find_by(id: params[:from_id])
    @to ||= User.preload(:account).find_by(id: params[:to_id])
    @amount ||= BigDecimal(params[:amount]) rescue nil
  end

  def fail!(messages)
    @errors += Array(messages)
  end

  def fail_and_rollback_transaction!(errors)
    fail!(errors)
    raise ActiveRecord::Rollback
  end
end