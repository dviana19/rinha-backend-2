class Transacao < ActiveRecord::Base
  self.table_name = 'transacoes'
  belongs_to :cliente

  validates_presence_of :valor, :tipo, :descricao, :clientes_id
end
