# Wraps a Hash object, and raises ImplicitSchema::ValidationError when #[] is
# called with a missing key
class ImplicitSchema < BasicObject
  ValidationError = ::Class.new(::RuntimeError)

  def initialize(hash)
    @hash = hash
  end

  def method_missing(sym, *args, &block)
    @hash.send(sym, *args, &block)
  end

  def [](k)
    return wrap(@hash[k]) if key?(k)
    fail(ValidationError, "Missing key: `#{k.inspect}` - available keys: " \
                          "(#{keys.map(&:inspect).join(', ')})")
  end

  def inspect
    "<<#{@hash.inspect}>>"
  end

  private

  def wrap(v)
    case v
    when ::Array
      v.map { |o| wrap(o) }
    when ::Hash
      ::ImplicitSchema.new(v)
    else
      v
    end
  end
end
