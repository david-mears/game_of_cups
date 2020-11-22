import consumer from "./consumer"
import alertModal from "../scripts/alertModal"

consumer.subscriptions.create({ channel: "GameChannel", 
                                slug: window.location.pathname.split('/').filter(word => word.length > 1)[1]}, {
  received(data) {
    const playerData = document.getElementById('playerInfo').dataset
    const currentPlayerId = parseInt(playerData.playerId);

    if (data['event'] === 'new_player') {
      const players = document.getElementsByClassName('player');

      let i;
      for (i = 0; i < players.length; i++) {
        const playerNameElement = document.getElementById(`playerName${i}`);
        if (playerNameElement.innerText === '') {
          playerNameElement.innerHTML = data['name'];
          break;
        };
      };

      if (data['quorate'] === true) {
        const button = document.getElementById('startButton');
        button.disabled = false;
        button.value = 'Start the game already!'
      };

    } else if (data['event'] === 'cup_quaffed') {
      const playerData = document.getElementById("playerInfo").dataset;

      if (data['quaffer'] !== currentPlayerId) {
        alertModal(data['description']);
      };
      if (data['status'] === 'finished') {
        const arthurAllegiance = data['arthur_allegiance']
        const playerIsVictorious = data['victorious_knights'].includes(playerData.playerId)
        const playerIsArthur = (parseInt(data['arthur']) === currentPlayerId)

        const gameOverHeading = `<h1 style="margin-top: 0">The End</h1>`
        const gameOverMessage = playerIsVictorious ? `You were victorious!` : `You lost!`
        const gameOverDetails = !playerIsArthur ?
          `<p class="center">Arthur drank from the Holy Grail, sealing your fate. Arthur's allegiance is to the forces of <span class="newthought">${arthurAllegiance}</span>.</p>
           <p class="center">${gameOverMessage}</p>`
        :
          `<p class="center">You drank from the Holy Grail. Your allegiance is to the forces of <span class="newthought">${arthurAllegiance}</span>.</p>
           <p class="center">The ${arthurAllegiance} side were victorious.</p>`
        document.getElementById('endGame').innerHTML = (gameOverHeading + gameOverDetails)
      }

    } else if (data['event'] === 'game_started') {
      let message = `The game has started! Arthur is ${data['arthur_name']}.`

      if (data['evil_players'].flat().includes(playerData.playerId)) {
        let evilNames = [];
        let playerIndex;
        let i;
        for (i = 0; i < data['evil_players'].length; i++) {
          evilNames.append(data['evil_players'][i][1]);
          if (data['evil_players'][i][0] === playerData.playerId) {
            playerIndex = i
          };
        };
        evilNames.splice(playerIndex, 1);

        const listOfOtherEvilPlayers = (evilNames.length === 0) ?
          'You are the only evil player.'
        :
          `You are evil, along with ${[evilNames.slice(0, (evilNames.length - 1)).join(', '),
          evilNames[evilNames.length - 1]].join(' & ')}`

        message = `${message}</p><p>${listOfOtherEvilPlayers}.</p>`
      } else {
        message = `${message}</p><p>You are good.</p>`
      }
      message = `${message}<p><a href="${window.location}"><button>OK</button></a></p>`
      alertModal(message, false);
    }
  }
})

