class Track < ApplicationRecord
  belongs_to :playlist

  def formatted_uri
    uri.split(':')[2]
  end
end
