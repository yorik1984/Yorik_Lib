# Loader for yorik_lib/yorik_lib_core.rb

require 'sketchup.rb'
require 'extensions.rb'

module YorikTools

  PLUGIN_COPYRIGHT = '© by Yurij Kulchevich aka yorik1984'.freeze
  PLUGIN_CREATOR   = 'Yurij Kulchevich aka yorik1984'.freeze

  module YorikLib
    PLUGIN_ID          = 'YorikLib'.freeze
    PLUGIN_NAME        = 'Yorik Lib'.freeze
    PLUGIN_DESCRIPTION = 'Library of shared functions used by other extensions'.freeze
    PLUGIN_VERSION     = '1.0'.freeze

    FILENAMESPACE = File.basename(__FILE__, '.*')
    PATH_ROOT     = File.dirname(__FILE__).freeze
    PATH          = File.join(PATH_ROOT, FILENAMESPACE).freeze

    unless file_loaded?(__FILE__)
      loader                = File.join( PATH, FILENAMESPACE + '_core.rb' )
      yorik_lib             = SketchupExtension.new(PLUGIN_NAME, loader)
      yorik_lib.description = PLUGIN_DESCRIPTION
      yorik_lib.version     = PLUGIN_VERSION
      yorik_lib.copyright   = YorikTools::PLUGIN_COPYRIGHT
      yorik_lib.creator     = YorikTools::PLUGIN_CREATOR
      Sketchup.register_extension(yorik_lib, true)
    end

  end # module YorikLib

end # module YorikTools

file_loaded(__FILE__)
