require 'faraday'
require 'faraday_middleware'
require 'json'

module Cortera
  class Error < StandardError
    attr_reader :code

    class << self
      # Create a new error from an HTTP response
      #
      # @param response [Faraday::Response]
      # @return [Cortera::Error]
      def from_response(response)
        message, code = parse_error(response.body)
        new(message, response.response_headers, code)
      end

      def errors
        @errors ||= {
          400 => Cortera::Error::BadRequest,
        }
      end

      private

      def parse_error(body)
        if body.nil?
          ['', nil]
        elsif body['ReportResult']
          [body['ReportResult']['Status'], body['ReportResult']['Message']]
        end
      end
    end

    # Initializes a new Error object
    #
    # @param message [Exception, String]
    # @param headers [Hash]
    # @param code [Integer]
    # @return [Cortera::Error]
    def initialize(message = '', headers = {}, code = nil)
      super(message)
      @code = code
    end


    ClientError = Class.new(self)

    # Raised when Cortera returns the HTTP status code 400
    BadRequest = Class.new(ClientError)

    RequestTimeout = Class.new(ClientError)
  end

  class Client
    SERVICE_URL = ENV['CORTERA_BASE_URL'] || 'https://connect.cortera.com/ews/services/RestDataService/'
    attr_accessor :username, :password, :base_url, :proxy

    def initialize(options = {})
      {
        username: ENV['CORTERA_USERNAME'],
        password: ENV['CORTERA_PASSWORD'],
      }.merge(options).each do |key, value|
        send(:"#{key}=", value)
      end
      yield(self) if block_given?
    end

    # @return [Hash]
    def connection_options
      @connection_options ||= {
        headers: {
            accept: 'application/json',
            user_agent: user_agent,
            #proxy: proxy,
          },
      }
    end

    # Perform an HTTP GET request
    def get(path, params = {})
      request(:get, path, params, request_headers)
    end

    def business_risk params = {}
      get('searchReport', params.merge(products: 'Business Risk')).tap do |response|
        raise Error::ClientError.from_response(response) unless response.body['ReportResult'] && response.body['ReportResult']['Status'] == 0
      end
    end

    def business_demographics params = {}
      get('searchReport', params.merge(products: 'Business Demographics Packet')).tap do |response|
        raise Error::ClientError.from_response(response) unless response.body['ReportResult'] && response.body['ReportResult']['Status'] == 0
      end
    end

    def cpr_report params = {}
      get('searchReport', params.merge(products: 'CPR Report')).tap do |response|
        raise Error::ClientError.from_response(response) unless response.body['ReportResult'] && response.body['ReportResult']['Status'] == 0
      end
    end

    private

    def request(method, path, params = {}, headers = {})
      connection.send(method.to_sym, path, params) { |request| request.headers.update(headers) }.env
    rescue Faraday::Error::TimeoutError, Timeout::Error => error
      raise(Cortera::Error::RequestTimeout.new(error))
    rescue Faraday::Error::ClientError, JSON::ParserError => error
      raise(Cortera::Error.new(error))
    end


    def url_prefix
      base_url || SERVICE_URL
    end

    def user_agent
      "Cortera Ruby Client #{Cortera::VERSION} (Faraday #{Faraday::VERSION})"
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= Faraday.new(url_prefix, connection_options) do |c|
        c.basic_auth username, password
        c.request :url_encoded
        c.response :json
        c.response :raise_error
        c.adapter Faraday.default_adapter
      end
    end

    def request_headers
      headers = {}
      headers[:content_type] = 'application/x-www-form-urlencoded; charset=UTF-8'
      headers
    end
  end
end
