require 'spec_helper'
require 'rails/generators/test_case'
require 'generators/zero_push/install_generator'

class ZeroPush::GeneratorTest < Rails::Generators::TestCase
  destination File.expand_path('../tmp', __FILE__)
  tests ZeroPush::InstallGenerator
  test 'it copies the initializer' do
    production_token = 'production'
    development_token = 'development'
    ZeroPush::InstallGenerator.any_instance.stubs(:ask).returns(production_token).then.returns(development_token)

    run_generator

    assert_file 'config/initializers/zero_push.rb' do |initializer|
      production_config = %Q|ZeroPush.auth_token = '#{production_token}'|
      assert(initializer.include?(production_config), "The initializer doesn't include the production configuration")

      development_config = %Q|ZeroPush.auth_token = '#{development_token}'|
      assert(initializer.include?(development_config), "The initializer doesn't include the development configuration")
    end
  end
end
