#在此配置生成参数
locales = ['zh-cn', 'en', 'ca']
locales_directory = './webroot/locales'

input_directory = 'webroot/'
output_directory = '../nyaacat_static_page/'

grunt_modules = []
grunt_tasks = []
grunt_config = {}

#伪对象拷贝解构
clone = (s)->
  o = {}
  for k,v of s
    if typeof v == 'object'
      o[k] = clone(v)
    else
      o[k] = v
  o

log = require './log'
i18n = require 'i18n'

#配置i18n参数
i18n.configure
  locales: locales 
  defaultLocale: locales[0]
  directory: "#{locales_directory}"
  updateFiles: true
  indent: '  '
  extension: '.json'
i18n.init()

# 自动添加 webroot/*.jade 文件进入转换列表，支持当前设定多语言
fs = require 'fs'

grunt_modules.push 'grunt-contrib-jade'
grunt_tasks.push 'jade'

jade_config =
    compile:
      options:
        data:
          __: i18n.__
          setLocale: i18n.setLocale
          locale: ''
          debug: false
      files: {}

#生成语言参数模板
for lang in locales
  jade_config[lang] = clone(jade_config.compile)
  jade_config[lang].options.data.locale = lang

#狡兔死，走狗烹
delete jade_config.compile

for file in fs.readdirSync input_directory
  if file.toLowerCase().slice(-5)=='.jade' && fs.lstatSync("#{input_directory}/#{file}").isFile()
    for lang in locales
      jade_config[lang].files["#{output_directory}#{file.slice(0, -5)}.html.#{lang}"] = ["#{input_directory}/#{file}"] #, "#{input_directory}/template/*.jade"]

grunt_config['jade'] = jade_config

# 自动添加 webroot/css/*.stylus 编译成.css文件并进行合并
grunt_modules.push 'grunt-contrib-stylus'
grunt_tasks.push 'stylus'

stylus_config =
  compile:
    options:
      paths: []
      use: []
      import: []
    files: {}

for file in fs.readdirSync "#{input_directory}/css/"
  if file.toLowerCase().slice(-5)=='.styl' && fs.lstatSync("#{input_directory}/css/#{file}").isFile()
    stylus_config.compile.files["#{input_directory}/css/#{file.slice(0,-5)}.css"] = "#{input_directory}/css/#{file}"

# 添加配置节
grunt_config['stylus'] = stylus_config;

# 自动查找并组合所有.css 文件
grunt_modules.push 'grunt-contrib-concat'
grunt_tasks.push 'concat'

concat_config =
  all:
    src: []
    dest: "#{output_directory}css/all.css"

for file in fs.readdirSync "#{input_directory}/css/"
  if file.toLowerCase().slice(-4)=='.css' && fs.lstatSync("#{input_directory}/css/#{file}").isFile()
    concat_config.all.src.push "#{input_directory}/css/#{file}"

grunt_config['concat'] = concat_config

# 将最终目标css文件进行压缩
grunt_modules.push 'grunt-css'
grunt_tasks.push 'cssmin'

cssmin_config = 
  all_min:
    src: "#{output_directory}css/all.css"
    dest:"#{output_directory}css/all-min.css"

grunt_config['cssmin'] = cssmin_config

# 输出给Grunt使用的函数
module.exports = (grunt) ->

  # 载入包信息
  grunt_config['pkg'] = grunt.file.readJSON 'package.json'

  #初始化配置
  grunt.initConfig grunt_config

  #载入对应库文件
  grunt.loadNpmTasks task for task in grunt_modules

  grunt.registerTask('default', grunt_tasks);

  #无返回值
  return
