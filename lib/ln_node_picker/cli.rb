require "thor"
require "fileutils"

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
      desc: "JSON file output of `lncli describegraph`. " \
        "You can pass /path/to/*.json to process all matching JSON files. " \
        "If processing multiple files, better to use with `--output-dir`",
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
    option(:output_dir, {
      desc: "Directory in which to write the output JSON. If file already " \
        "exists in that directly, it will be skipped.",
    })
    def low_fee_routing_diversity(node_id)
      channel_graph_files = Dir[options[:channel_graph_file]]
      base_fee = options[:base_fee]
      per_million_fee = options[:per_million_fee]
      min_channels = options[:min_channels]
      min_capacity = options[:min_capacity]
      output_dir = options[:output_dir]

      channel_graph_files.each do |channel_graph_file|
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

        if !status.success?
          fail "Unable to run #{cmd}: #{stderr_str}. " \
            "Have you installed required libraries? " \
            "Run `pip3 install PyMaxflow mpmath`"
        end

        if output_dir.nil?
          puts stderr_str
          return
        end

        FileUtils.mkdir_p(output_dir)

        output_filename = {
          node_id: node_id,
          base_fee: base_fee,
          per_million_fee: per_million_fee,
          min_channels: min_channels,
          min_capacity: min_capacity,
        }.each_with_object([]) do |(k, v), arr|
          arr << [k, v].join("-")
        end.join("_") + ".json"

        output_file_path = Pathname.new(output_dir).join(output_filename)
        File.write(output_file_path, stderr_str)
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

    desc(
      "calculate pleb node scores of node_recommender output",
      "uses `pleb_score` on the output of node_recommender for the top " \
      "NODE_COUNT nodes with the highest peer_score."
    )
    option(:channel_graph_file, {
      desc: "JSON file output of `lncli describegraph`",
      required: true,
    })
    option(:node_recommender_file, {
      desc: "JSON file output of low_fee_routing_diversity. If provided, " \
        "the top 10 nodes will be fetched and its scores returned",
      required: true,
    })
    option(:node_count, {
      desc: "Number of nodes to get a score for",
      default: 10,
    })
    def low_fee_routing_diversity_pleb_scores
      channel_graph_file = options[:channel_graph_file]
      node_recommender_file = options[:node_recommender_file]
      node_count = options[:node_count]

      channel_graph_file_json = File.read(channel_graph_file)
      channel_graph_file_parsed_json = JSON.parse(channel_graph_file_json)

      node_recommender_file_json = File.read(node_recommender_file)
      node_recommender_file_parsed_json = JSON.parse(node_recommender_file_json)

      metric_set = NodeRecommender::MetricSet.
        new(node_recommender_file_parsed_json)

      graph = Graph.new(channel_graph_file_parsed_json)

      peer_metrics = metric_set.peer_metrics.sort_by { |m| -m.peer_score }
      peer_metrics = peer_metrics[0..node_count]

      hash = peer_metrics.each_with_object({}) do |pm, hash|
        node = graph.nodes.find{|n| n.pub_key == pm.peer_id}
        pleb_scorer = PlebScorer.new(node: node)
        hash[node.pub_key] = pleb_scorer.score
      end.sort_by { |k, v| -v }

      puts hash.to_json
    end

  end
end
