module Alcms
  class BlocksController < Alcms::ApplicationController
    def save
      prepare_drafts
      @blocks.each(&:save!)
      render json: { success: true }
    end

    def publish
      prepare_drafts
      @blocks.each(&:publish!)
      render json: { success: true }
    end

    private

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
        :starts_at,
        :expires_at,
        texts_attributes: [
          :id,
          :name,
          :content_draft
        ]
      ])
    end
  end
end
