module WOSClient

  class Client

    attr_accessor :session_cookie

    def initialize()
      @client = Savon::Client
      @credentials = [WOSClient.configuration.user, WOSClient.configuration.password]
      @auth_url = WOSClient.configuration.auth_url
      @search_url = WOSClient.configuration.search_url
      @search_xml = WOSClient.configuration.search_xml
    end

    def authenticate(auth_url=@auth_url, credentials=@credentials)
      @auth_client ||= @client.new(basic_auth: @credentials, wsdl: @auth_url)
      response = @auth_client.call(:authenticate, soap_action: "")
      @session_cookie = response.http.headers["set-cookie"]
    end
    
    def destroy
      @auth_client.call(:close_session, soap_action: "", headers: {"Cookie"=> @session_cookie})
      @session_cookie = nil
      @search_client  = nil
    end

    def citedReferences(query=@search_xml)
      self.authenticate if @session_cookie.nil?
      @search_client ||= @client.new(wsdl: @search_url, headers: {"Cookie"=> @session_cookie})
      @last_search = @search_client.call(:citedReferences, soap_action: "", message: query)
    end

    def citedReferencesRetrieve(query_id, opts={})
      self.authenticate if @session_cookie.nil?
      @search_client ||= @client.new(wsdl: @search_url, headers: {"Cookie"=> @session_cookie})
      query  = "<queryId>" + query_id + "</queryId>"
      query += self.query_retrieve(opts)
      @last_search = @search_client.call(:citedReferencesRetrieve, soap_action: "", message: query)
    end

    def citingArticles(query=@search_xml)
      self.authenticate if @session_cookie.nil?
      @search_client ||= @client.new(wsdl: @search_url, headers: {"Cookie"=> @session_cookie})
      @last_search = @search_client.call(:citingArticles, soap_action: "", message: query)
    end

    def relatedRecords(query=@search_xml)
      self.authenticate if @session_cookie.nil?
      @search_client ||= @client.new(wsdl: @search_url, headers: {"Cookie"=> @session_cookie})
      @last_search = @search_client.call(:relatedRecords, soap_action: "", message: query)
    end

    def retrieveById(query=@search_xml)
      self.authenticate if @session_cookie.nil?
      @search_client ||= @client.new(wsdl: @search_url, headers: {"Cookie"=> @session_cookie})
      @last_search = @search_client.call(:retrieveById, soap_action: "", message: query)
    end

    def search(query=@search_xml)
      self.authenticate if @session_cookie.nil?
      @search_client ||= @client.new(wsdl: @search_url, headers: {"Cookie"=> @session_cookie})
      @last_search = @search_client.call(:search, soap_action: "", message: query)
    end

    def retrieve(query_id, opts={})
      self.authenticate if @session_cookie.nil?
      @search_client ||= @client.new(wsdl: @search_url, headers: {"Cookie"=> @session_cookie})
      query  = "<queryId>" + query_id + "</queryId>"
      query += self.query_retrieve(opts)
      @last_search = @search_client.call(:retrieve, soap_action: "", message: query)
    end
    

    #query builder
    #-------------
    def query_builder(opts={})
      return @search_xml if opts.empty?
      count = opts[:count] || 100
      count = 100 if count > 100

      xml_s  = "<queryParameters>"
      xml_s += "  <databaseId>" + (opts[:databaseId] || "WOS") + "</databaseId>   "
      xml_s += "  <userQuery>" + (opts[:user_query] || "CU=chile") + "</userQuery>"
      xml_s += "  <editions>"
      xml_s += "     <collection>" + (opts[:e_collection] || "WOS") + "</collection>"
      xml_s += "     <edition>" + (opts[:e_edition] || "SCI") + "</edition>"
      xml_s += "  </editions>"
      if not opts[:symbolic_time_span].nil?
        xml_s += "<symbolicTimeSpan>" + opts[:symbolic_time_span] + "</symbolicTimeSpan>"
      else
        xml_s += "<timeSpan>"
        xml_s += "   <begin>" + (opts[:time_span_begin] || '1900-01-01') + "</begin>"
        xml_s += "   <end>" + (opts[:time_span_end] || Time.now.strftime("%Y-%m-%d")) + "</end>"
        xml_s += "</timeSpan>"
      end
      xml_s += "  <queryLanguage>" + (opts[:query_language] || "en") + "</queryLanguage>"
      xml_s += "</queryParameters>"
      xml_s += self.query_retrieve(opts)

      return xml_s
    end


    def query_retrieve(opts={})
      first_record = opts[:first_record] || 1
      count = opts[:count] || 100
      count = 100 if count > 100

      xml_s  = "<retrieveParameters>"
      xml_s += "  <firstRecord>" + first_record.to_s + "</firstRecord>"
      xml_s += "  <count>" + count.to_s + "</count>"
      if not opts[:sort_field].nil?
        xml_s += "<sortField>"
        xml_s += "   <name>" + opts[:sort_field] + "</name>"
        xml_s += "   <sort>" + (opts[:sort_type] || "A") + "</sort>"
        xml_s += "</sortField>"
      end
      if not opts[:fields].nil? and not opts[:fields].empty?
        xml_s += "<viewField>"
        xml_s += "   <collectionName>WOS</collectionName>"
        opts[:fields].each do |f|
          xml_s += " <fieldName>" + f + "</fieldName>"
        end
        xml_s += "</viewField>"
      end
      xml_s += "  <option>"
      xml_s += "     <key>RecordIDs</key>"
      xml_s += "     <value>On</value>"
      xml_s += "  </option>"
      xml_s += "</retrieveParameters>"

      return xml_s
    end

    #Response
    def response_to_hash(response)
      response_hash = response.to_hash
      root_key = response_hash.first[0]
      records = Hash.from_xml(response_hash[root_key][:return][:records])
      response_hash[root_key][:return][:records] = records
      return response_hash
    end
  end
end
