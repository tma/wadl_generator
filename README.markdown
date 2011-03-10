# WADL Generator

## Installation

    # Gemfile
    gem 'wadl_generator'

## Usage / Example

#### config/routes.rb

    namespace 'api' do
      namespace 'v1' do
        get 'description.:format' => 'base#description'
        resources :posts, :only => [:index, :show]
      end
    end

#### app/controllers/api/v1/base_controller.rb

    class Api::V1::BaseController < ApplicationController
      def description
        respond_to do |format|
          format.html do
            render :text => %q{<iframe src="http://apigee.com/<user>/embed/console/<name>" 
              width="100%" height="95%"></iframe>}
          end
    
          format.wadl do
            render :text => WADL::Generator.new(wadl_description, :apigee => true), 
              :content_type => 'application/xml'
          end
        end
      end

      private

      def wadl_description
        {
          :base => "#{request.url.gsub('/description.wadl', '')}",
          :resources => {
            'posts' => {
              :index_formats => {
                :json => 'application/json',
              },
              :show_formats => {
                :json => 'application/json',
                :html => 'application/html',
                :pdf => 'application/pdf',
              },
              :example_id => 28,
            },
          }
        }
      end
    end

## Todos

* Add tests

## License

MIT License - Thomas Maurer
