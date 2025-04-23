# frozen_string_literal: true

require 'fast_mcp'

module FastMcp
  module Transports
    class UserTokenTransport < FastMcp::Transports::RackTransport
      def initialize(app, server, options = {})
        super

        @auth_header_name = options[:auth_header_name] || 'Authorization'
        @auth_exempt_paths = options[:auth_exempt_paths] || []
        @user_from_token_proc = options[:user_from_token_proc] || ->(token) { User.find_by!(api_token: token) }
      end

      def handle_mcp_request(request, env)
        if !exempt_from_auth?(request.path)
          token = find_token_in_header(request) || find_token_in_params(request)

          # return unauthorized_response(request) if token.blank?

          begin
            user = token.present? ? @user_from_token_proc.call(token) : User.first
            client_id = extract_client_id(env)
            setup_session!(user, client_id, request.user_agent, request.ip)

            super
          rescue ActiveRecord::RecordNotFound
            return unauthorized_response(request)
          end
        end
      end

      private

      def find_token_in_header(request)
        auth_header = request.env["HTTP_#{@auth_header_name.upcase.gsub('-', '_')}"]

        auth_header&.gsub('Bearer ', '')
      end

      def find_token_in_params(request)
        request.params['auth_token']
      end

      def exempt_from_auth?(path)
        @auth_exempt_paths.any? { |exempt_path| path.start_with?(exempt_path) }
      end

      def unauthorized_response(request)
        @logger.info("Unauthorized request: Invalid or missing authentication token")

        body = JSON.generate(
          {
            jsonrpc: '2.0',
            error: {
              code: -32_000,
              message: 'Unauthorized: Invalid or missing authentication token'
            },
            id: extract_request_id(request)
          }
        )

        [401, { 'Content-Type' => 'application/json' }, [body]]
      end

      def extract_request_id(request)
        return nil unless request.post?

        begin
          body = request.body.read
          request.body.rewind
          JSON.parse(body)['id']
        rescue StandardError
          nil
        end
      end

      def setup_session!(user, client_id, user_agent, remote_ip)
        Current.session ||= find_session_by_client_id(client_id) || start_new_session_for(user, client_id, user_agent, remote_ip)
      end

      def find_session_by_client_id(client_id)
        Session.find_by(client_id: client_id)
      end

      def start_new_session_for(user, client_id, user_agent, remote_ip)
        user.sessions.create!(user_agent: user_agent, ip_address: remote_ip, client_id: client_id)
      end

      def unregister_sse_client(client_id)
        super(client_id)

        terminate_session(client_id)
      end

      def terminate_session(client_id)
        session = find_session_by_client_id(client_id)
        session.destroy if session
      end
    end
  end
end
