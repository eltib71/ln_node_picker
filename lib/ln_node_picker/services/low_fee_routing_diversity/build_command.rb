module LnNodePicker
  module LowFeeRoutingDiversity
    class BuildCommand

      NODE_RECOMMENDER_PATH = Pathname.new(File.dirname(__FILE__)).
        join("../../vendor/ajpwahqgbi/node_recommender.py").freeze

      extend LightService::Action
      expects(
        :node_id,
        :channel_graph,
        :base_fee,
        :per_million_fee,
        :min_channels,
        :min_capacity,
      )
      promises :cmd

      executed do |c|
        c.cmd = [
          "python3",
          NODE_RECOMMENDER_PATH,
          c.node_id,
          c.base_fee,
          c.per_million_fee,
          c.min_channels,
          c.min_capacity,
        ].join(" ")
      end

    end
  end
end
