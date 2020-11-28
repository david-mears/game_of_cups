class Player < ApplicationRecord
  belongs_to :game
  has_many :draughts, dependent: :destroy
  has_many :cups, through: :draughts

  validates :name, presence: true
  validates :allegiance, presence: true
  validates :game_id, presence: true

  # TODO: belongs_to :user

  after_create :broadcast_new_player_name

  enum allegiance: { evil: 0, good: 1 }

  def allegiance_symbol
    SYMBOLS[allegiance&.to_sym]
  end

  def whether_arthur_symbol
    SYMBOLS[:arthur] if arthur?
  end

  def quaff(cup)
    return unless game.started?

    cup.players << self
    if cup.accursed_chalice?
      evil!
    elsif cup.merlins_goblet?
      good!
    elsif arthur? && cup.holy_grail?
      game.finished!
    end
    broadcast_draught(cup)
  end

  def quaffed?(cup)
    cup.players.include? self
  end

  def broadcast_new_player_name
    GameChannel.broadcast_to(game, {
                               event: 'new_player',
                               name: name,
                               quorate: game.quorate?
                             })
  end

  private

  def broadcast_draught(cup)
    message = {
      arthur: game.arthur&.id,
      arthur_allegiance: game.arthur&.allegiance,
      cup_label: cup.label,
      cup_name: cup.human_readable_name,
      event: 'cup_quaffed',
      evil_player_ids: game.evil_players.pluck(:id),
      image: '<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24"><path fill="#010101" d="M14.585 19.534c-1.417-.708-1.396-1.625-1.396-1.854 0-.063.032-.168.073-.301.286-.294.466-.684.466-1.115 0-.302-.103-.577-.253-.821-.007-.361-.017-.694-.017-.72 0-.188.125-.793 1.382-1.5 1.257-.709 2.841-2.833 2.841-5s-.285-3.647-.367-3.938c-.084-.291-.25-.425-.469-.433-.22-.008-4.845 0-4.845 0s-4.625-.008-4.844 0c-.218.007-.385.14-.468.432s-.367 1.771-.367 3.938 1.583 4.292 2.84 5c1.257.707 1.382 1.312 1.382 1.5 0 .025-.01.34-.016.69-.16.249-.257.538-.257.851 0 .436.182.829.473 1.123.039.129.07.231.07.293 0 .229.021 1.146-1.396 1.854s-2.145 1.416-2 1.854c.145.438 2.229.465 4.583.465s4.439-.028 4.585-.465c.145-.436-.583-1.145-2-1.853z"/></svg>',
      quaffer_id: id,
      quaffer_name: name,
      status: game.status,
      victorious_knights: game.victorious_knights.pluck(:id)
    }
    GameChannel.broadcast_to(game, message)
  end
end
