class PanelRow extends HTMLTableRowElement
  initialize: (type, file) ->
    colTitle = @insertCell()
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

    colProgress = @insertCell()
    colProgress.dataset.sort = file.coverage
    progressBar = document.createElement('progress')
    progressBar.max = 100
    if file.coverage >= 0 and file.coverage <= 100
      progressBar.value = file.coverage
    else
      progressBar.value = 1
      colProgress.dataset.sort = 1
    progressBar.classList.add @coverageColor(file.coverage)
    colProgress.appendChild(progressBar)

    (@createColumn("#{Number(file.coverage.toFixed(2))}"))
    (@createColumn("#{file.covered} / #{file.total}"))

    strength = file.hit / file.total
    (@createColumn(Number(strength.toFixed(2))))

    return

  createColumn: (content = null) ->
    col = @insertCell()
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
