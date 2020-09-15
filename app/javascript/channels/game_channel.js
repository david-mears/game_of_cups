import consumer from "./consumer"
 
consumer.subscriptions.create({ channel: "GameChannel"}, {
  received(data) {

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
    } else {
      window.location.reload();
    }
  }
})
// TODO: find out what a 'room' is and whether I should use one to distinguish
// streams of info about different games.
// https://guides.rubyonrails.org/action_cable_overview.html#subscriber

