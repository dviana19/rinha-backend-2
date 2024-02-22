class Cliente < ActiveRecord::Base
  has_many :transacoes, class_name: 'Transacao', foreign_key: 'cliente_id'

  validates_presence_of :nome, :limite, :saldo
end
