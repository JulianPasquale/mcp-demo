# frozen_string_literal: true

# FastMcp - Model Context Protocol for Rails
# This initializer sets up the MCP middleware in your Rails application.
#
# In Rails applications, you can use:
# - ActionTool::Base as an alias for FastMcp::Tool
# - ActionResource::Base as an alias for FastMcp::Resource
#
# All your tools should inherit from ApplicationTool which already uses ActionTool::Base,
# and all your resources should inherit from ApplicationResource which uses ActionResource::Base.

# Mount the MCP middleware in your Rails application
# You can customize the options below to fit your needs.
require 'fast_mcp'
require 'fast_mcp/transports/user_token_transport'

def mount_in_rails(app, options = {})
  # Default options
  name = options.delete(:name) || app.class.module_parent_name.underscore.dasherize
  version = options.delete(:version) || '1.0.0'
  logger = options[:logger] || Rails.logger
  path_prefix = options.delete(:path_prefix) || '/mcp'
  messages_route = options.delete(:messages_route) || 'messages'
  sse_route = options.delete(:sse_route) || 'sse'
  authenticate = options.delete(:authenticate) || false
  token_based_auth = options.delete(:token_based_auth) || false
  allowed_origins = options[:allowed_origins] || FastMcp.default_rails_allowed_origins(app)

  options[:logger] = logger
  options[:allowed_origins] = allowed_origins

  # Create or get the server
  FastMcp.server = FastMcp::Server.new(name: name, version: version, logger: logger)
  yield FastMcp.server if block_given?

  # Choose the right middleware based on authentication
  FastMcp.server.transport_klass = if token_based_auth
                                  FastMcp::Transports::UserTokenTransport
                                elsif authenticate
                                  FastMcp::Transports::AuthenticatedRackTransport
                                else
                                  FastMcp::Transports::RackTransport
                                end

  # Insert the middleware in the Rails middleware stack
  app.middleware.use(
    FastMcp.server.transport_klass,
    FastMcp.server,
    options.merge(path_prefix: path_prefix, messages_route: messages_route, sse_route: sse_route)
  )
end

mount_in_rails(
  Rails.application,
  name: Rails.application.class.module_parent_name.underscore.dasherize,
  version: '1.0.0',
  path_prefix: '/mcp', # This is the default path prefix
  messages_route: 'messages',
  sse_route: 'sse', # This is the default route for the SSE endpoint
  # Add allowed origins below, it defaults to Rails.application.config.hosts
  # allowed_origins: ['localhost', '127.0.0.1', 'example.com', /.*\.example\.com/],
  token_based_auth: true,
  user_from_token_proc: ->(token) { User.find_by!(api_token: token) }
) do |server|
  Rails.application.config.after_initialize do
    # FastMcp will automatically discover and register:
    # - All classes that inherit from ApplicationTool (which uses ActionTool::Base)
    # - All classes that inherit from ApplicationResource (which uses ActionResource::Base)
    server.register_tools(*ApplicationTool.descendants)
    server.register_resources(*ApplicationResource.descendants)
    # alternatively, you can register tools and resources manually:
    # server.register_tool(MyTool)
    # server.register_resource(MyResource)
  end
end
