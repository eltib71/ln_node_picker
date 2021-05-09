require "thor"

module LnNodePicker
  class CLI < Thor

    NODE_RECOMMENDER_PATH = Pathname.new(File.dirname(__FILE__)).
      join("vendor/ajpwahqgbi/lightning-tools/channel-analysis").
      join("node-recommender/node_recommender.py").freeze

    desc(
      "low_fee_routing_diversity NODE_ID",
      "Analyze network using https://github.com/ajpwahqgbi/lightning-tools/ " \
        "to for recommended nodes using low-fee routing diversity strategy. " \
        "Output: stdout. " \
        "Requires python3, pip3, and PyMaxflow mpmath installed."
    )
    option(:channel_graph_file, {
      desc: "JSON file output of `lncli describegraph`",
      required: true,
    })
    option(:base_fee, {
      desc: "The maximum base fee (in milisatoshi) accumulated along a " \
        'route to remain "low-fee reachable"',
      type: :numeric,
      required: true,
    })
    option(:per_million_fee, {
      desc: "The maximum per-million fee accumulated along a route to " \
        'remain "low-fee reachable"',
      type: :numeric,
      required: true,
    })
    option(:min_channels, {
      desc: "The minimum number of channels a node must have to consider " \
        "peering with it",
      type: :numeric,
      default: 10,
    })
    option(:min_capacity, {
      desc: "min_capacity: The minimum total capacity a node (in satoshi) " \
        "must have to consider peering with it. Unrelated to the capacity " \
        "of channels along a route.",
      type: :numeric,
      default: 15_000_000,
    })
    def low_fee_routing_diversity(node_id)
      channel_graph_file = options[:channel_graph_file]
      base_fee = options[:base_fee]
      per_million_fee = options[:per_million_fee]
      min_channels = options[:min_channels]
      min_capacity = options[:min_capacity]

      cmd = [
        "python3",
        NODE_RECOMMENDER_PATH,
        node_id,
        base_fee,
        per_million_fee,
        min_channels,
        min_capacity,
      ].join(" ")

      json = File.read(channel_graph_file)
      stdout_str, stderr_str, status = Open3.capture3(cmd, stdin_data: json)

      parsed_json = JSON.parse(json)

      if status.success?
        puts stderr_str
      else
        puts "Unable to run #{cmd}: #{stderr_str}. " \
          "Have you installed required libraries? " \
          "Run `pip3 install PyMaxflow mpmath`"
      end
    end

    desc(
      "calculate pleb node score of NODE_ID",
      "Puts a scoring mechanism using @beeforbacon1's tips found in " \
        "https://www.youtube.com/watch?v=qnj-ix45tVw. " \
        "Since this is not a relative score, but a 1 to 10 where 1 is " \
        "'a solid pleb node', and 10 the 'least pleb'"
    )
    option(:channel_graph_file, {
      desc: "JSON file output of `lncli describegraph`",
      required: true,
    })
    def pleb_score(node_id)
      channel_graph_file = options[:channel_graph_file]
      json = File.read(channel_graph_file)
      parsed_json = JSON.parse(json)
      graph = Graph.new(parsed_json)
      node = graph.nodes.find{|n| n.pub_key == node_id}

      fail "Unable to find node #{node_id}" if node.nil?

      pleb_scorer = PlebScorer.new(node: node)
      puts pleb_scorer.score
    end

  end
end
