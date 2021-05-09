module LnNodePicker
  class GetOneMlNode

    URL = "https://1ml.com/node/:pub_key/json".freeze

    def self.call(node)
      url = URL.gsub(":pub_key", node.pub_key)
      response = Typhoeus.get(url)
      json = response.body
      parsed_json = JSON.parse(json)
      OneMlNode.new(parsed_json)
    end

  end
end
