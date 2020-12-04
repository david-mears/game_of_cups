const doNewPlayerUpdate = (data) => {
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
    console.log(document.getElementById('startButton'))
    const button = document.getElementById('startButton');
    button.disabled = false;
    button.value = 'Start the game already!'
  };
}

export default doNewPlayerUpdate
