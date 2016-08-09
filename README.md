Yorik Lib
=========
Library of core shared functions used by other extensions. Usage only for SketchUp plugins development. Contain classes, methods, constants. Also have classes for making plugin translation. Most of them Included in modules:

```ruby
module YorikLib
```

and classes

```ruby
class YorikLanguageHandlerDefault
class YorikLanguageHandler
```

Directories list
----------------
#### `Plugins/yorik_lib/Resources`
Include .strings file for YorikTools plugins translation.

#### `Plugins/yorik_lib/help`
Include help file for YorikTools plugins.

Files list
----------------

#### `Plugins/yorik_lib.rb`

*Loader for YorikLib `Plugins/yorik_lib/yorik_lib_core.rb`*
Include basic constants and methods to load YorikLib into SketchUp.

```ruby
module YorikTools
module YorikLibLoader
```

**Constants**

```ruby
FILENAMESPACE
PATH_ROOT
PATH
PLUGIN_COPYRIGHT
PLUGIN_CREATOR
PLUGIN_ID
PLUGIN_NAME
PLUGIN_VERSION
RESOURCES_DIR
```

#### `Plugins/yorik_lib/yorik_lib_core.rb`
    
Include basic methods to make user menu and load YorikLib into SketchUp.

```ruby
module YorikTools::YorikLibLoader
```


#### `Plugins/yorik_lib/yorik_lib_main_collection.rb`
*Library of core shared methods*

```ruby
module YorikLib
```

**Methods**

```ruby
def self.get_definition
def self.nested_level
def self.collect_by_attribute
def self.attributes_list
def self.attribute_value
def self.components_selected_mbox?
def self.about_information
def self.open_help_file
```

#### `yorik_lib/yorik_langhandler`
*Rewriting of basic Sketchup API class [LanguageHandler](http://www.sketchup.com/intl/en/developer/docs/ourdoc/languagehandler) to make translations for plugins* 

**Class**

```ruby
class YorikLanguageHandlerDefault
class YorikLanguageHandler
```

 Yardoc documentation in: 

DOCUMENTATION
---------

For more information see [YorikLib](http://www.rubydoc.info/github/yorik1984/Yorik_Lib/index) on [rubydoc.info](http://www.rubydoc.info)

CHANGELOG
---------

See [HISTORY](HISTORY.md)

LICENSE
-------

Licensed under the [GPLv3](https://www.gnu.org/licenses/gpl-3.0.txt).

> Copyright 2016 by  [Yurij Kulchevich](mailto:yorik1984@gmail.com) aka yorik1984
>
> This file is part of Yorik Lib.
>
> Yorik Lib is free software: you can redistribute it and/or modify
> it under the terms of the GNU General Public License as published by
> the Free Software Foundation, either version 3 of the License, or
> (at your option) any later version.
>
> Yorik Lib is distributed in the hope that it will be useful,
> but WITHOUT ANY WARRANTY; without even the implied warranty of
> MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> GNU General Public License for more details.
>
> You should have received a copy of the GNU General Public License
> along with Yorik Lib.  If not, see <http://www.gnu.org/licenses/>.
> 

---
Special thanks for Thomas Thomassen:
* [GitHub](https://github.com/thomthom)
* [Homepage](http://www.thomthom.net/)
