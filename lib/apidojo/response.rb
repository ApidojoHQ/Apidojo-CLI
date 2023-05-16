# frozen_string_literal: true

module Apidojo
  class Response
    attr_reader :content_type, :status, :headers, :body

    def initialize(content_type:, status:, headers:, body:)
      @content_type = content_type
      @status = status
      @headers = headers
      @body = body
    end
  end
end
