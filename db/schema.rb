# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_05_224353) do
  create_table "clientes", force: :cascade do |t|
    t.string "nome", null: false
    t.integer "limite", null: false
    t.integer "saldo", null: false
  end

  create_table "transacoes", force: :cascade do |t|
    t.integer "valor", null: false
    t.string "tipo", null: false
    t.string "descricao", null: false
    t.datetime "realizada_em", null: false
    t.integer "cliente_id", null: false
    t.index ["cliente_id"], name: "index_transacoes_on_cliente_id"
  end

  add_foreign_key "transacoes", "clientes"
end
