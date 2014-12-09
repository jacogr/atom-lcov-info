fs = require 'fs'
parse = require 'lcov-parse'
path = require 'path'

cache = {}

splitPath = (filePath) ->
  return filePath.replace(/\\/g, '/').split('/')

getCache = (lcovPath) ->
  if data = cache[lcovPath]
    mtime = fs.statSync(lcovPath).mtime.getTime()
    if data.mtime is mtime
      return data

  return

setCache = (lcovPath, data) ->
  total = 0
  covered = 0
  hit = 0
  files = []

  for fileInfo in data
    files.push fdata =
      name: fileInfo.file
      parts: splitPath(fileInfo.file)
      lines: {}

    for detail in fileInfo.lines.details
      unless fdata.lines[detail.line]
        fdata.total++
        total++

      fdata.lines[detail.line] or=
        hit: 0
        klass: 'lcov-info-no-coverage'
        range: [[detail.line - 1, 0], [detail.line - 1, 0]]
      line = fdata.lines[detail.line]

      if detail.hit > 0
        line.klass = 'lcov-info-has-coverage'
        unless line.hit
          fdata.covered++
          covered++
        line.hit += detail.hit
        fdata.hit += detail.hit
        hit += detail.hit

    fdata.coverage = (if fdata.total then fdata.covered/fdata.total else 0)*100

  cov = (if total then covered/total else 0) * 100
  console.log 'LcovInfoView:', "#{cov.toFixed(2)}% over #{files.length} files"

  return cache[lcovPath] =
    name: lcovPath
    files: files
    total: total
    covered: covered
    coverage: cov
    hit: hit
    mtime: fs.statSync(lcovPath).mtime.getTime()

findInfoFile = (filePath) ->
  while filePath and filePath isnt path.dirname(filePath)
    filename = path.join(filePath, 'coverage', 'lcov.info')

    if fs.existsSync(filename)
      console.log('LcovInfoView: Using info at', filename)
      return filename

    filePath = path.dirname(filePath)

  console.log 'LcovInfoView: No coverage/lcov.info file found for', filePath
  return

matchPath = (fp, lp) ->
  return unless lp.length <= fp.length

  for i in [1..lp.length] by 1
    unless i is 0 and lp[0] is '.'
      if lp[lp.length - i] isnt fp[fp.length - i]
        return false

  return true

mapInfo = (filePath, lcovData, cb) ->
  fileParts = splitPath filePath

  for fileInfo in lcovData.files
    if matchPath(fileParts, fileInfo.parts)
      return cb(lcovData, fileInfo)

  console.log 'LcovInfoView: No coverage info found for', filePath
  return cb(lcovData)

getCoverage = (filePath, cb) ->
  unless infoFile = findInfoFile(filePath)
    return cb()

  if lcovData = getCache(infoFile)
    return mapInfo(filePath, lcovData, cb)

  parse infoFile, (err, data) ->
    if err
      console.error 'LcovinfoView:', err
      return cb()

    lcovData = setCache(infoFile, data)
    mapInfo(filePath, lcovData, cb)

  return

module.exports = getCoverage
