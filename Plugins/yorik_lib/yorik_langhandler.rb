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
#-------------------------------------------------------------------------------
# Copyright 2013, Trimble Navigation Limited
# This software is provided as an example of using the Ruby interface
# to SketchUp.
# Permission to use, copy, modify, and distribute this software for
# any purpose and without fee is hereby granted, provided that the above
# copyright notice appear in all copies.
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#-------------------------------------------------------------------------------
# License GPLv3
# Version: 1.0
# History:
# - 1.0 Initial release 14-July-2016
# ------------------------------------------------------------------------------
require "sketchup.rb"
require "extensions.rb"
require "csv"

# Library of core shared methods used by other extensions.
# Usage only for SketchUp plugins development.
#
# @author Yurij Kulchevich aka yorik1984
module YorikTools::YorikLib

  # Rewriting of basic Sketchup API class to make translations for plugins
  #
  # @author Yurij Kulchevich aka yorik1984
  # @since 1.0
  # @see http://www.sketchup.com/intl/en/developer/docs/ourdoc/languagehandler
  class YorikLanguageHandler

    def initialize(plugin_id)
      unless plugin_id.is_a?(String)
        raise ArgumentError, "must be a String"
      end
      @strings = Hash.new { |hash, key| key }
      parse(plugin_id)
    end

    def [](key)
      value = @strings[key]
      if value.is_a?(String)
        value = value.dup
      end
      return value
    end

    def strings
      return @strings
    end

    def self.make_translation_list(inputbox_window_name)
      lang_file_name = File.join(YorikTools::RESOURCE_FOLDER, "lang.ini")
      lang_folder_file_name = File.join(YorikTools::RESOURCE_FOLDER, "lang_folder.csv")
      File.open(lang_file_name).each { |line| translation = line.chomp }
      language_list = {}
      CSV.foreach(lang_folder_file_name, col_sep: ',') do |row|
        language_list[row[1].to_sym] = row[0].to_s
      end
      prompts = [inputbox_window_name]
      defaults = []
      defaults[0] = language_list[(YorikTools::DEFAULT_LOCALIZATION).to_sym]
      list = []
      list[0] = ""
      language_list.each_value { |value| list[0] = list[0] + value.to_s + "|" }
      inputbox = UI.inputbox(prompts, defaults, list, inputbox_window_name)
      current_translation = language_list.key(inputbox[0]).to_s
      File.open(lang_file_name, 'w'){ |file| file.write current_translation}
    end

    def strings_file_path(translation, plugin_id)
      File.join(YorikTools::RESOURCE_FOLDER, translation, plugin_id +
                YorikTools::TRANSLATION_FILE_TYPE)
    end

    def find_strings_file(plugin_id)
      translation = YorikTools::DEFAULT_LOCALIZATION
      lang_file_name = File.join(YorikTools::RESOURCE_FOLDER, "lang.ini")
      File.open(lang_file_name).each { |line| translation = line.chomp }
      strings_file = strings_file_path(translation, plugin_id)
      return strings_file if File.exist?(strings_file)
      strings_file_path(YorikTools::DEFAULT_LOCALIZATION, plugin_id)
    end

    private

    def parse(plugin_id)
      strings_file = find_strings_file(plugin_id)
      if strings_file.nil?
        return false
      end
      File.open(strings_file, 'r:BOM|UTF-8') { |lang_file|
        entry_string = ''
        in_comment_block = false
        lang_file.each_line { |line|
          if !line.lstrip.start_with?('//')
            if line.include?('/*')
              in_comment_block = true
            end
            if in_comment_block
              if line.include?('*/')
                in_comment_block = false
              end
            else
              entry_string += line
            end
          end
          if entry_string.include?(';')
            pattern = /^\s*"(.+)"="(.+)"\s*;\s*(?:\/\/.*)*$/
            result = pattern.match(entry_string)
            if result && result.size == 3
              key = result[1]
              value = result[2]
              @strings[key] = value
            end
            entry_string.clear
          end
        }
      }
      return true
    end

  end # class YorikLanguageHandler

end # module YorikTools::YorikLib
