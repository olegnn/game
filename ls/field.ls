FieldInterface =
  (@size, cellEventListener) ->
  destructor : ~>
  getCell : (id) ~>
  getCellData : (id) ~>
  getCellNumber : (cell) ~>
  setCellData : (id, data) ~>
  setCellTouched : (id) ~>
  setCellStart : (id) ~>

class HtmlTableField implements FieldInterface
  (@size, cellEventListener, cellValue)  ->
    @table = document.body.appendChild document.createElement \table
    @table.style.fontSize = 250 / (@size + 2)
    for j from 0 to @size * @size - 1
      unless j % @size
        @table.appendChild prevElement = document.createElement \tr
      element = document.createElement \td
      element.id = j
      element.onclick = cellEventListener
      element.innerText = cellValue
      prevElement.appendChild element

  destructor : ~> document.body.removeChild document.getElementsByTagName(\table )[0] if @table

  getCell : (id) ~> document.getElementById id

  getCellData : (id) ~> @getCell(id).innerText

  getCellNumber : (cell) ~> +cell.id

  setCellData : (id, data) ~>
    cell = @getCell id
    if typeof data is \object
      for key,val of data
        cell[key] = val
    else
      cell.innerText = data

  setCellTouched : (id) ~> @setCellData id, className : \touched-cell

  setCellStart : (id) ~> @setCellData id, className : \start-cell

@Field = HtmlTableField
