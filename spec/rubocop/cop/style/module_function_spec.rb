# frozen_string_literal: true

require 'spec_helper'

describe RuboCop::Cop::Style::ModuleFunction, :config do
  subject(:cop) { described_class.new(config) }

  context 'when enforced style is `module_function`' do
    let(:cop_config) { { 'EnforcedStyle' => 'module_function' } }

    it 'registers an offense for `extend self` in a module' do
      inspect_source(cop,
                     ['module Test',
                      '  extend self',
                      '  def test; end',
                      'end'])
      expect(cop.messages).to eq([described_class::MODULE_FUNCTION_MSG])
      expect(cop.highlights).to eq(['extend self'])
    end

    it 'accepts `extend self` in a class' do
      inspect_source(cop,
                     ['class Test',
                      '  extend self',
                      'end'])
      expect(cop.offenses).to be_empty
    end
  end

  context 'when enforced style is `extend_self`' do
    let(:cop_config) { { 'EnforcedStyle' => 'extend_self' } }

    it 'registers an offense for `module_function` without an argument' do
      inspect_source(cop,
                     ['module Test',
                      '  module_function',
                      '  def test; end',
                      'end'])
      expect(cop.messages).to eq([described_class::EXTEND_SELF_MSG])
      expect(cop.highlights).to eq(['module_function'])
    end

    it 'accepts module_function with an argument' do
      inspect_source(cop,
                     ['module Test',
                      '  def test; end',
                      '  module_function :test',
                      'end'])
      expect(cop.offenses).to be_empty
    end
  end
end
