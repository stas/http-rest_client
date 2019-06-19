module HTTP
  module RestClient
    # Client default response exception class.
    class ResponseError < StandardError
      # Error additional data
      #
      # @return [Hash]
      attr_reader :response_data

      # Class constructor
      #
      # @param message [String] the error details
      # @param data [Hash] the error data
      #
      # @return [ResponseError] instance
      def initialize(message, data)
        super(message)
        @response_data = data.as_json if data
      end
    end
  end
end
