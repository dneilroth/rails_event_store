module RubyEventStore
  module Browser
    class Routing
      def initialize(host, root_path)
        @host = host
        @root_path = root_path
      end

      def paginated_events_from_stream_url(id:, position: nil, direction: nil, count: nil)
        base = [host, root_path].join
        args = [position, direction, count].compact
        stream_name = Rack::Utils.escape(id)

        if args.empty?
          "#{base}/streams/#{stream_name}/relationships/events"
        else
          "#{base}/streams/#{stream_name}/relationships/events/#{args.join('/')}"
        end
      end

      private
      attr_reader :host, :root_path
    end
  end
end
