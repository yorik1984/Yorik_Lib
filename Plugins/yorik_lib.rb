# Copyright 2016 by Yurij Kulchevich aka yorik1984
#
# This file is part of Yorik Lib.
#
# Yorik Lib is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Yorik Lib is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Yorik Lib.  If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------------
# License GPLv3
# Version: 1.0
# Description: Loader for yorik_lib/yorik_lib_core.rb
# History:
# - 1.0 Initial release 14-July-2016
# ------------------------------------------------------------------------------

require "sketchup.rb"
require "extensions.rb"

# Personal name space of yorik1984 in SketchUp plugins development for
# all own plugins
#
# @author Yurij Kulchevich aka yorik1984
module YorikTools

  require "yorik_lib/yorik_langhandler.rb"

  plugins = Sketchup.find_support_file "Plugins/"

  RESOURCE_FOLDER       = File.join(plugins, "yorik_lib", "Resources").freeze
  DEFAULT_LOCALIZATION  = "en-US".freeze
  TRANSLATION_FILE_TYPE = ".strings"
  PLUGIN_COPYRIGHT      = "© by Yurij Kulchevich aka yorik1984".freeze
  PLUGIN_CREATOR        = "© Юрий Кульчевич aka yorik1984".freeze

  # Library of core shared methods used by other extensions.
  # Usage only for SketchUp plugins development.
  #
  # @author Yurij Kulchevich aka yorik1984
  module YorikLib

    require "yorik_lib/yorik_lib_core.rb"

    PLUGIN_ID          = "YorikLib".freeze
    PLUGIN_NAME        = "Yorik Lib".freeze

    @yorik_lib_lh = YorikLanguageHandler.new(PLUGIN_ID)

    PLUGIN_DESCRIPTION = @yorik_lib_lh["Library of shared functions used by other extensions"]
    PLUGIN_VERSION     = "1.0".freeze

    FILENAMESPACE = File.basename(__FILE__, ".*")
    PATH_ROOT     = File.dirname(__FILE__).freeze
    PATH          = File.join(PATH_ROOT, FILENAMESPACE).freeze

    unless file_loaded?(__FILE__)
      loader                = File.join( PATH, FILENAMESPACE + "_core.rb" )
      yorik_lib             = SketchupExtension.new(PLUGIN_NAME, loader)
      yorik_lib.description = PLUGIN_DESCRIPTION
      yorik_lib.version     = PLUGIN_VERSION
      yorik_lib.copyright   = YorikTools::PLUGIN_COPYRIGHT
      yorik_lib.creator     = YorikTools::PLUGIN_CREATOR
      Sketchup.register_extension(yorik_lib, true)
      tools_menu = UI.menu('Tools')
      yorik_lib_menu = tools_menu.add_submenu("Yorik Lib")
      yorik_lib_menu.add_item(@yorik_lib_lh["Localization"]) { YorikLanguageHandler.make_translation_list(@yorik_lib_lh["Localization"]) }
      yorik_lib_menu.add_item(@yorik_lib_lh["About..."]) { self.about_information(PLUGIN_ID) }
    end

  end # module YorikLib

end # module YorikTools

file_loaded(__FILE__)
