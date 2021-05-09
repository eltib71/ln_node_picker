module LnNodePicker
  class OneMlNode < BaseModel

    attribute :last_update, Types::Integer
    attribute :pub_key, Types::String
    attribute :alias, Types::String
    attribute :addresses, Types::Array do
      attribute :network, Types::String
      attribute :addr, Types::String
    end
    attribute :color, Types::String
    attribute :capacity, Types::Integer
    attribute :channelcount, Types::Integer
    attribute :noderank do
      attribute :capacity, Types::Integer
      attribute :channelcount, Types::Integer
      attribute :age, Types::Integer
      attribute :growth, Types::Integer
      attribute :availability, Types::Integer
    end

  end
end
