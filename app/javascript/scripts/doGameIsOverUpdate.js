const doGameIsOverUpdate = (data, currentPlayerId) => {
  const arthurAllegiance = data['arthur_allegiance']
  const playerIsVictorious = data['victorious_knights'].includes(currentPlayerId)
  const playerIsArthur = (parseInt(data['arthur']) === currentPlayerId)

  const gameOverHeading = `<h1 style="margin-top: 0">The End</h1>`
  const gameOverMessage = playerIsVictorious ? `You were victorious!` : `You lost!`
  const gameOverDetails = !playerIsArthur ?
    `<p class="center">Arthur drank from the Holy Grail, sealing your fate. Arthur's allegiance is to the forces of <span class="newthought">${arthurAllegiance}</span>.</p>
             <p class="center">${gameOverMessage}</p>`
    :
    `<p class="center">You drank from the Holy Grail. Your allegiance is to the forces of <span class="newthought">${arthurAllegiance}</span>.</p>
             <p class="center">The ${arthurAllegiance} side were victorious.</p><hr/>`
  document.getElementById('endOfGame').innerHTML = (gameOverHeading + gameOverDetails)
  window.scrollTo(0, 0)
}

export default doGameIsOverUpdate