require "spec_helper"


module LnNodePicker
  RSpec.describe Node do

    let(:data) do
      {
        channel_id: "748416674416820224",
        chan_point: "11ca2de07c87b512e8db9f85bcaf25ad2bfac00229428671f4e9a5eb18e6240e:0",
        last_update: 1619431991,
        node1_pub: "03c2abfa93eacec04721c019644584424aab2ba4dff3ac9bdab4e9c97007491dda",
        node2_pub: "03cc9b3662e38304667d9096a15908b2341cf23591854b82c214624f4d1f19f8e3",
        capacity: "2000000",
        node1_policy: {
          time_lock_delta: 40,
          min_htlc: "1000",
          fee_base_msat: "1000",
          fee_rate_milli_msat: "1",
          disabled: false,
          max_htlc_msat: "1980000000",
          last_update: 1619431988
        },
        node2_policy: {
          time_lock_delta: 40,
          min_htlc: "1000",
          fee_base_msat: "1000",
          fee_rate_milli_msat: "1",
          disabled: false,
          max_htlc_msat: "1980000000",
          last_update: 1619431991
        }
      }
    end
    let(:edge) { described_class.new(data) }

    describe ".new" do
      it "assigns attributes" do
        expect(edge.channel_id).to eq "748416674416820224"
      end
    end

    # describe "#last_update_at" do
    #   it "is the Time version of #last_update" do
    #     expect(node.last_update_at).to eq Time.at(1614206449)
    #   end
    # end

  end
end
