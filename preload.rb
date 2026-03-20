# frozen_string_literal: true

require_relative "config/environment"

# This ensures each forked worker gets its own DB connection
ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.establish_connection
end
