document.addEventListener( \DOMContentLoaded , ~>
  class Info

    @stateElement = document.getElementById \state

    @playerElement = document.getElementById \player

    @postStateMessage = (text) ->  @stateElement.innerText = text

    @postErrorMessage = (text) -> alert text

    @postAlertMessage = (text) -> alert text

    @postPlayerInfoMessage = (text) -> @playerElement.innerText = text

  @Info = Info
)
