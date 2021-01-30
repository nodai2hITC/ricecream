# Ricecream (icecream-ruby)

A Ruby port of Python's debugging library [IceCream](https://github.com/gruns/icecream).

## Usage

### Inspect Variables

Have you ever written code like this to debug?

```ruby
foo = 123
puts foo # => 123
# Simple, but we don't know what the output is.

puts "foo: #{foo}" # => foo: 123
# Easy to understand, but coding is boring.
```

With Ricecream, you can easily write:

```ruby
require "ricecream"
foo = 123
ic foo # => ic| foo: 123
```

It can handle multiple arguments and arbitrary expressions.

```ruby
ic foo * 2, Integer.sqrt(foo) # => ic| foo * 2: 246, Integer.sqrt(foo): 11
```

### Inspect Execution

You want to check the operation of the following method.

```ruby
def foo
  return if cond1
  if cond2
    method1
  else
    method2
  end
end
```

Using `puts`, you would write:

```ruby
def foo
  puts 1
  return if cond1
  puts 2
  if cond2
    method1
    puts 3
  else
    method2
    puts 4
  end
end
```

Output

```
1
2
4
```

With Ricecream, you can easily write:

```ruby
def foo
  ic
  return if cond1
  ic
  if cond2
    method1
    ic
  else
    method2
    ic
  end
end
```

Output

```
ic| script.rb:2 in foo at 17:33:40.227
ic| script.rb:4 in foo at 17:33:40.227
ic| script.rb:10 in foo at 17:33:40.228
```

### Return Value

`ic` returns its argument(s), so `ic` can easily be inserted into pre-existing code.

```ruby
foo = 123
def bar(num)
  num * 2
end
result = bar(foo) # I want to know foo value.
puts result # => 246
```

```ruby
foo = 123
def bar(num)
  num * 2
end
result = bar(ic foo) # => ic| foo: 123
puts result # => 246
```

### Refinements

If you want to use `ic` only within a limited scope, then you can use Refinements.

```ruby
require "ricecream/refine"

using Ricecream
ic
```

Similarly, you can override `p` by `using Ricecream::P`.

```ruby
require "ricecream/refine"

using Ricecream::P
foo = 123
p foo # => ic| foo: 123
```

### Miscellaneous

- `ic_format(*args)` is like `ic` but the output is returned as a string instead of written to stderr.
- `ic`'s output can be entirely disabled, and later re-enabled, with `Ricecream.disable` and `Ricecream.enable` respectively.

### Configuration

Change prefix.

```ruby
  Ricecream.prefix = "ic!!!! "
  # => ic!!!! foo: 123

  def Ricecream.prefix(location)
    Time.now.to_s + "| "
  end
  # => 2021-01-25 23:39:25 +0900| foo: 123
```

Change the output destination.

```ruby
  Ricecream.output = STDOUT # default: STDERR

  def Ricecream.output(str)
    @log ||= Logger.new("logfile.log")
    @log.debug(str)
  end
```

Change the string conversion method.

```ruby
  def Ricecream.arg_to_s(arg)
    PP.pp(arg, +"", 60)
  end
```

Output with caller information.

```ruby
  Ricecream.include_context = true # default: false
  # => ic| script.rb:10 in <main>- foo: 123
```

(experimental) colorize.

```ruby
  Ricecream.colorize = true # default: false, required irb >= 1.2.0
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ricecream'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ricecream

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nodai2hITC/ricecream. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nodai2hITC/ricecream/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ricecream project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nodai2hITC/ricecream/blob/master/CODE_OF_CONDUCT.md).
