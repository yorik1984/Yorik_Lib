# Copyright 2016, Yurij Kulchevich aka yorik1984
# All Rights Reserved
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
# FITNESS FOR A PARTICULAR PURPOSE.
# ------------------------------------------------------------------------------
# Using ideas from source code
# Thomas Thomassen
# thomas[at]thomthom[dot]net
# ------------------------------------------------------------------------------
# License: GPL V.3
# Author: Yurij Kulchevich aka yorik1984
# Name: yorik_lib_core.rb
# Version: 1.0
# Description: Library of core shared functions used by other extensions
# Usage: Only for own plugin development. Not for users
# History:
# 1.0 Initial release 14-July-2016
# ------------------------------------------------------------------------------
require 'sketchup.rb'
require 'extensions.rb'

module YorikTools

  module YorikLib

    ### COMPONENTS AND GROUPS ###

    # @since 1.0
    def self.get_definition(entity)
      if entity.is_a?(Sketchup::ComponentInstance)
        entity.definition
      elsif entity.is_a?(Sketchup::Group)
        entity.entities.parent
      else
        nil
      end
    end

    # @since 1.0
    def self.include_element?(array, element)
      array.each_index do |index|
        if array[index] == element
          return true
        end
      end
      return false
    end

    # @since 1.0
    def self.recursive_level_search(selection, level = 1)
      selection.each do |entity|
        definition = get_definition(entity)
        next if definition.nil?
        recursive_level_search(definition.entities, level+1) + 1
      end
      @recursive_level = level if level > @recursive_level
      return 1
    end

    # @since 1.0
    def self.select_components_messagebox?(selection,msg_components = "Select only components",msg_nothing = "Select nothing")
      if !selection.empty?
        selection.each do |entity|
          if !entity.is_a?(Sketchup::ComponentInstance)
            UI.messagebox msg_components
            return false
          end
        end
      else
        UI.messagebox msg_nothing
        return false
      end
      true
    end

    ### MEASUREMENT ##

    ### INFO ###

    # @since 1.0
    def self.about_information(plugin_id)
      plugin_id_name = Object.const_get "YorikTools::#{plugin_id}::PLUGIN_NAME"
      plugin_id_description = Object.const_get "YorikTools::#{plugin_id}::PLUGIN_DESCRIPTION"
      UI.messagebox plugin_id_name + "\n" + plugin_id_description + "\n" + YorikTools::PLUGIN_COPYRIGHT
    end

    # @since 1.0
    def self.help_information(plugin_id,msg_failure = "Failure")
      # open help content in browser
      plugin_file_core_name = plugin_id.downcase
      plugins = Sketchup.find_support_file "Plugins/"
      help_file_folder = "#{plugin_file_core_name}/help/"
      help_file = File.join(plugins, help_file_folder, "help.html" )
      if (help_file)
        UI.openURL "file://" + help_file
      else
        UI.messagebox msg_failure
      end
    end

  end # module YorikLib

end # module YorikTools

