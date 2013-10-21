# Exports an object that defines
#    all of the paths & globs that the project
#    is concerned with.
#
#   The "configure" task will require this file and
#    then re-initialize the grunt config such that
#    directives like <config:files.js.app> will work
#    regardless of the point you're at in the build
#    lifecycle.
#
#   To see the default definitions for all of Lineman's file paths and globs, look at:
#   https://github.com/testdouble/lineman/blob/master/config/files.coffee
#

lineman = require(process.env["LINEMAN_MAIN"])
grunt = lineman.grunt

module.exports = lineman.config.extend "files",
  js:
    uncompressedDist: "dist/#{grunt.file.readJSON('package.json').name}.js"
    vendor: [
      "vendor/js/underscore.js"
      "vendor/js/jquery.js"
      "vendor/js/backbone.js"
    ]

  coffee:
    app: [
      "app/js/backbone_fixins.coffee"
      "app/js/**/*.coffee"
    ]
