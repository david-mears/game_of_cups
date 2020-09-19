window.addEventListener('load', function() {
  const allegiance = document.getElementById('cupsSection').dataset.playerAllegiance
  
  if (allegiance === "evil") {
    document.getElementById('merlins_goblet').addEventListener('click', function() {
      this.style = `animation-name: fillScreenWhite;
                    animation-duration: 0.3s;`
    })
  } else {
    document.getElementById('accursed_chalice').addEventListener('click', function() {
      this.style = `animation-name: fillScreenBlack;
                    animation-duration: 0.3s;`
    })
  }
})

