const updateStartButton = (button) => {
  button.disabled = false;
  button.innerText = 'Start the game already!'
}

const getAndUpdateStartButton = () => {
  let button = document.getElementById('startButton');
  if (button === null) {
    // Page may not have loaded yet, especially if the 'new player' is
    // the player running this very function.
    setTimeout(() => {
      getAndUpdateStartButton();
    }, 100);
  } else {
    updateStartButton(button)
  }
}

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
    getAndUpdateStartButton()
  };
}

export default doNewPlayerUpdate
