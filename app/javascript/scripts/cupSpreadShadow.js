console.log('hi')

window.addEventListener('load', function() {
  const merlinsGoblet = document.getElementById('merlins_goblet')
  merlinsGoblet.addEventListener('click', function() {
    console.log('quaff')
    this.style = `animation-name: fillScreenWhite;
                  animation-duration: 0.3s;`
  })

  const accursedChalice = document.getElementById('accursed_chalice')
  accursedChalice.addEventListener('click', function() {
    console.log('gulp')
    this.style = `animation-name: fillScreenBlack;
                  animation-duration: 0.3s;`
  })
})

