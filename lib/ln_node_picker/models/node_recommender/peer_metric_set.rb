module LnNodePicker
  module NodeRecommender
    class PeerMetricSet < BaseModel

      attribute :peer_alias, Types::String
      attribute :peer_score, Types::Integer
      attribute :peer_id, Types::String
      attribute :root_node_id, Types::String
      attribute :newly_reachable, Types::Integer
      attribute :routability_improvements, Types::Integer
      attribute :bonus, Types::Integer
      attribute :new_maxflow_geomean, Types::Coercible::Decimal
      attribute :new_shortest_path_geomean, Types::Coercible::Decimal
      attribute :new_cheapest_ppm_geomean, Types::Coercible::Decimal
      attribute? :warnings, Types::String

    end
  end
end
