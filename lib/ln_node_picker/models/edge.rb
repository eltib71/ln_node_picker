module LnNodePicker
  class Edge < BaseModel

    attribute :channel_id, Types::String
    attribute :chan_point, Types::String
    attribute :last_update, Types::Integer
    attribute :node1_pub, Types::String
    attribute :node2_pub, Types::String
    attribute :capacity, Types::String
    attribute :node1_policy, NodePolicy.optional
    attribute :node2_policy, NodePolicy.optional

  end
end
