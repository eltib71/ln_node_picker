module LnNodePicker
  class Node < BaseModel

    attribute :last_update, Types::Integer
    attribute :pub_key, Types::String
    attribute :alias, Types::String
    attribute :addresses, Types::Array do
      attribute :network, Types::String
      attribute :addr, Types::String
    end
    attribute :color, Types::String
    attribute :features, Types::Hash

    def last_update_at
      Time.at(last_update)
    end

    def one_ml_node
      @one_ml_node ||= GetOneMlNode.(self)
    end

    def one_ml_rank
      one_ml_node.noderank
    end

  end
end
