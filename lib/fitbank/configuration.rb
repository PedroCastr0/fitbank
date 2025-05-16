# frozen_string_literal: true

require "uri"

module Fitbank
  # Configuration class for the Fitbank gem.
  class Configuration
    attr_accessor :api_key, :secret_key, :environment, :timeout, :open_timeout

    # Initializes a new Configuration instance with default values.
    def initialize
      @api_key = nil
      @secret_key = nil
      @environment = :sandbox
      @timeout = 30
      @open_timeout = 5
    end

    # Returns the base URI for the API based on the environment.
    # @return [URI] The base URI for the API.
    def base_uri
      case environment
      when :sandbox
        URI("https://sandboxapi.fitbank.com.br/main/execute")
      when :production
        URI("https://apiv2.fitbank.com.br/main/execute")
      else
        raise ArgumentError, "Invalid environment: #{environment}"
      end
    end
  end
end
