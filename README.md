# ImplicitSchema

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Dependency Status][DS img]][Dependency Status]
[![Code Climate][CC img]][Code Climate]
[![Coverage Status][CS img]][Code Climate]

[Gem Version]: https://rubygems.org/gems/implicit-schema
[Build Status]: https://codeship.com/projects/91214
[Dependency Status]: https://gemnasium.com/ausaccessfed/implicit-schema
[Code Climate]: https://codeclimate.com/github/ausaccessfed/implicit-schema

[GV img]: https://img.shields.io/gem/v/implicit-schema.svg
[BS img]: https://img.shields.io/codeship/e9441d30-0cd1-0133-3ae6-7aae0ba3591b/develop.svg
[DS img]: https://img.shields.io/gemnasium/ausaccessfed/implicit-schema.svg
[CC img]: https://img.shields.io/codeclimate/github/ausaccessfed/implicit-schema.svg
[CS img]: https://img.shields.io/codeclimate/coverage/github/ausaccessfed/implicit-schema.svg

Lazily and implicitly validate Hash objects (e.g. from `JSON::parse`)

Author: Shaun Mangelsdorf

```
Copyright 2015, Australian Access Federation

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'implicit-schema'
```

Use Bundler to install the dependency:

```
bundle install
```

## Usage

Though tools are available for validating JSON documents, it's often more
convenient to assume the payload is valid and allow an exception to occur if
that's not the case (after all, the result of failed validation is typically an
exception anyway). The only problem with this approach comes when your logic
becomes more complex:

```ruby
class SomeDataProcessor
  def process(data)
    data[:people].each { |p| descend(p) }
  end

  def descend(person)
    person[:employer][:contact][:phone] # NoMethodError: undefined method `[]' for nil:NilClass
  end
end
```

When the error occurs, there's no easy way to know which key was missing and
resulted in the `nil` value.

ImplicitSchema is typically used to wrap the output of JSON parsing. That is:

```ruby
json = '{"a": 1, "b": 2, "c": 3}'
data = JSON.parse(json, symbolize_names: true)
obj = ImplicitSchema.new(data)

obj[:a] # 1
obj[:b] # 2
obj[:d] # ImplicitSchema::ValidationError: Missing key: `:d` - available keys: (:a, :b, :c)
```

Nested Hash objects are automatically wrapped:

```ruby
obj = ImplicitSchema.new(a: { b: { c: 1 } })
obj[:a] # { b: { c: 1 } } (wrapped)
obj[:a][:b] # { c: 1 } (wrapped)
obj[:a][:b][:c] # 1
obj[:a][:b][:d] # ImplicitSchema::ValidationError: Missing key: `:d` - available keys: (:c)
```

Nested Array objects are also processed in the same way:

```ruby
obj = ImplicitSchema.new(a: [
                           { x: 1, y: 2, z: 3 },
                           { x: 4, y: 5, z: 6 }
                         ])
obj[:a] # an Array
obj[:a][0] # { x: 1, y: 2, z: 3 } (wrapped)
obj[:a][0][:x] # 1
obj[:a][0][:w] # ImplicitSchema::ValidationError: Missing key: `:w` - available keys: (:x, :y, :z)
```

## Contributing

Refer to [GitHub Flow](https://guides.github.com/introduction/flow/) for
help contributing to this project.
