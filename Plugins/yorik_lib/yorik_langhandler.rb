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
require 'sketchup.rb'
require 'extensions.rb'

module YorikTools::YorikLib

  class YorikLanguageHandler

    def initialize(strings_file_name, translation = 'en')
      unless strings_file_name.is_a?(String)
        raise ArgumentError, 'must be a String'
      end
      @strings = Hash.new { |hash, key| key }
      stack = caller_locations(1, 1)
      if stack && stack.length > 0 && File.exist?(stack[0].path)
        extension_path = stack[0].path
      else
        extension_path = nil
      end
      parse(strings_file_name, extension_name, extension_path, translation)
    end

    def [](key)
      value = @strings[key]
      if value.is_a?(String)
        value = value.dup
      end
      return value
    end

    alias :GetString :[]

    def resource_path(file_name)
      unless file_name.is_a?(String)
        raise ArgumentError, 'must be a String'
      end
      if @language_folder
        file_path = File.join(@language_folder, file_name)
        if File.exists?(file_path)
          return file_path
        end
      end
      return ''
    end

    alias :GetResourcePath :resource_path

    def strings
      return @strings
    end

    alias :GetStrings :strings

    def strings_file
      @strings_file ? @strings_file.dup : nil
    end

    private

    def find_strings_file(strings_file_name, extension_name,
                          extension_file_path = nil, translation)
      plugins = Sketchup.find_support_file "Plugins/"
      strings_file_path = ''
      if extension_file_path
        file_type = File.extname(extension_file_path)
        basename = File.basename(extension_file_path, file_type)
        extension_path = File.dirname(extension_file_path)
        resource_folder_path = File.join(extension_path, basename, 'Resources')
        resource_folder_path = File.expand_path(resource_folder_path)
        strings_file_path = File.join(resource_folder_path, translation,
          strings_file_name)
        if File.exists?(strings_file_path) == false
          strings_file_path = File.join(resource_folder_path, translation,
            strings_file_name)
        end
      end
      if File.exists?(strings_file_path) == false
        strings_file_path = Sketchup.get_resource_path(strings_file_name)
      end
      if strings_file_path && File.exists?(strings_file_path)
        return strings_file_path
      else
        return nil
      end
    end

    def parse(strings_file_name, extension_name, extension_file_path = nil,
              translation)
      strings_file = find_strings_file(strings_file_name, extension_name,
                                       extension_file_path, translation)
      if strings_file.nil?
        return false
      end
      @strings_file = strings_file
      @language_folder = File.expand_path(File.dirname(strings_file))
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
