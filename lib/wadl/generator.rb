module WADL
  class Generator
    VERSION = '0.1.0'
    
    attr_reader :description, :options, :wadl

    def initialize(description, options = {})
      @description, @options, @wadl = description, options, ''
    end

    def to_text
      generate
      @wadl
    end

    def generate
      xml = Builder::XmlMarkup.new :indent => 2, :target => @wadl
      xml.instruct!

      namespaces = {
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'xmlns:xsd' => 'http://www.w3.org/2001/XMLSchema',
        'xsi:schemaLocation' => 'http://wadl.dev.java.net/2009/02',
        'xmlns' => 'http://wadl.dev.java.net/2009/02',
      }
      
      if options[:apigee]
        namespaces['xmlns:apigee'] = 'http://api.apigee.com/wadl/2010/07/'
        namespaces['xsi:schemaLocation'] << ' http://apigee.com/schemas/wadl-schema.xsd http://api.apigee.com/wadl/2010/07/ http://apigee.com/schemas/apigee-wadl-extensions.xsd'
      end

      xml.application(namespaces) do
        xml.resources(:base => description[:base]) do
          description[:resources].each do |name, config|
            # index
            xml.resource(:path => "#{name.pluralize.underscore}.{format}") do
              xml.param(:name => 'format', :type => 'xsd:string', :style => 'template',
                  :required => true, :default => config[:index_formats].keys.first) do
                config[:index_formats].each do |format, mime_type|
                  xml.option(:value => format, :mediaType => mime_type)
                end
              end

              xml.method('id' => name.pluralize.underscore, 'name' => 'GET') do
                if options[:agigee]
                  xml.tag!('apigee:tags') { xml.tag!('apigee:tag', name.singularize.camelcase, :primary => true) }
                  xml.tag!('apigee:authentication', :required => false)
                  xml.tag!('apigee:example', :url => "/#{name.pluralize.underscore}.#{config[:index_formats].keys.first}")
                end
              end
            end

            # show
            xml.resource(:path => "#{name.pluralize.underscore}/{id}.{format}") do
              xml.param(:name => 'format', :type => 'xsd:string', :style => 'template',
                  :required => true, :default => config[:show_formats].keys.first) do
                config[:show_formats].each do |format, mime_type|
                  xml.option(:value => format, :mediaType => mime_type)
                end
              end
              xml.param(:name => 'id', :type => 'xsd:string', :style => 'query', :required => true)

              xml.method('id' => name.singularize.underscore, 'name' => 'GET') do
                if options[:agigee]
                  xml.tag!('apigee:tags') { xml.tag!('apigee:tag', name.singularize.camelcase, :primary => true) }
                  xml.tag!('apigee:authentication', :required => false)
                  xml.tag!('apigee:example', :url => "/#{name.pluralize.underscore}/#{config[:example_id]}.#{config[:show_formats].keys.first}")
                end
              end
            end
          end
        end
      end    
    
      self
    end
  end
end
