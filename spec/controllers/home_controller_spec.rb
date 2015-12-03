require 'spec_helper'

describe HomeController, type: :controller do
  render_views

  describe "general rendering" do
    it "renders nothing if there is no block and placeholder" do
      get :empty_block
      expect(response).to be_success
    end

    it "renders placeholder" do
      get :index
      expect(response).to be_success
      expect(response.body).to match('placeholder')
    end

    it "renders test block" do
      text = create(:hello_text)
      get :index
      expect(response.body).to match(text.content)
    end
  end

  describe "blocks in time" do
    let!(:past_text){ create :past_text }
    let!(:future_text){ create :past_text }

    it "renders placeholder when there is no actual block" do
      get :index
      expect(response.body).not_to match(future_text.content)
      expect(response.body).not_to match(past_text.content)
      expect(response.body).to match('placeholder')
    end

    it "renders present block" do
      text = create(:present_text)
      get :index
      expect(response.body).not_to match(future_text.content)
      expect(response.body).not_to match(past_text.content)
      expect(response.body).not_to match('placeholder')
      expect(response.body).to match(text.content)
      text.block.destroy!
    end

    it "renders n/a - n/a block" do
      text = create(:hello_text)
      get :index
      expect(response.body).not_to match(future_text.content)
      expect(response.body).not_to match(past_text.content)
      expect(response.body).not_to match('placeholder')
      expect(response.body).to match(text.content)
      text.block.destroy!
    end
  end
end
