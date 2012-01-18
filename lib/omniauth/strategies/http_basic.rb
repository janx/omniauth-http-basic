require 'omniauth'
require 'net/http'

module OmniAuth
  module Strategies
    class HttpBasic
      include OmniAuth::Strategy

      args [:endpoint]

      option :name, "http_basic"
      option :title, "Http Basic"
      option :headers, {}

      def request_phase
        OmniAuth::Form.build(:title => options.title, :url => callback_path) do
          text_field 'Username', 'username'
          password_field 'Password', 'password'
        end.to_response
      end

      def callback_phase
        raise MissingCredentialsError.new("Missing login credentials") unless request['username'] && request['password']

        begin
          uri = URI(options.endpoint)

          http = Net::HTTP.new(uri.host, uri.port)
          if uri.scheme == 'https'
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          end

          req = Net::HTTP::Get.new(uri.request_uri)
          req.basic_auth request['username'], request['password']
          res = http.request(req)

          return fail!(:invalid_credentials) if res.code.to_i >= 400
          super
        rescue Exception => e
          fail!(:http_basic_error, e)
        end
      end

    end
  end
end
