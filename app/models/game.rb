class Game < ApplicationRecord
  has_many :cups, dependent: :destroy
  has_many :players, dependent: :destroy
  validates :slug, presence: true, uniqueness: true
  validates :number_of_players, presence: true

  after_create :set_default_status
  after_create :create_cups

  enum status: {
    draft: 'draft',
    started: 'started',
    finished: 'finished',
    trashed: 'trashed'
  }

  def start
    started!
    players.sample.update!(arthur: true)
    players.reject(&:arthur?).sample.evil!
  end

  def quorate?
    players.count == number_of_players
  end

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

  def set_default_status
    draft! if status.nil?
  end
end
