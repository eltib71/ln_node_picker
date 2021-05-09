module LnNodePicker
  class NodePolicy < BaseModel

    attribute :time_lock_delta, Types::Integer
    attribute :min_htlc, Types::String
    attribute :fee_base_msat, Types::String
    attribute :fee_rate_milli_msat, Types::String
    attribute :disabled, Types::Bool
    attribute :max_htlc_msat, Types::String
    attribute :last_update, Types::Integer

  end
end
