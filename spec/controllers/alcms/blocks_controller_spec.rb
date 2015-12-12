require 'spec_helper'

describe Alcms::BlocksController, type: :controller do
  routes { Alcms::Engine.routes }

  render_views

  new_content = 'new text content'
  new_starts_at = 2.days.ago.change(usec: 0)
  new_expires_at = 2.days.from_now.change(usec: 0)
  new_block_name = 'new-block'
  new_text_name = 'new-text'

  def get_params(block, text)
    {
      blocks: [
        id: block.try(:id),
        name: block.try(:name),
        texts_attributes: { id: text.try(:id), name: text.try(:name) }
      ]
    }
  end

  describe "saving" do
    let!(:text){ create :hello_text }
    let!(:block){ text.block }
    let!(:params) do
      result = get_params(block, text)
      b = result[:blocks][0]
      b[:texts_attributes][:content] = b[:texts_attributes][:content_draft] = new_content
      b[:starts_at] = b[:starts_at_draft] = new_starts_at
      b[:expires_at] = b[:expires_at_draft] = new_expires_at
      result
    end

    it "saves text to content_draft" do
      post(:save, params)
      text.reload
      expect(response).to be_success
      expect(text.content_draft).to eq(new_content)
    end

    it "doesn't save to content anything" do
      post(:save, params)
      text.reload
      expect(response).to be_success
      expect(text.content).not_to eq(new_content)
    end

    it "saves draft dates" do
      post(:save, params)
      block.reload
      expect(block.starts_at_draft).to eq(new_starts_at)
      expect(block.expires_at_draft).to eq(new_expires_at)
    end

    it "doesn't save to real dates anything" do
      post(:save, params)
      block.reload
      expect(block.starts_at).not_to eq(new_starts_at)
      expect(block.expires_at).not_to eq(new_expires_at)
    end
  end

  describe "publishing" do
    let!(:text){ create :hello_text }
    let!(:block){ text.block }
    let!(:params) do
      result = get_params(block, text)
      b = result[:blocks][0]
      b[:texts_attributes][:content] = b[:texts_attributes][:content_draft] = new_content
      b[:starts_at] = b[:starts_at_draft] = new_starts_at
      b[:expires_at] = b[:expires_at_draft] = new_expires_at
      result
    end

    it "publish draft content" do
      post("publish", params)
      text.reload
      expect(response).to be_success
      expect(text.content).to eq(new_content)
    end

    it "publish draft dates" do
      post("publish", params)
      block.reload
      expect(response).to be_success
      expect(block.starts_at).to eq(new_starts_at)
      expect(block.expires_at).to eq(new_expires_at)
    end
  end

  describe "creating blocks" do
    let!(:params) do
      b = Alcms::Block.new(name: new_block_name)
      t = Alcms::Text.new(name: new_text_name)
      result = get_params(b, t)
      result[:blocks][0][:texts_attributes][:content_draft] = new_content
      result
    end

    it "creates a new block with text" do
      blocks_count = Alcms::Block.count
      texts_count = Alcms::Text.count

      post(:save, params)

      block = Alcms::Block.last
      text = Alcms::Text.last

      expect(response).to be_success
      expect(Alcms::Block.count).to eq(blocks_count + 1)
      expect(Alcms::Text.count).to eq(texts_count + 1)
      expect(block.name).to eq(new_block_name)
      expect(text.name).to eq(new_text_name)
      expect(text.content_draft).to eq(new_content)
    end

    it "creates and publishes a new block with text" do
      blocks_count = Alcms::Block.count
      texts_count = Alcms::Text.count

      post(:publish, params)

      block = Alcms::Block.last
      text = Alcms::Text.last

      expect(response).to be_success
      expect(Alcms::Block.count).to eq(blocks_count + 1)
      expect(Alcms::Text.count).to eq(texts_count + 1)
      expect(block.name).to eq(new_block_name)
      expect(text.name).to eq(new_text_name)
      expect(text.content).to eq(new_content)
    end
  end
end
