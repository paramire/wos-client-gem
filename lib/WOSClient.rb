require "WOSClient/version"

require 'active_support/core_ext/hash'
require 'savon'
require 'pp'

require 'WOSClient/configuration'
require 'WOSClient/errors/configuration'


module WOSClient
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
