require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/contrib'

# models
require './models/transacao'
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
      begin
        cliente = Cliente.find(params[:id])
        {
          saldo: {
            total: cliente.saldo,
            data_extrato: Time.current,
            limite: cliente.limite
          },
          ultimas_transacoes: cliente.transacoes.map do |t|
            { valor: t.valor, tipo: t.tipo, descricao: t.descricao, realizada_em: t.realizada_em }
          end
        }.to_json
      rescue ActiveRecord::RecordNotFound
        status 404
        { error: 'not found' }.to_json
      end
    end

    post '/clientes/:id/transacoes' do
      content_type :json

      begin
        cliente = Cliente.find(params[:id])
        data = JSON.parse request.body.read
        logger.info "loading #{data.inspect}"
        transacao = Transacao.new.tap do |t|
          t.valor = data['valor']
          t.tipo = data['tipo']
          t.descricao = data['descricao']
          t.clientes_id = cliente.id
          t.realizada_em = Time.current
        end

        saldo = cliente.saldo - transacao.valor
        if (transacao.valid? && transacao.tipo == "c") || (transacao.valid? && transacao.tipo == "d" && saldo >= (cliente.limite * -1))
          cliente.transaction do
            if transacao.tipo == "c"
              cliente.saldo = cliente.saldo + transacao.valor
            else
              cliente.saldo = cliente.saldo - transacao.valor
            end
            transacao.save
            cliente.save
          end
          status 200
          { limite: cliente.limite, saldo: cliente.saldo }.to_json
        else
          status 422
          { erro: 'transacao invalida' }.to_json
        end
      rescue ActiveRecord::RecordNotFound
        status 404
        { error: 'not found' }.to_json
      end
    end
  end
end
