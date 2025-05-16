# frozen_string_literal: true

module Fitbank
  module Resources
    # Base class for all Fitbank resources.
    class BaseResource
      attr_reader :client

      # @param client [Fitbank::Client] The client instance.
      def initialize(client)
        @client = client
      end

      private

      # Makes a request to the Fitbank API.
      # @param method [Symbol] The HTTP method.
      # @param path [String] The API path.
      # @param params [Hash] Query parameters.
      # @param body [Hash] Request body.
      # @return [Hash] The response body.
      def request(method:, path:, params: {}, body: nil)
        client.request(method: method, path: path, params: params, body: body)
      end

      def validate_required_params(params, required_keys)
        missing_keys = required_keys.map(&:to_sym) - params.keys.map(&:to_sym)
        return if missing_keys.empty?

        raise ArgumentError, "Missing required parameters: #{missing_keys.join(", ")}"
      end

      # Helper method to convert hash keys to camelCase recursively.
      def convert_keys_to_camel_case(value)
        case value
        when Array
          value.map { |v| convert_keys_to_camel_case(v) }
        when Hash
          Hash[value.map { |k, v| [camel_case_key(k.to_s), convert_keys_to_camel_case(v)] }]
        else
          value
        end
      end

      def camel_case_key(snake_case_string)
        return "mktPlaceId" if snake_case_string == "mkt_place_id"
        parts = snake_case_string.split('_')
        return parts.first if parts.length == 1
        parts.first + parts[1..].map(&:capitalize).join
      end
    end
  end
end

