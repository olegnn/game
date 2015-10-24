
@createGame = (gameNumber, size, length) ->
  switch gameNumber
    | 0 =>
      new Tic-tac-toe-game size, \O , \X , length

    | 1 =>
      new  FillRowGame size


@createGameFromParams = ->
  document.getElementById(\lineLengthDiv ).style.display =
    if +!document.getElementById(\gameName ).selectedIndex then \block
    else \none
  if window.game? then if window.game.field? then window.game.field.destructor!
  window.game = createGame document.getElementById(\gameName ).selectedIndex,
                          +document.getElementById(\size ).value,
                          +document.getElementById(\length ).value

window.onload = createGameFromParams
