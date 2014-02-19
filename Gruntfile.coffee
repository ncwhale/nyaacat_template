output_directory = '../nyaacat_static_page/'
grunt_modules = ['grunt-contrib-concat', 'grunt-css', 'grunt-contrib-jade']

i18n = require 'i18n'
#配置i18n参数
i18n.configure
  locales: ['zh_CN', 'en', 'ca']
  defaultLocale: 'zh_CN'
  directory: './webroot/locales'
  updateFiles: true
  indent: '  '
  extension: '.js'

#初始化初始化结构(...
grunt_config =
  concat:
    all:
      src: []
      dest: "#{output_directory}/css/all.css"
  cssmin:
    all_min:
      src: "#{output_directory}/css/all.css"
      dest:"#{output_directory}/css/all-min.css"
  jade:
    compile:
      options:
        data:
          debug: false
      files: {}

#        "{output_directory}/index.html.#{locale}": []

module.exports = (grunt) ->

  # 载入包信息
  grunt_config['pkg'] = grunt.file.readJSON 'package.json'

  #初始化配置
  grunt.initConfig grunt_config

  #载入对应库文件
  grunt.loadNpmTasks task for task in grunt_modules

  grunt.registerTask('default', ['concat', 'cssmin', 'jade']);

  #无返回值
  return
