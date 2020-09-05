class Game < ApplicationRecord
  has_many :cups, dependent: :destroy
  has_many :players, dependent: :destroy
  validates :slug, presence: true, uniqueness: true
  validates :number_of_players, presence: true

  after_create :create_cups, :create_players

  private

  def create_cups
    filenames = Cup.read_n_random_filenames(3)
    cups = []
    Cup::NAMES.keys.each_with_index do |kind, index|
      cup = Cup.create(game: self, kind: kind.to_s, image: filenames[index])
      cup.save
      cups.push cup
    end
    self.cups = cups
  end

  def create_players
    players = []
    number_of_players.to_i.times do
      player = Player.create(game: @game)
      player.name = %w[Jenny David Amber Shannon James Charles Kirstie].sample
      player.allegiance = %w[good evil].sample
      player.save
      players.push player
    end
    self.players = players
  end
end
