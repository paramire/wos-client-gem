module WOSClient

  # Adds global configuration settings to the gem, including:
  # 
  # * `config.user`     - your WOS Soap-Based API user
  # * `config.password` - your WOS Soap-Based API  password
  # 
  # 
  # # Required fields
  # 
  # The following fields are *required* to use the gem:
  # 
  # - User
  # - Password
  # 
  # The gem will raise a `Errors::Configuration` if you fail to provide these keys.
  # 
  # # Configuring your gem
  #
  # ```
  # WOSClient.configure do |config|
  #   config.user = ''
  #   config.password = ''
  # end
  # ```
  #
  # # Accessing configuration settings
  # 
  # All settings are available on the `WOSClient.configuration` object:
  # 
  # ```
  # WOSClient.configuration.user
  # WOSClient.configuration.password
  # ```
  # # Resetting configuration
  # 
  # To reset, simply call `WOSClient.reset`.
  # 
  class Configuration
    attr_accessor :user, :password

    def initialize
      @user = nil
      @password = nil
    end

    def user
      raise Errors::Configuration, "WOSClient user missing! See the documentation for configuration settings." unless @user
      @user
    end

    def password
      raise Errors::Configuration, "WOSClient password missing! See the documentation for configuration settings." unless @password
      @password
    end
  end
end