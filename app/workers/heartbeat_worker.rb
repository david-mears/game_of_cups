class HeartbeatWorker
  include Sidekiq::Worker

  def perform(slug)
    Game::MAX_GAME_LENGTH_IN_SECONDS.times do |index|
      game = Game.find_by(slug: slug)

      next if game.nil?
      break if game.trashed?
      GameChannel.broadcast_to(game, {
        event: 'heartbeat',
        number: index,
      })
      sleep(1)
    end
  end
end