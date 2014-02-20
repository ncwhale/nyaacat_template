log = require './log'
input_directory = 'webroot/'
locales = ['zh_CN', 'en', 'ca']
output_directory = '../nyaacat_static_page/'
grunt_modules = ['grunt-contrib-concat', 'grunt-css']

clone = (s)->
  o = {}
  for k,v of s
    if typeof v == 'object'
      o[k] = clone(v)
    else
      o[k] = v
  o

i18n = require 'i18n'
#配置i18n参数
i18n.configure
  locales: locales 
  defaultLocale: 'zh_CN'
  directory: './webroot/locales'
  updateFiles: true
  indent: '  '
  extension: '.json'
i18n.init()

#初始化初始化结构(...
grunt_config =
  concat:
    all:
      src: []
      dest: "#{output_directory}css/all.css"
  cssmin:
    all_min:
      src: "#{output_directory}css/all.css"
      dest:"#{output_directory}css/all-min.css"
  jade:
    compile:
      options:
        data:
          __: i18n.__
          setLocale: i18n.setLocale
          locale: ''
          debug: false
      files: {}

# 自动添加 webroot/*.jade 文件进行多语言转换
fs = require 'fs'

grunt_modules.push 'grunt-contrib-jade'

#生成语言参数模板
for lang in locales
  grunt_config.jade[lang] = clone(grunt_config.jade.compile)
  #grunt_config.jade[lang].options.data = grunt_config.jade.compile.options.data.clone()
  grunt_config.jade[lang].options.data.locale = lang

#log grunt_config.jade.zh_CN.options

for file in fs.readdirSync input_directory
  if file.toLowerCase().slice(-5)=='.jade' && fs.lstatSync("#{input_directory}/#{file}").isFile()
    for lang in locales
      grunt_config.jade[lang].files["#{output_directory}#{file.slice(0, -5)}.html.#{lang}"] = ["#{input_directory}/#{file}", "#{input_directory}/template/*.jade"]


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
