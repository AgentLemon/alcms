module Alcms
  class BlocksController < Alcms::ApplicationController
    before_action :check_permissions
    before_action :prepare_drafts, only: [:save, :publish]
    before_action :load_block, only: [:clone, :destroy]

    def save
      @blocks.each(&:save!)
      render_response
    end

    def publish
      @blocks.each(&:publish!)
      render_response
    end

    def clone
      @block.duplicate!
      render json: { success: true }
    end

    def destroy
      @block.destroy
      render json: { success: true }
    end

    private

    def check_permissions
      return head :forbidden unless instance_eval(&Alcms::Engine.can_save)
    end

    def load_block
      @block = Block.find(params[:id])
    end

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
