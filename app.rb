require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/contrib'

# models
require './models/cliente'

module Rinha
  class App < Sinatra::Base
    set :database_file, 'config/database.yml'

    configure do
      register Sinatra::ActiveRecordExtension
    end

    configure :development do
      enable :logging
      register Sinatra::Reloader
    end

    get '/clientes/:id/extrato' do
      content_type :json
      logger.info "loading extrato"
      Cliente.all.to_json
    end


    post '/clientes/:id/transacoes' do
      content_type :json
      logger.info "loading transacoes"
    end
  end
end
