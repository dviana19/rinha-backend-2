class CreateTransacoes < ActiveRecord::Migration[7.1]
  def change
    create_table :transacoes do |t|
      t.integer :valor, null: false
      t.string :tipo, null: false
      t.string :descricao, null: false
      t.references :clientes, foreign_key: true, null: false
    end
  end
end
