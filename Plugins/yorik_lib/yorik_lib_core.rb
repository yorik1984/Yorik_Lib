# Copyright 2016 by Yurij Kulchevich aka yorik1984
#
# This file is part of "Yorik Lib".
#
# "Yorik Lib" is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License.
#
# "Yorik Lib" is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with "Yorik Lib".  If not, see <http://www.gnu.org/licenses/>.
# ------------------------------------------------------------------------------
# Copyright 2012, Trimble Navigation Limited
#
# This software is provided as an example of using the Ruby interface
# to SketchUp.
#-------------------------------------------------------------------------------
# Using ideas from source code
# Thomas Thomassen
# thomas[at]thomthom[dot]net
# ------------------------------------------------------------------------------
# License GPLv3
# Version: 1.0
# History:
# - 1.0 Initial release 14-July-2016
# ------------------------------------------------------------------------------
require "sketchup.rb"
require "extensions.rb"

require_relative "yorik_langhandler"
require_relative "yorik_lib_main_collection"

# Loader of YorikLib in Sketchup - library of core shared methods.
#
# @see YorikTools::YorikLib
# @author Yurij Kulchevich aka yorik1984
module YorikTools::YorikLibLoader

  yorik_lib_lh_data = { PLUGIN_ID:         PLUGIN_ID,
                        RESOURCES_DIR:     RESOURCES_DIR,
                        default_lang_name: "English",
                        default_locale:    "en_US",
                        lang_ini_name:     "lang.ini",
                        locale_file_type:  ".strings",
                        lh_errors_file:    "LanguageHandler" }

  yorik_lib_lh = YorikLanguageHandler.new(yorik_lib_lh_data)
  plugin_description = yorik_lib_lh["Library of shared functions used by other extensions"]
  @yorik_lib.description = plugin_description

  unless file_loaded?(__FILE__)
    tools_menu = UI.menu("Tools")
    yorik_lib_menu = tools_menu.add_submenu("Yorik Lib")
    yorik_lib_lh_menu = yorik_lib_menu.add_submenu(yorik_lib_lh_data[:lh_errors_file])
    yorik_lib_lh_menu.add_item(yorik_lib_lh["Help"]) { YorikLib::open_help_file(PATH, "help/#{YorikLanguageHandler.self_file_name}/help.html", yorik_lib_lh["Error opening help file:"]) }
    yorik_lib_menu.add_item(yorik_lib_lh["Language translation"]) { yorik_lib_lh.localization_mbox(yorik_lib_lh["Language translation"]) }
    yorik_lib_menu.add_item(yorik_lib_lh["Help"]) { YorikLib::open_help_file(PATH, "help/#{FILENAMESPACE}/help.html", yorik_lib_lh["Error opening help file:"]) }
    yorik_lib_menu.add_item(yorik_lib_lh["About..."]) { YorikLib::about_extension_mbox(@yorik_lib) }


  end

end # module YorikLibLoader

file_loaded(__FILE__)
