RSpec.describe ImplicitSchema do
  subject { described_class.new(data) }

  RSpec::Matchers.define(:have_implicit_schema) do
    match do |value|
      # With BasicObject, the only way to check that we have wrapped is to call
      # a method we know we've overridden.
      s = value.inspect
      s.start_with?('<<') && s.end_with?('>>')
    end
  end

  context 'with a basic hash' do
    let(:data) { { a: 1, b: '2', c: [3] } }

    it 'returns values' do
      expect(subject[:a]).to eq(1)
      expect(subject[:b]).to eq('2')
      expect(subject[:c]).to eq([3])
    end

    it 'raises an exception for missing key' do
      expect { subject[:d] }
        .to raise_error(ImplicitSchema::ValidationError,
                        'Missing key: `:d` - available keys: (:a, :b, :c)')
    end
  end

  context 'with an array of objects' do
    let(:data) do
      {
        a: [
          { x: 1, y: 2, z: 3 },
          { x: 4, y: 5, z: 6 }
        ]
      }
    end

    it 'wraps the objects' do
      expect(subject[:a]).to all have_implicit_schema
    end

    it 'preserves the data' do
      a0, a1 = subject[:a]
      expect(a0[:x] + a0[:y] + a0[:z]).to eq(6)
      expect(a1[:x] + a1[:y] + a1[:z]).to eq(15)
    end

    it 'raises an exception for deep missing key' do
      expect { subject[:a][0][:w] }
        .to raise_error(ImplicitSchema::ValidationError,
                        'Missing key: `:w` - available keys: (:x, :y, :z)')
    end
  end

  context 'with objects as values' do
    let(:data) { { a: { b: { c: 1 } } } }

    it 'wraps the objects' do
      expect([subject, subject[:a], subject[:a][:b]])
        .to all have_implicit_schema
    end

    it 'raises an exception for deep missing key' do
      expect { subject[:a][:b][:d] }
        .to raise_error(ImplicitSchema::ValidationError,
                        'Missing key: `:d` - available keys: (:c)')
    end
  end
end
