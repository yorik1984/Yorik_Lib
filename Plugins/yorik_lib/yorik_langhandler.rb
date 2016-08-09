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

# Rewriting of basic Sketchup API class to make locales for plugins
# using default language. Parent for YorikLanguageHandler class.
#
# @author Yurij Kulchevich aka yorik1984
# @since 1.0
# @see http://www.sketchup.com/intl/en/developer/docs/ourdoc/languagehandler
# @see YorikLanguageHandler

class YorikLanguageHandlerDefault

  attr_reader :strings, :lh_data

  # initialize method
  # @param lh_data [Hash] input data for make locale
  #
  # @since 1.0
  def initialize(lh_data)
    @lh_data = lh_data
    @default_lang_name = @lh_data[:default_lang_name]
    @default_locale    = @lh_data[:default_locale]
    @lang_ini_name     = @lh_data[:lang_ini_name]
    @locale_file_type  = @lh_data[:locale_file_type]
    @resources_dir     = @lh_data[:RESOURCES_DIR]
    @plugin_id         = @lh_data[:PLUGIN_ID]
    @lh_errors_file    = @lh_data[:lh_errors_file]
    @strings           = Hash.new { |hash, key| key }
    check_default_ini_file
    parse
  end

  # Geting this file name
  #
  # @return [String] file name
  # @since 1.0
  def self.self_file_name
    File.basename(__FILE__, ".*")
  end

  # Checking path to .ini file with locale code. When file does not
  # exists it will be created with default language locale code.
  #
  # @since 1.0
  def check_default_ini_file
    @lang_ini_path = File.join(@resources_dir, @lang_ini_name)
    unless File.exist?(@lang_ini_path)
      File.open(@lang_ini_path, 'w') { |file|
         file.write(@default_locale) }
    end
  end

  # Finding path for .string with message errors file of default locale
  #
  # @since 1.0
  def find_strings_file
    File.join(@resources_dir, @default_locale, @lh_errors_file + @locale_file_type)
  end

  # @param [String] key
  #
  # @return [String]
  # @since SketchUp 2014
  def [](key)
    value = @strings[key]
    if value.is_a?(String)
      value = value.dup
    end
    return value
  end

  private

  # @return [String, Nil]
  # @since SketchUp 2014
  def parse
    strings_file = find_strings_file
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

end # class YorikLanguageHandlerDefault

# Rewriting of basic Sketchup API class to make locales for plugins.
#
# @author Yurij Kulchevich aka yorik1984
# @since 1.0
# @see YorikLanguageHandlerDefault
class YorikLanguageHandler < YorikLanguageHandlerDefault

  attr_reader :lh_data, :locale

  # Initializing object of YorikLanguageHandler class.
  #
  # @see YorikLanguageHandlerDefault::initialize
  # @since 1.0
  def initialize(lh_data)
    @lh_data = lh_data
    super(lh_data)
    dir_locale_list
    make_error_string
  end

  # Stack of translated errors messages for service using.
  #
  # @since 1.0
  def make_error_string
    @yorik_inner_lib_lh = YorikLanguageHandlerDefault.new(lh_data)
    @msg_errors = { first_line: @yorik_inner_lib_lh["Empty locale name in 1st line in file(s):"] + "\n",
           wrong_strings_files: "",
                   locale_code: @yorik_inner_lib_lh["It will be using locale code in language selector. "] + @yorik_inner_lib_lh["Please, see more in help."],
               missing_strings: @yorik_inner_lib_lh["Missing .strings files:"] + "\n",
         missing_strings_files: "",
                unusing_string: @yorik_inner_lib_lh["Translate for this language(s) will be not supporting."] }
  end

  # Making list of directories in "Resources" folder.
  #
  # @return [Array] sorting dir list
  # @since 1.0
  def dir_locale_list
    entries = Dir.entries(@resources_dir)
    entries.delete_if { |elem| elem == "." || elem == ".." }
    sud_dir_locale_list = []
    entries.each do |entrie|
      sub_dir = File.join(@resources_dir, entrie)
      sud_dir_locale_list.push entrie if Dir.exist?(sub_dir)
    end
    @dir_locale_list = sud_dir_locale_list.sort!
  end

  # Associate locale code(dir name) with language name which can be finding in .strings.
  # Adding dir only with valid existing .strings.
  #
  # @return [Hash] Locale with language name from 1st line of .strings
  #                or locale with locale instead language name when 1st line empty
  #                or not include language name
  # @since 1.0
  def make_name_with_locale
    name_with_locale = {}
    @dir_locale_list.each do |dir|
      strings_file_path = File.join(@resources_dir, dir, @plugin_id + @locale_file_type)
      strings_file_name = strings_file_path.to_s + "\n"
      unless File.exist?(strings_file_path)
        @strings_file_missing_error = true
        missing_strings_files = { missing_strings_files: strings_file_name }
        @msg_errors.merge!(missing_strings_files)
        next
      end
      line = File.open(strings_file_path, 'r:BOM|UTF-8').readlines[0]
      scan_slash = line.scan(/(\/\/)/)
      scan_word  = line.scan(/[[:word:]]/)
      scan_slash = [[""]] if scan_slash[0].nil?
      if scan_slash[0].join == "//" && scan_word.size != 0
        name_with_locale[dir] = scan_word.join
      else
        name_with_locale[dir] = dir
        wrong_strings_files = { wrong_strings_files: strings_file_name }
        @msg_errors.merge!(wrong_strings_files)
        @strings_error = true
      end
    end
    name_with_locale
  end

  # Write selected locale to file
  # @param current_locale [String] current locale code(dir name)
  #
  # @since 1.0
  def write_locale_to_file(current_locale)
    File.open(@lang_ini_path, 'w'){ |file| file.write current_locale}
  end


  # Finding strings file using locale data
  #
  # @return [String] .strings file path for current locale
  # @since 1.0
  def find_strings_file
    locale = ""
    line = File.open(@lang_ini_path, 'r:BOM|UTF-8').readlines[0]
    locale = line.chomp
    @locale = locale
    strings_file =
        File.join(@resources_dir, locale, @plugin_id + @locale_file_type)
    return strings_file if File.exist?(strings_file)
    @strings_file_missing_error = true
    @locale = @default_locale
    write_locale_to_file(@default_locale)
    strings_file =
        File.join(@resources_dir, @default_locale, @plugin_id + @locale_file_type)
  end

  # Create Sketchup inputbox with parameters
  # @param inputbox_window_name [String] Inputbox window name, list of languages name
  #
  # @return [Sketcup::UI] inputbox
  # @since 1.0
  def locale_mbox(inputbox_window_name)
    locale_dir_locale_list = make_name_with_locale
    current_locale = @default_locale
    UI.messagebox(@msg_errors[:missing_strings] +
                  @msg_errors[:missing_strings_files] +
                  @msg_errors[:unusing_string]) if @strings_file_missing_error
    UI.messagebox(@msg_errors[:first_line] +
                  @msg_errors[:wrong_strings_files] +
                  @msg_errors[:locale_code]) if @strings_error
    @strings_error              = false
    @strings_file_missing_error = false
    prompts = [inputbox_window_name]
    defaults = []
    defaults[0] = @default_lang_name
    list = []
    list[0] = ""
    locale_dir_locale_list.each_value { |value|
      list[0] = list[0] + value.to_s + "|" }
    inputbox = UI.inputbox(prompts, defaults, list, inputbox_window_name)
    current_locale = locale_dir_locale_list.key(inputbox[0]).to_s
    write_locale_to_file(current_locale) unless inputbox[0].nil?
  end

end # class YorikLanguageHandler

