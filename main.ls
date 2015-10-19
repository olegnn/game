class Game

  (@size = if typeof size is \number and size > 0 then size else 4) ->
    /*
     * data is a vector that contains 0 and 1
     * (if cell is empty => 0 else => 1)
     *
     */

    @data = [0] * @size * @size

    /*
     * current player is number of player, whose turn
     * is at moment
     *
     */

    @currentPlayer = null

    /*
     * start position is the number of cell, from which
     * it will fill cells
     */

    @startPos = null

    /*
     * field is the table wich contains all cells
     *
     */
    @field = new Field size, @selectCell

    /*
     * calling next turn will set player to 1
     * and print all necessary messages
     *
     */
    @nextTurn!

  selectCell : (obj) ~>
    /*
     * Firstly check if cell is already filled
     *
     */
    if @data[@field.getCellNumber(obj.target)] then return #Info.postErrorMessage "Эту клетку нельзя выбрать"

    /*
     * Then check start position and set them if
     * it isn't setted
     *
     */
    if @startPos?
      if @canFillCells @startPos,  @field.getCellNumber(obj.target)
        @fillCells @startPos,  @field.getCellNumber(obj.target)
        @checkGameOver!
    else
      @startPos = @field.getCellNumber(obj.target)
      @field.setCellData obj.target, className : \start-cell
      Info.postStateMessage "Выберите конечную клетку"

  fillCells : (startPos, endPos) ~>
    /*
     * swap min and max
     *
     */
    if startPos > endPos
      startPos = [endPos, endPos = startPos][0]

    isColumn = @isColumn startPos, endPos
    for j from startPos to endPos
      if j % @size is endPos % @size and isColumn or !isColumn
        /*
         * if it's column then fill vertical
         * else horizontal
         *
         */
        @data[j] = 1
        @field.setCellDataById j, 1
        @field.setCellDataById j, className : \touched-cell


  isColumn : (startPos, endPos) -> endPos - startPos >= @size or (endPos / @size .|. 0) isnt (startPos / @size .|. 0)

  canFillCells : (startPos, endPos) ~>
    /*
     * look at fillCells
     *
     */
    if startPos > endPos
      startPos = [endPos, endPos = startPos][0]
    isColumn = @isColumn startPos, endPos
    if isColumn and (endPos - startPos) % @size
      return false
    for j from startPos to endPos
      if j % @size is endPos % @size and isColumn or !isColumn
        if @data[j] then return false
    true

  checkGameOver : ~>
    if @isGameOver!
      Info.postAlertMessage "Победа за игроком номер #{@currentPlayer}"
      @field.destructor!
      createGame @size
    else @nextTurn!

  isGameOver : ~> !@data.filter((a)-> a is 0).length

  nextTurn : ~>
    @currentPlayer = if @currentPlayer is 1 then 2 else 1
    Info.postPlayerInfoMessage "Ход #{@currentPlayer} игрока"
    Info.postStateMessage "Выберите начальную клетку"
    @startPos = null


class Field
  (@size, cellEventListener) ->
    window.table = @table = document.body.appendChild document.createElement \table
    @table.style.fontSize = 250 / (@size + 2)
    for j from 0 to @size * @size - 1
      unless j % @size
        @table.appendChild prevElement = document.createElement \tr
      element = document.createElement \td
      element.id = j
      element.onclick = cellEventListener
      element.innerText = 0
      prevElement.appendChild element

  destructor : ~>   document.body.removeChild document.getElementsByTagName(\table )[0] if @table

  getCellData : (cell) ~> cell.innerText

  getCellDataById : (id) ~> @getCellData document.getElementById id

  setCellData : (cell, data) ~>

    | typeof data is \object =>
      for key,val of data
        cell[key] = val
    | otherwise =>
      cell.innerText = data

  setCellDataById : (id, data) ~> @setCellData document.getElementById(id), data

  getCellNumber : (cell) ~> +cell.id



@createGame = (size) -> new Game size

window.onload = ->
  if window.game? then if window.game.field? then window.game.field.destructor!
  window.game = createGame +document.getElementById(\size ).value
