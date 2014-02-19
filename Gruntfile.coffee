module.exports = (grunt) ->
  
  #初始化配置
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    concat:
      css:
        src: []
        dest: '../nyaacat_static_page/css/all.css'
    cssmin:
      css:
        src: '../nyaacat_static_page/css/all.css'
        dest:'../nyaacat_static_page/css/all-min.css'

  #载入对应库文件
  grunt.loadNpmTasks 'grunt-contrib-concat'
  grunt.loadNpmTasks 'grunt-css'

  grunt.registerTask('default', ['concat', 'cssmin']);

  #无返回值
  return
