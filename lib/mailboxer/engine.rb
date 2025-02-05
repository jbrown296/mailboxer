require 'carrierwave'
begin
  require 'sunspot_rails'
rescue LoadError
end

module Mailboxer
  class Engine < Rails::Engine
    # Ensure Mailboxer is autoloaded properly in Rails 6+
    config.autoload_paths << File.expand_path("../../app/models/mailboxer", __FILE__)

    initializer "mailboxer.models.messageable" do
      ActiveSupport.on_load(:active_record) do
        extend Mailboxer::Models::Messageable::ActiveRecordExtension
      end
    end
  end
end
