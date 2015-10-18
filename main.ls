@game = ->
  size = +document.getElementById(\size ).value || 4
  data = [0] * size * size
  currentPlayer = 2
  startPos = null
  playerElement = document.getElementById \player
  stateElement =  document.getElementById \state

  selectCell = ->
    if +this.innerText then return alert "Эту клетку нельзя выбрать"
    if startPos?
      fillCells(startPos,  +this.id)
      checkGameOver!
    else
      startPos := +this.id
      stateElement.innerText = "Выберите конечную клетку"

  fillCells = (startPos, endPos) ->
    if startPos > endPos
      startPos = [endPos, endPos = startPos][0]
    isColumn = endPos - startPos >= size

    if isColumn and (endPos - startPos) % size
      return alert "Выберите конечную клетку на одной горизонтали
                    или вертикали с текущей клеткой"

    for j from startPos to endPos

      if ((j % size is endPos % size) and isColumn) or !isColumn
        data[j] = 1
        element = document.getElementById(j)
        element.innerText = 1
        element.className = \touched

  checkGameOver = ->
    if isGameOver!
      alert "Победа за игроком номер #{currentPlayer}"
      game!
    else nextTurn!

  isGameOver = -> !data.filter((a)-> a is 0).length

  nextTurn = ->
    currentPlayer := if currentPlayer is 1 then 2 else 1
    playerElement.innerText = "Ход #{currentPlayer} игрока"
    stateElement.innerText = "Выберите начальную клетку"
    startPos := null

  do ->
    document.body.removeChild(document.getElementsByTagName("table")[0]) if document.getElementsByTagName("table").length
    table = document.body.appendChild document.createElement \table
    for j of data
      unless j % size
        table.appendChild prevElement = document.createElement \tr
      element = document.createElement \td
      element.id = j
      element.onclick = selectCell
      element.innerText = 0
      prevElement.appendChild element

  nextTurn!

window.onload = game
