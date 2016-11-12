class PanelRow extends HTMLTableRowElement
  initialize: (type, file) ->
    colTitle = @createColumn()
    colTitleIcon = document.createElement('span')

    if type is 'directory'
      colTitleIcon.classList.add('icon', 'icon-file-directory')
      colTitleIcon.textContent = 'Project'
    else
      filePath = atom.project.relativize(file.name)
      colTitleIcon.classList.add('icon', 'icon-file-text')
      colTitleIcon.dataset.name = filePath
      colTitleIcon.textContent = filePath
      colTitleIcon.addEventListener 'click', @openFile.bind(this, filePath)

    colTitle.appendChild(colTitleIcon)
    @appendChild(colTitle)

    colProgress = @createColumn()
    colProgress.dataset.sort = file.coverage
    progressBar = document.createElement('progress')
    progressBar.max = 100
    progressBar.value = file.coverage
    progressBar.classList.add @coverageColor(file.coverage)
    colProgress.appendChild(progressBar)
    @appendChild(colProgress)

    @appendChild(@createColumn("#{Number(file.coverage.toFixed(2))}%"))
    @appendChild(@createColumn("#{file.covered} / #{file.total}"))

    strength = file.hit / file.total
    @appendChild(@createColumn(Number(strength.toFixed(2))))

    return

  createColumn: (content = null) ->
    col = document.createElement('td')
    col.innerHTML = content
    return col

  coverageColor: (coverage) ->
    return switch
      when coverage >= 90 then 'green'
      when coverage >= 75 then 'orange'
      else 'red'

  openFile: (filePath) ->
    atom.workspace.open(filePath, true)

module.exports = document.registerElement('lcov-info-table-row', prototype: PanelRow.prototype, extends: 'tr')
