class Game < ApplicationRecord
  NUMBER_OF_BASIC_CUPS = 3.freeze

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
    broadcast_game_start
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
    image_filenames = Cup.read_n_random_filenames(number_of_cups_to_create)
    Cup::NAMES.keys[0..(NUMBER_OF_BASIC_CUPS - 1)].shuffle.each_with_index do |kind, index|
      Cup.create(game: self, kind: kind.to_s, image: image_filenames[index], label: (index + 1).to_s)
    end
    return unless surprise_cup

    create_surprise_cup(image_filenames)
  end

  def create_surprise_cup(image_filenames)
    cups << Cup.create(
      game: self,
      kind: Cup::NAMES.keys[NUMBER_OF_BASIC_CUPS..].sample.to_s,
      image: image_filenames[NUMBER_OF_BASIC_CUPS],
      label: (NUMBER_OF_BASIC_CUPS + 1).to_s
    )
  end

  def number_of_cups_to_create
    surprise_cup ? NUMBER_OF_BASIC_CUPS + 1 : NUMBER_OF_BASIC_CUPS
  end

  def set_default_status
    draft! if status.nil?
  end

  def broadcast_game_start
    GameChannel.broadcast_to(self, {
      event: 'game_started',
      evil_player_ids: evil_players.pluck(:id),
      evil_player_names: evil_players.pluck(:name),
      arthur_id: arthur&.id,
      arthur_name: arthur&.name
    })
  end
end
