module Alcms
  class BlockJsonRenderer
    include Alcms::BlockRenderer::Concern

    def initialize(block)
      @block = block
      @block_name = block.name
    end

    def render
      result = @block.as_json
      result['versions'] = versions
      result['texts'] = texts
      result['clone_path'] = get_url('clone')
      result['destroy_path'] = get_url('destroy')
      result
    end

    private

    def texts
      @block.texts.map do |text|
        {
          id: text.id,
          name: text.name
        }
      end
    end
  end
end
