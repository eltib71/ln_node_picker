module LnNodePicker
  module NodeRecommender
    class MetricSet < BaseModel

      attribute :root_node_metrics, NodeRecommender::RootNodeMetricSet
      attribute :peer_metrics, Types::Array.of(NodeRecommender::PeerMetricSet)

    end
  end
end
