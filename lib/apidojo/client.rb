# frozen_string_literal: true

module Apidojo
  class Client
    attr_reader :response

    def configure!
      @conn = Faraday.new(
        url: 'https://apidojo.com',
        headers: {
          'Accept' => 'application/json',
          'Content-Type': 'application/json',
          'X-Apidojo-User-Token' => ENV['APIDOJO_USER_TOKEN']
        }
      )
    end

    def query(verb:, rack_request:)
      res = @conn.get(
        'cli/query',
        {
          dev_host: rack_request.server_name,
          port: rack_request.port,
          verb: verb.upcase,
          path: Base64.encode64(rack_request.path)
        }
      )

      decoded_res = decode_response_payload(JSON.parse(res.body))

      @response = Response.new(
        content_type: decoded_res[:content_type],
        status: decoded_res[:status],
        headers: decoded_res[:headers],
        body: decoded_res[:body]
      )

      self
    end

    def sync
      res = @conn.get('cli/sync')

      @response = Response.new(
        content_type: 'application/json',
        headers: {},
        status: res.status,
        body: JSON.parse(res.body)
      )

      self
    end

    def ping_platform
      res = @conn.get('cli/ping')

      @response = Response.new(
        content_type: 'application/json',
        headers: {},
        status: res.status,
        body: JSON.parse(res.body)
      )

      self
    end

    def decode_response_payload(res_payload)
      {
        content_type: http_content_type(res_payload['content_type']),
        status: res_payload['status'],
        headers: Base64.decode64(res_payload['headers']),
        body: Base64.decode64(res_payload['body'])
      }
    end

    def http_content_type(raw_content_type = 'JSON')
      case raw_content_type.downcase
      when 'json' then 'application/json'
      when 'xml' then 'application/xml'
      when 'text' then 'plain/text'
      else
        'application/json'
      end
    end
  end
end
