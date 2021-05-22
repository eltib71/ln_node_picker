module LnNodePicker
  class GenLowFeeRoutingDiversity

    extend LightService::Organizer

    def self.call(
      node_id:,
      channel_graph:,
      base_fee:,
      per_million_fee:,
      min_channels:,
      min_capacity:
    )
      with(
        node_id: node_id,
        channel_graph: channel_graph,
        base_fee: base_fee,
        per_million_fee: per_million_fee,
        min_channels: min_channels,
        min_capacity: min_capacity,
      ).reduce(actions)
    end

    def self.actions
      [
        LowFeeRoutingDiversity::BuildCommand,
        LowFeeRoutingDiversity::RunCommand,
      ]
    end

  end
end
