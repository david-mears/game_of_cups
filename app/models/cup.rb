class Cup < ApplicationRecord
  belongs_to :game
  has_many :draughts, dependent: :destroy
  has_many :players, through: :draughts

  validates :kind, presence: true
  validates :image, presence: true
  validates :game_id, presence: true
  validates :label, presence: true

  NAMES = {
    accursed_chalice: 'The Accursèd Chalice',
    merlins_goblet: 'Merlin’s Goblet',
    holy_grail: 'The Holy Grail'
  }.freeze

  enum kind: { accursed_chalice: 0, merlins_goblet: 1, holy_grail: 2 }

  def self.read_n_random_filenames(number_of_filenames)
    filenames = Dir.entries('./app/assets/images/cups').reject { |file| File.directory? file }
    filenames.shuffle.take(number_of_filenames)
  end

  def human_readable_name
    NAMES[kind.to_sym]
  end
end
