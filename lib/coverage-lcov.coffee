fs = require 'fs'
parse = require 'lcov-parse'
path = require 'path'

splitPath = (filePath) ->
  return filePath.replace(/\\/g, '/').split('/')

findInfo = (filePath) ->
  while filePath and filePath isnt path.dirname(filePath)
    filename = path.join(filePath, 'coverage', 'lcov.info')

    if fs.existsSync(filename)
      console.log('LcovInfoView: Using info at', filename)
      return filename

    filePath = path.dirname(filePath)

  console.log 'LcovInfoView: No coverage/lcov.info file found for', filePath
  return

matchPath = (fp, lcovData) ->
  lp = splitPath lcovData.file

  return unless lp.length <= fp.length

  for i in [1..lp.length] by 1
    unless i is 0 and lp[0] is '.'
      if lp[lp.length - i] isnt fp[fp.length - i]
        return

  return lcovData

parseInfo = (filePath, infoFile, cb) ->
  parse infoFile, (err, data) ->
    if err
      console.error 'LcovinfoView:', err
      return cb()

    fileData = null
    fileParts = splitPath filePath
    for fileInfo in data when not fileData
      fileData = matchPath fileParts, fileInfo

    unless fileData
      console.log 'LcovInfoView: No coverage info found for', filePath
      return cb()

    total = 0
    covered = 0

    data =
      lines: []

    for detail in fileData.lines.details
      data.lines.push line =
        no: detail.line
        hit: detail.hit
        range: [[detail.line - 1, 0], [detail.line - 1, 0]]

      total++
      line.klass = 'lcov-info-no-coverage'
      if line.hit > 0
        line.klass = 'lcov-info-has-coverage'
        covered++

    data.coverage = (if total then covered/total else 0)*100
    return cb(data)

  return

module.exports = (filePath, cb) ->
  return cb() unless infoFile = findInfo(filePath)

  parseInfo filePath, infoFile, cb
  return
