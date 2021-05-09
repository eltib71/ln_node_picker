module LnNodePicker
  class Graph < BaseModel

    attribute? :created_at, Types::Time
    attribute :nodes, Types::Array.of(Node)
    attribute :edges, Types::Array.of(Edge)

  end
end
