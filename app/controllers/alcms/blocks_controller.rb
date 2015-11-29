module Alcms
  class BlocksController < Alcms::ApplicationController
    def save
      prepare_drafts
      @blocks.each(&:save!)
      render_response
    end

    def publish
      prepare_drafts
      @blocks.each(&:publish!)
      render_response
    end

    private

    def render_response
      render json: { success: true, blocks: blocks_response }
    end

    def blocks_response
      @blocks.map { |block| BlockJsonRenderer.new(block).render }
    end

    def prepare_drafts
      attributes = blocks_params[:blocks]
      @blocks = attributes.map do |b|
        block = b[:id].present? ? Block.find(b[:id]) : Block.new
        block.assign_attributes(b)
        block
      end
    end

    def blocks_params
      params.permit(blocks: [
        :id,
        :name,
        :starts_at_draft,
        :expires_at_draft,
        texts_attributes: [
          :id,
          :name,
          :content_draft
        ]
      ])
    end
  end
end
