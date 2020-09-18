class Draught < ApplicationRecord
  belongs_to :player
  belongs_to :cup
end
