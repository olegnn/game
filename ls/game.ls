class Game

  (@size, @cellDefaultValue = 0, @cellTouchedValue = 1) ->

    @size = if @size in [2 to 12] then size else 4

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
    @field = new Field @size, @selectCell, @cellDefaultValue

    /*
     * calling next turn will set player to 1
     * and print all necessary messages
     *
     */
    @nextTurn!

  selectCell : (obj) ->

  checkGameOver : ->
    if @isGameOver!
      Info.postAlertMessage "Победа за игроком номер #{@currentPlayer}"

      createGameFromParams!
    else @nextTurn!

  isGameOver : ->

  nextTurn : ->
    @currentPlayer = if @currentPlayer is 1 then 2 else 1
    Info.postPlayerInfoMessage "Ход #{@currentPlayer} игрока"
    Info.postStateMessage "Выберите начальную клетку"
    @startPos = null


class FillRowGame extends Game

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
        @field.setCellStart  @startPos
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
          @field.setCellData j, @cellTouchedValue
          @field.setCellTouched j


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

    isGameOver : ~> !@data.filter((a)-> a is 0).length

class Tic-tac-toe-game extends Game

  (@size, @cellDefaultValue = 0, @cellTouchedValue = 1, @length) ->
    @length = if @length in [1 to @size] then @length else @size
    super ...


  selectCell : (obj) ~>
    return if @data[@field.getCellNumber(obj.target)]
    @startPos = @field.getCellNumber(obj.target)
    @data[@startPos] = 1
    @field.setCellTouched  @startPos
    @field.setCellData @startPos, @cellTouchedValue
    @checkGameOver!

  isGameOver : ->
    for j from 0 to @size
      return true if !!([

                     @data[j * @size to (j + 1) * @size - 1 by 1].join(""), #horizontal check

                     @data[j to (@size ^ 2 - @size + j) by @size].join(""), #vertical check

                     @data[j to @size ^ 2 - j * @size by @size + 1].join(""), #main diagonal to right check

                     if j then @data[j * @size to @size ^ 2 by @size + 1].join("") else "", #main diagonal to bot check

                     @data[@size - 1 - j to @size ^ 2 - j * @size - 2 by @size - 1].join(""), #other diagonal  to left check

                     if j then @data[(j + 1) * @size - 1 to @size ^ 2 by @size - 1].join("") else "" #other diagonal to bot check

                     ].filter (a) ~>  a.indexOf(\1 * @length) > -1).length

    false




@FillRowGame = FillRowGame
@Tic-tac-toe-game = Tic-tac-toe-game
