module HTTP
  module RestClient
    # Create/Read/Update/Delete helpers.
    module CRUD
      # Resource collection finder, uses the default limit
      #
      # @param params [Hash] URI parameters to pass to the endpoint.
      # @return [Array] of [Object] instances
      def all(params = {})
        objectify(request(:get, uri, params: params))
      end

      # Resource finder
      #
      # @param id [String] resource indentifier
      # @param params [Hash] URI parameters to pass to the endpoint.
      # @return [Object] instance
      def find(id, params = {})
        objectify(request(:get, uri(id), params: params))
      end

      # Resource deletion handler
      #
      # @param id [String] resource indentifier
      # @return [Object] instance
      def delete(id)
        objectify(request(:delete, uri(id)))
      end

      # Resource creation helper
      #
      # @param params [Hash] request parameters to pass to the endpoint as JSON.
      # @return [Object] instance
      def create(params = {})
        objectify(request(:post, uri, json: params))
      end

      # Resource update helper
      #
      # @param id [String] resource indentifier
      # @param params [Hash] request parameters to pass to the endpoint as JSON.
      # @return [Object] instance
      def update(id, params = {})
        objectify(request(:patch, uri(id), json: params))
      end

      private

      # Resource constructor wrapper
      #
      # @param payload [Hash] response payload to build a resource.
      # @return [Object] instance or a list of instances.
      def objectify(payload)
        if payload.is_a?(Array)
          payload.map { |data| new(data) }
        elsif payload.is_a?(Hash)
          new(payload)
        else
          payload
        end
      end
    end
  end
end
