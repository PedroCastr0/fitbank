# frozen_string_literal: true

require "net/http"
require "json"
require "uri"
require "time"
require "base64"

require_relative "fitbank/version"
require_relative "fitbank/error"
require_relative "fitbank/configuration"
require_relative "fitbank/client"
require_relative "fitbank/resources/base_resource"
require_relative "fitbank/resources/account"
require_relative "fitbank/resources/pix"
require_relative "fitbank/resources/boleto"

# Main module for the Fitbank gem.
module Fitbank
  class << self
    attr_writer :configuration

    # Provides access to the configuration instance.
    # Initializes a default configuration if none exists.
    def configuration
      @configuration ||= Configuration.new
    end

    # Allows configuration via a block.
    # Example:
    # Fitbank.configure do |config|
    #   config.api_key = 'your_api_key'
    #   config.secret_key = 'your_secret_key'
    #   config.environment = :sandbox
    # end
    def configure
      yield(configuration)
    end

    # Resets the configuration to defaults. Useful for testing.
    def reset_configuration!
      @configuration = Configuration.new
    end

    # Creates a new Fitbank client instance with the current configuration.
    # Optionally accepts overrides for configuration parameters.
    # @param options [Hash] Configuration overrides (api_key, secret_key, environment, timeout, open_timeout)
    # @return [Fitbank::Client] An instance of the Fitbank client.
    def client(options = {})
      config = configuration.dup # Start with global config
      options.each do |key, value|
        config.send("#{key}=", value) if config.respond_to?("#{key}=")
      end
      Client.new(config)
    end
  end
end
