# frozen_string_literal: true

require_relative "config/environment"

# Ensure each forked worker gets its own DB connection
ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.establish_connection
end

# Ensure ActionCable (Redis) starts fresh in each worker
ActiveSupport.on_load(:action_cable) do
  ActionCable.server.pubsub
end
