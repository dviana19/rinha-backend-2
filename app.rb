require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/contrib'

# models
require './models/transacao'
require './models/cliente'

module Rinha
  class InvalidTransaction < StandardError; end

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
      return not_found if params[:id].to_i < 1 || params[:id].to_i > 5

      cliente = Cliente.find(params[:id])
      result = {
        saldo: {
          total: cliente.saldo,
          data_extrato: Time.current,
          limite: cliente.limite
        },
        ultimas_transacoes: cliente.transacoes.order('realizada_em DESC').limit(10).map do |t|
          { valor: t.valor, tipo: t.tipo, descricao: t.descricao, realizada_em: t.realizada_em }
        end
      }
      status 200
      result.to_json
    end

    post '/clientes/:id/transacoes' do
      content_type :json

      data = JSON.parse request.body.read

      return not_found if params[:id].to_i < 1 || params[:id].to_i > 5

      cliente = Cliente.find(params[:id])
      transacao = Transacao.new.tap do |t|
        t.valor = data['valor']
        t.tipo = data['tipo']
        t.descricao = data['descricao']
        t.cliente_id = cliente.id
        t.realizada_em = Time.current
      end

      return invalid_transaction unless transacao.valid?
      transacao.with_lock do
        transacao.save
        cliente.update_column(:saldo, transacao.novo_saldo)
      end

      status 200
      { limite: cliente.limite, saldo: cliente.saldo }.to_json
    end

    def not_found
      status 404
      { error: 'not found' }.to_json
    end

    def invalid_transaction
      status 422
      { erro: 'transacao invalida' }.to_json
    end
  end
end
