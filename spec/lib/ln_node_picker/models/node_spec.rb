require "spec_helper"


module LnNodePicker
  RSpec.describe Node do

    let(:data) do
      {
        last_update: 1614206449,
        pub_key: "0200072fd301cb4a680f26d87c28b705ccd6a1d5b00f1b5efd7fe5f998f1bbb1f1",
        alias: "OutaSpace 🚀",
        addresses: [
          {
            network: "tcp",
            addr: "176.28.11.68:9760"
          },
          {
            network: "tcp",
            addr: "2dkobxxunnjatyph.onion:9760"
          },
          {
            network: "tcp",
            addr: "nzslu33ecbokyn32teza2peiiiuye43ftom7jvnuhsxdbg3vhw7w3aqd.onion:9760"
          }
        ],
        color: "#123456",
        features: {
          "1" => {
            name: "data-loss-protect",
            is_required: false,
            is_known: true
          }
        }
      }
    end
    let(:node) { described_class.new(data) }

    describe ".new" do
      it "assigns attributes" do
        expect(node.last_update).to eq 1614206449
      end
    end

    describe "#last_update_at" do
      it "is the Time version of #last_update" do
        expect(node.last_update_at).to eq Time.at(1614206449)
      end
    end

  end
end
