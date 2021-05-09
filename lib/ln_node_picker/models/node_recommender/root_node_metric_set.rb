module LnNodePicker
  module NodeRecommender
    class RootNodeMetricSet < BaseModel

      attribute :root_node_id, Types::String
      attribute :existing_reachable, Types::Integer
      attribute :existing_maxflow_geomean, Types::Coercible::Decimal
      attribute :existing_shortest_path_geomean, Types::Coercible::Decimal
      attribute :existing_cheapest_ppm_geomean, Types::Coercible::Decimal

    end
  end
end
