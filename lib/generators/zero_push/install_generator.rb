require 'rails/generators'

module ZeroPush
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def create_initializer_file
      @production_token = ask 'Production auth_token:'
      @development_token = ask 'Development auth_token:'
      template('zero_push.rb', 'config/initializers/zero_push.rb')
    end

    private

    def self.installation_message
      'Generates the initializer'
    end

    desc installation_message

  end
end


