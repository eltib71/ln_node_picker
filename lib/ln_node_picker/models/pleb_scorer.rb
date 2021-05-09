module LnNodePicker
  class PlebScorer < BaseModel

    attribute :node, Node

    NODE_CAPACITY_MIN = 30_000_000
    NODE_CAPACITY_MAX = 500_000_000

    CHANNEL_CAPACITY_MIN = 500_000

    # Not exactly maximum, since bigger is better, but this number and above
    # is perfect
    CHANNEL_CAPACITY_MAX = 8_000_000

    def score
      arr = [
        availability,
        node_capacity,
        channel_capacity,
        channel_fee,
      ]
      arr.sum.to_f / arr.count
    end

    # < 1000 ok, < 500 really good
    def availability
      n = node.one_ml_rank.availability
      (10 * n.to_f / 1000).ceil
    end

    # 20 channels and 1.1 btc capacity == solid pleb node
    # So let's not get too big or else they're not pleb
    # Not too small (guessing this number); they might be
    # a pleb but they're not solid
    def node_capacity
      n = node.one_ml_node.capacity
      return 10 if n < NODE_CAPACITY_MIN
      return 10 if n > NODE_CAPACITY_MAX

      mid = (NODE_CAPACITY_MIN + NODE_CAPACITY_MAX) / 2.0
      max_distance = mid - NODE_CAPACITY_MIN
      distance = n - mid

      # The farther away the capacity devites from the middle,
      # the lower the score gets
      10 * (distance / max_distance)
    end

    # avoid nodes with many channels w/ low capacity
    # (he mentioned 300k sats, so I'll raise it a bit)
    def channel_capacity
      average_channel_capacity =
        node.one_ml_node.capacity / node.one_ml_node.channelcount.to_f

      return 10 if average_channel_capacity < CHANNEL_CAPACITY_MIN
      return 1 if average_channel_capacity > CHANNEL_CAPACITY_MAX

      max_distance = CHANNEL_CAPACITY_MAX - CHANNEL_CAPACITY_MIN
      distance = CHANNEL_CAPACITY_MAX - average_channel_capacity

      (10.0 * distance / max_distance).ceil
    end

    # 0.0005 fee rate per sat he said was expensive
    # but "okay"
    #
    # If fees are "too high", low score
    # If fees are "low", high score
    def channel_fee
      1
    end

  end
end
