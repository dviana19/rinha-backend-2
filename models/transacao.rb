class Transacao < ActiveRecord::Base
  self.table_name = 'transacoes'
  belongs_to :cliente, class_name: 'Cliente'

  validates_presence_of :valor, :tipo, :descricao, :cliente_id
  validates :valor, numericality: { only_integer: true, greater_than: 0 }
  validates :descricao, length: { maximum: 10 }
  validates :tipo, inclusion: { in: %w(c d) }

  validate :limite_disponivel

  def limite_disponivel
    return if tipo == "c"

    errors.add(:limite, 'nao disponivel') if (novo_saldo).abs > cliente.limite
  end

  def novo_saldo
    tipo == "c" ? cliente.saldo + valor : cliente.saldo - valor
  end
end
