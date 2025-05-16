# frozen_string_literal: true

module Fitbank
  # Base error class for all Fitbank errors.
  class Error < StandardError
    attr_reader :status_code, :response_body

    def initialize(message = nil, status_code = nil, response_body = nil)
      super(message)
      @status_code = status_code
      @response_body = response_body
    end
  end

  # Raised when there are configuration issues.
  class ConfigurationError < Error; end

  # Raised when authentication fails.
  class AuthenticationError < Error; end

  # Raised when a requested resource is not found.
  class NotFoundError < Error; end

  # Raised when there are client-side errors (4xx).
  class ClientError < Error; end

  # Raised when there are server-side errors (5xx).
  class ServerError < Error; end
end
