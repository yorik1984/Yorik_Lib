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

# Library of core shared methods used by other extensions.
# Usage only for SketchUp plugins development.
#
# @author Yurij Kulchevich aka yorik1984
module YorikTools::YorikLib

  # @!group Components and groups Methods

  # Get definition of the entity
  #
  # @param entity [Sketchup::Entity] any entity in the model
  # @return [Sketchup::ComponentDefinition or NilClass] definition of the entity
  # @since 1.0
  def get_definition(entity)
    if entity.is_a?(Sketchup::ComponentInstance)
      entity.definition
    elsif entity.is_a?(Sketchup::Group)
      entity.entities.parent
    else
      nil
    end
  end

  # Recursive method to get maximum nested level in selected components
  #
  # @param selection [Sketchup::Selection] Selected components of the model
  # @param deep_level [Numeric] Temp variable.
  #        Default is parent deep level of the model
  # @param nesting_levels [Array] Collection of every nested level from
  #        maximum deep levels in the model components collection.
  #        Default are parent nested level of the model
  #
  # @return [Numeric] Biggest nested level of components nesting levels
  # @since 1.0
  def nested_level(selection, deep_level = 1, nesting_levels = [1])
    selection.each do |entity|
      definition = YorikLib::get_definition(entity)
      next if definition.nil?
      nesting_levels.push(deep_level + 1)
      nested_level(definition.entities, deep_level + 1, nesting_levels)
    end
    nesting_levels.sort.last
  end

  # Recursive method to get collection of components with attributes from list
  #
  # @param selection [Sketchup::Selection] Selected components of the model
  # @param attribute_list [Array] list of special attributes
  # @param nested_level [Numeric] maximum nested level for collecting components
  # @param dictionary_name [String] the name of an attribute dictionary attached
  #        to an Entity
  # @param components_list [Array] empty array before start for doing collection
  # @param current_nested_level [Numeric] nested level of current entity
  #
  # @return [Array] collection of components contain attributes from list
  # @see nested_level
  # @since 1.0
  def collect_by_attribute(selection, attribute_list, nested_level,
                           dictionary_name = "dynamic_attributes",
                           components_list = [], current_nested_level = 2)
    selection.each do |entity|
      definition = YorikLib::get_definition(entity)
      next if definition.nil?
      if current_nested_level <= nested_level &&
           definition == Sketchup::ComponentInstance
        attribute_list.each do |attribute_name|
          if YorikLib::attributes_list(entity).include?(attribute_name.downcase)
            components_list.push entity
            break
          end
        end
      end
      components_list = collect_by_attribute(definition.entities, attribute_list, nested_level, dictionary_name, components_list, current_nested_level + 1)
    end
    components_list
  end

  #
  # Generate collection of all components attributes from dictionary attached to
  # the entity
  # @param entity [Sketchup::Entity] any entity of the model
  # @param dictionary_name [String] the name of an attribute dictionary attached
  #        to an Entity
  #
  # @return [Array] list of all attributes
  # @since 1.0
  def attributes_list(entity, dictionary_name = "dynamic_attributes")
    list = {}
    if entity.is_a?(Sketchup::ComponentInstance)
      entity = entity.definition
      if entity.attribute_dictionaries
        if entity.attribute_dictionaries[dictionary_name]
          dictionary = entity.attribute_dictionaries[dictionary_name]
          dictionary.each_keys { |key| list[key] = true if (key[0..0] != '_') }
        end
      end
    end
    list.keys
  end

  # Get value of components attributes from dictionary attached to the entity
  # @param entity [Sketchup::Entity] any entity of the model
  # @param name [String] attribute name
  # @param dictionary_name [String] the name of an attribute dictionary attached
  #        to an Entity
  #
  # @return [String] the retrieved value
  # @since 1.0
  def attribute_value(entity, name, dictionary_name = "dynamic_attributes")
    name = name.downcase
    if entity.is_a?(Sketchup::ComponentInstance)
      value = entity.get_attribute dictionary_name, name
      if value == nil
        value = entity.definition.get_attribute(dictionary_name, name)
      end
      return value
    elsif entity.is_a?(Sketchup::ComponentDefinition)
      return entity.get_attribute(dictionary_name, name)
    else
      return nil
    end
  end

  # Show message box when selected entities are not only components or select
  # nothing
  #
  # @param selection [Sketchup::Entity] selected entities of the model
  # @param msg_components [String] error message
  # @param msg_nothing [String] error message
  # @return [Boolean] true when only components, false in other case with
  #         showing message box with error message
  # @since 1.0
  def components_selected_mbox?(selection,
                                msg_components = "Select only components",
                                msg_nothing = "Nothing selected")
    if selection.empty?
      UI.messagebox msg_nothing
      return false
    end
    selection.each do |entity|
      if !entity.is_a?(Sketchup::ComponentInstance)
        UI.messagebox msg_components
        return false
      end
    end
    true
  end

  # @!endgroup

  # @!group Informations Methods

  # Show information about plugin in message box
  # @param plugin_id [String] use PLUGIN_ID from loader script for plugin.
  #        Generally it's name of script's module name space
  #
  # @return [Sketchup::UI] message box with author name and short description
  # @since 1.0
  def about_information(plugin_id)
    plugin_id_name =
      Object.const_get "YorikTools::#{plugin_id}::PLUGIN_NAME"
    plugin_id_description =
      Object.const_get "YorikTools::#{plugin_id}::PLUGIN_DESCRIPTION"
    UI.messagebox(plugin_id_name + "\n" + plugin_id_description + "\n" +
                  YorikTools::PLUGIN_COPYRIGHT)
  end

  # Open help page in new tab of current web browser
  # @param plugin_id [String] use PLUGIN_ID from loader script for plugin.
  #        Generally it's name of script's module name space
  # @param msg_error [String] open error message
  #
  # @since 1.0
  def help_information(plugin_id, msg_error = "Error opening help page")
    plugin_file_core_name = plugin_id.downcase
    plugins = Sketchup.find_support_file "Plugins/"
    help_file_folder = "yorik_#{plugin_file_core_name}/help/"
    help_file = File.join(plugins, help_file_folder, "help.html" )
    if help_file
      UI.openURL "file://" + help_file
    else
      UI.messagebox msg_error
    end
  end

  # @!endgroup

end # module YorikLib
