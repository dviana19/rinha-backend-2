class Cliente < ActiveRecord::Base
  validates_presence_of :nome, :limite
end