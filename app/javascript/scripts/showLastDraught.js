window.addEventListener('load', function() {
  const lastDraught = window.localStorage.getItem('last_draught')
  if (lastDraught != null) {
    alert(lastDraught)
  }
  window.localStorage.clear()
})
