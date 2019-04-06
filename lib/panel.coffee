PanelRow = require './panel-row'
Tablesort = require 'tablesort'

class PanelView extends HTMLElement
  initialize: ->
    Tablesort.extend('number',
      (item) ->
        return true
      , (a, b) ->
        console.log(parseFloat(a))
        console.log(parseFloat(b))

        console.log(parseFloat(a) > parseFloat(b))
        return if parseFloat(a) > parseFloat(b) then -1 else 1
      )
    @classList.add('lcov-info-panel', 'tool-panel', 'panel-bottom')

    panelBody = document.createElement('div')
    panelBody.classList.add('panel-body')
    @appendChild(panelBody)

    @table = document.createElement('table')
    panelBody.appendChild(@table)

    tableHead = document.createElement('thead')
    tableHead.classList.add('panel-heading')
    @table.appendChild(tableHead)

    rowHead = document.createElement('tr')
    tableHead.appendChild(rowHead)

    rowHead.appendChild @createColumn('Test Coverage')
    rowHead.appendChild @createColumn('Coverage')
    rowHead.appendChild @createColumn('Percent')
    rowHead.appendChild @createColumn('Lines')
    rowHead.appendChild @createColumn('Hits/Line')

    @tableBody = document.createElement('tbody')
    @table.appendChild(@tableBody)

    atom.workspace.addRightPanel(item: this)
    @tablesort = new Tablesort(@table)
    return

  createColumn: (title, data={}) ->
    col = document.createElement('th')
    col.setAttribute('data-sort-method', 'number')
    col.innerHTML = title
    if data.hasOwnProperty('sort') and not data.sort
      col.classList.add('no-sort')
    return col

  update: (data) ->
    return unless data

    if @mtime
      return if @mtime is data.mtime

    @mtime = data.mtime
    @tableBody.innerHTML = ''

    projectRow = new PanelRow
    projectRow.initialize('directory', data)
    projectRow.classList.add('no-sort')
    @tableBody.appendChild(projectRow)

    for fielName, file of data.files
      tableRow = new PanelRow
      tableRow.initialize('file', file)
      @tableBody.appendChild(tableRow)

    @tablesort.refresh()
    return

  destroy: ->
    @remove() if @parentNode
    return

module.exports = document.registerElement('lcov-info-panel-view', prototype: PanelView.prototype, extends: 'div')
