Yorik Lib
=========
Library of core shared functions used by other extensions.Usage only for SketchUp plugins development. Contain classes, methods, constants. Included in modules:


```ruby
module YorikTools
module YorikTools::YorikLib
```

Files in project
----------------

#### `yorik_lib.rb`

*Loader for `yorik_lib/yorik_lib_core.rb`*

**Constants**

```ruby
PLUGIN_COPYRIGHT
PLUGIN_CREATOR
```

#### `yorik_lib/yorik_lib_core.rb`
*Library of core shared methods*

**Methods**

```ruby
def get_definition
def nested_level
def collect_by_attribute
def attributes_list
def attribute_value
def components_selected_mbox?
def about_information
def help_information
```

#### `yorik_lib/yorik_langhandler`
*Rewriting of basic Sketchup API class [LanguageHandler](http://www.sketchup.com/intl/en/developer/docs/ourdoc/languagehandler) to make translations for plugins* 

**Class**

```ruby
class YorikLanguageHandler
```

For more information see [Yardoc documentation](../doc/_index.html)

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
