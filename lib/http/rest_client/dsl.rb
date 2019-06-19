require 'base64'
require 'http'
require 'http/rest_client/response_error'

module HTTP
  module RestClient
    # Client DSL, mostly inpired from Nestful and HTTP::Chainable APIs.
    module DSL
      # Copy/alias over some methods.
      define_method :auth, Chainable.instance_method(:auth)
      define_method :basic_auth, Chainable.instance_method(:basic_auth)

      # Updates the client headers
      #
      # @param header [Hash] a dictionary to assign as a header.
      # @return [Hash]
      def headers(header = nil)
        if header.is_a?(Hash)
          @headers ||= {}
          @headers.merge!(header)
        end

        return @headers if @headers

        superclass.respond_to?(:headers) ? superclass.headers : nil
      end

      # Defines the client endpoint. Inheritable-safe
      #
      # @param value [String] the endpoint URI.
      # @return [String]
      def endpoint(value = nil)
        @endpoint = value if value

        return @endpoint if @endpoint

        superclass.respond_to?(:endpoint) ? superclass.endpoint : nil
      end

      # Defines the client resource path. Inheritable-safe
      #
      # @param value [String] the endpoint URI path.
      # @return [String]
      def path(value = nil)
        @path = value if value

        return @path if @path

        superclass.respond_to?(:path) ? superclass.path : nil
      end

      # Sets the client expected HTTP request content type
      #
      # @param type [String] the full mime-type name.
      # @return [Hash]
      def content_type(type)
        headers(HTTP::Headers::CONTENT_TYPE => HTTP::MimeType.normalize(type))
      end

      # Sets the client expected HTTP response media type
      #
      # @param type [String] the full mime-type name.
      # @return [Hash]
      def accept(type)
        headers(HTTP::Headers::ACCEPT => HTTP::MimeType.normalize(type))
      end

      # Parses and returns the endpoint and path full URL
      #
      # @return [URI]
      def url
        URI.parse(endpoint).join(path.to_s).to_s
      end

      # Extends the endpoint and path full URL with new parts
      #
      # @param parts [String] a list of parts to extend the base URL.
      # @return [URI]
      def uri(*parts)
        # If an absolute URI already
        return parts.first if parts.first.is_a?(URI) && parts.first.host

        joined = [url, *parts].map(&:to_s).reject(&:empty?) * '/'

        URI.parse(joined)
      end

      # Makes an HTTP request and returns a parsed response where possible
      #
      # @param verb [String] the HTTP method.
      # @param uri [URI] the HTTP URI.
      # @param options [Hash] the params/json-payload/form to include.
      # @return parsed response, can be a [String], a [Hash] or an [Array]
      def request(verb, uri, options = {})
        client = HTTP::Client.new(headers: headers)
        handle_response(client.request(verb, uri, options))
      end

      # Response handler, raises an [HTTP::RestClient::ResponseError] on errors
      #
      # @param response [HTTP::Response] object
      # @return [Hash] on parsable responses, alternatively the raw response
      def handle_response(response)
        parsed = parse_response(response)

        return parsed unless error_response?(response, parsed)

        raise ResponseError.new(extract_error(response, parsed), parsed)
      end

      # Will try to parse the response
      #
      # Will return nothing on failure.
      #
      # @param response [HTTP::Response] the server response
      #
      # @return [Object] upon success
      def parse_response(response)
        response.parse
      rescue HTTP::Error
        nil
      end

      # Extracts the error message from the response
      #
      # @param response [HTTP::Response] the server response
      # @param _parsed_response [Object] the parsed server response
      #
      # @return [String]
      def extract_error(response, _parsed_response)
        [response.status.to_s, response.body.to_str].reject(&:empty?).join(': ')
      end

      # Validate error response
      #
      # Looks at the response code by default.
      #
      # @param response [HTTP::Response] the server response
      # @param _parsed_response [Object] the parsed server response
      #
      # @return [TrueClass] if status code is not a successful standard value
      def error_response?(response, _parsed_response)
        !(200..299).cover?(response.code)
      end
    end
  end
end
