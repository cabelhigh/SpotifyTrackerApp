class Playlist < ApplicationRecord
  has_many :tracks

  def owner_and_creator?(own, cre)
    owner==own && creator==cre
  end
end
