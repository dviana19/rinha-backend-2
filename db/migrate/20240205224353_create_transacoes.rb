class CreateTransacoes < ActiveRecord::Migration[7.1]
  def change
    create_table :transacoes do |t|
      t.integer :valor, null: false
      t.string :tipo, null: false
      t.string :descricao, null: false
      t.datetime :realizada_em, null: false
      t.integer :cliente_id, null: false
      #t.references :cliente, foreign_key: true, null: false
    end
    add_index :transacoes, :cliente_id
  end
end
