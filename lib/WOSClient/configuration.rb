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
    attr_accessor :user, :password, :auth_url, :search_url, :search_xml

    def initialize
      @user = nil
      @password = nil
      @auth_url = 'http://search.webofknowledge.com/esti/wokmws/ws/WOKMWSAuthenticate?wsdl'
      @search_url = 'http://search.webofknowledge.com/esti/wokmws/ws/WokSearch?wsdl'
      @search_xml = <<-EOF
                      <queryParameters>
                          <databaseId>WOS</databaseId>
                          <userQuery>CU=chile</userQuery>
                          <editions>
                             <collection>WOS</collection>
                             <edition>SCI</edition>
                          </editions>
                          <timeSpan>
                             <begin>2000-01-01</begin>
                             <end>2017-12-31</end>
                          </timeSpan>
                          <queryLanguage>en</queryLanguage>
                      </queryParameters>
                      <retrieveParameters>
                          <firstRecord>1</firstRecord>
                          <count>10</count>
                      </retrieveParameters>
                    EOF
    end

    def user
      unless @user
        raise Errors::Configuration, 'WOSClient user missing! See the documentation for configuration settings.'
      end
      @user
    end

    def password
      unless @password
        raise Errors::Configuration, 'WOSClient password missing! See the documentation for configuration settings.'
      end
      @password
    end

    def auth_url
      @auth_url
    end

    def search_url
      @search_url
    end

    def search_xml
      @search_xml
    end
  end
end
