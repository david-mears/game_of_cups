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
    players.reject(&:arthur?).shuffle.take(number_of_evil_players_at_start).each(&:evil!)
    GameChannel.broadcast_to(self, {
      event: 'game_started',
      evil_player_ids: evil_players.pluck(:id),
      evil_player_names: evil_players.pluck(:name),
      arthur_id: arthur&.id,
      arthur_name: arthur&.name
    })
  end

  def quorate?
    players.count == number_of_players
  end

  def arthur
    players.select(&:arthur?).first
  end

  def knights
    players.reject(&:arthur?)
  end

  def victorious_knights
    return [] unless finished?

    knights.select { |knight| knight.allegiance == arthur.allegiance }
  end

  def evil_players
    players.select(&:evil?)
  end

  def self.generate_slug
    begin
      slug = WordsApi.new.get_word(min_letters: 5, max_letters: 5)
    rescue StandardError
      slug = ('a'..'z').to_a.sample(5).join
    end
    slug = generate_slug if slug == 'find' || slug.include?('.') || Game.all.map(&:slug).include?(slug)
    slug
  end

  private

  def create_cups
    filenames = Cup.read_n_random_filenames(3)
    cups = []
    Cup::NAMES.keys.shuffle.each_with_index do |kind, index|
      cup = Cup.create(game: self, kind: kind.to_s, image: filenames[index], label: (index + 1).to_s)
      cup.save
      cups.push cup
    end
    self.cups = cups
  end

  def set_default_status
    draft! if status.nil?
  end
end
