class Game

  (@size = 4) ->
    @data = [0] * @size * @size
    @currentPlayer = 2
    @startPos = null
    @stateElement = document.getElementById \state
    @playerElement = document.getElementById \player
    @init!
    @nextTurn!

  selectCell : (obj) ~>
    if +obj.target.innerText then return alert "Эту клетку нельзя выбрать"
    if @startPos?
      if @fillCells(@startPos,  +obj.target.id) then @checkGameOver!
    else
      @startPos = +obj.target.id
      obj.target.className = \start-cell
      @stateElement.innerText = "Выберите конечную клетку"

  fillCells : (startPos, endPos) ~>
    if startPos > endPos
      startPos = [endPos, endPos = startPos][0]
    isColumn = endPos - startPos >= @size or (endPos / @size .|. 0) isnt (startPos / @size .|. 0)

    if isColumn and (endPos - startPos) % @size
      return alert "Выберите конечную клетку на одной горизонтали
                    или вертикали с текущей клеткой"

    for j from startPos to endPos

      if ((j % @size is endPos % @size) and isColumn) or !isColumn
        @data[j] = 1
        element = document.getElementById(j)
        element.innerText = 1
        element.className = \touched-cell

    true

  checkGameOver : ~>
    if @isGameOver!
      alert "Победа за игроком номер #{@currentPlayer}"
      createGame @size
    else @nextTurn!

  isGameOver : ~> !@data.filter((a)-> a is 0).length

  nextTurn : ~>
    @currentPlayer = if @currentPlayer is 1 then 2 else 1
    @playerElement.innerText = "Ход #{@currentPlayer} игрока"
    @stateElement.innerText = "Выберите начальную клетку"
    @startPos = null

  init : ~>
    document.body.removeChild(document.getElementsByTagName("table")[0]) if document.getElementsByTagName("table").length
    table = document.body.appendChild document.createElement \table
    for j of @data
      unless j % @size
        table.appendChild prevElement = document.createElement \tr
      element = document.createElement \td
      element.id = j
      element.onclick = @selectCell
      element.innerText = 0
      prevElement.appendChild element

@createGame = (size) -> new Game(size)

window.onload = ->
  createGame +document.getElementById(\size ).value
