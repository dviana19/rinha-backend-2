class CreateClientes < ActiveRecord::Migration[7.1]
  def change
    create_table :clientes do |t|
      t.string :nome, null: false
      t.integer :limite, null: false
      t.integer :saldo, null: false
    end
  end
end
