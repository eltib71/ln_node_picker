module LnNodePicker
  module LowFeeRoutingDiversity
    class RunCommand

      extend LightService::Action
      expects :cmd, :channel_graph
      promises :result

      executed do |c|
        cmd = c.cmd

        stdout_str, stderr_str, status = Open3.capture3(cmd, {
          stdin_data: c.channel_graph,
        })

        c.result = stdout_str

        next c if status.success?

        c.fail_and_return! "Unable to run `#{cmd}`: #{stderr_str}. " \
          "Have you installed required libraries? " \
          "If not, you might need to run `pip3 install PyMaxflow mpmath`"
      end

    end
  end
end
