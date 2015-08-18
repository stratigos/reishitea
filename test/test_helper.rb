ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/spec"
require 'minitest/pride'

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  #  order.
  fixtures :all
  self.use_instantiated_fixtures = true

  # Add more helper methods to be used by all tests here...
  # Adding MiniTest spec DSL
  extend MiniTest::Spec::DSL

  # Tell MiniTest::Spec to use ActiveSupport::TestCase when describing an
  #  ActiveRecord model
  # @see http://blowmage.com/2013/07/08/minitest-spec-rails4
  register_spec_type self do |desc|
    desc < ActiveRecord::Base if desc.is_a? Class
  end
end
