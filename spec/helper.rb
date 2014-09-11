require 'cortera'
require 'rspec'
require 'webmock/rspec'

WebMock.allow_net_connect!

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
