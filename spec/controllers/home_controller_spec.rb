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
      expect(response).to be_success
      expect(response.body).to match(text.content)
    end
  end

  describe "blocks in time" do
    let!(:past_text){ create :past_text }
    let!(:future_text){ create :past_text }

    it "renders placeholder when there is no actual block" do
      get :index
      expect(response).to be_success
      expect(response.body).not_to match(future_text.content)
      expect(response.body).not_to match(past_text.content)
      expect(response.body).to match('placeholder')
    end

    it "renders present block" do
      text = create(:present_text)
      get :index
      expect(response).to be_success
      expect(response.body).not_to match(future_text.content)
      expect(response.body).not_to match(past_text.content)
      expect(response.body).not_to match('placeholder')
      expect(response.body).to match(text.content)
      text.block.destroy!
    end

    it "renders n/a - n/a block" do
      text = create(:hello_text)
      get :index
      expect(response).to be_success
      expect(response.body).not_to match(future_text.content)
      expect(response.body).not_to match(past_text.content)
      expect(response.body).not_to match('placeholder')
      expect(response.body).to match(text.content)
      text.block.destroy!
    end
  end

  describe "editor rendering" do
    it "doesn't render editor in view mode" do
      get :index
      expect(response).to be_success
      expect(response.body).not_to match(/editor mode/i)
    end

    it "renders editor" do
      get :index, edit: true
      expect(response).to be_success
      expect(response.body).to match(/editor mode/i)
    end
  end

  describe "editor and drafts" do
    let!(:text){ create :hello_text }
    let!(:past_text){ create :past_text }
    let!(:future_text){ create :past_text }

    it "renders draft" do
      get :index, edit: true
      expect(response).to be_success
      expect(response.body).to match(text.content_draft)
    end

    it "doesn't render real text" do
      get :index, edit: true
      expect(response).to be_success
      expect(response.body).not_to match(text.content)
    end
  end

  describe "time travelling" do
    let!(:future_text){ create :future_text }

    it "doesn't work in view mode" do
      get :index, alcms_date: 7.days.from_now.iso8601[0..-2]
      expect(response).to be_success
      expect(response.body).not_to match(future_text.content)
      expect(response.body).not_to match(future_text.content_draft)
      expect(response.body).to match('placeholder')
    end

    it "works in edit mode" do
      get :index, edit: true, alcms_date: 7.days.from_now.iso8601[0..-2]
      expect(response).to be_success
      expect(response.body).to match(future_text.content_draft)
    end
  end

  describe "advanced timing" do
    let!(:present_text){ create :present_text }
    let!(:hello_tet){ create :hello_text }

    it "renders block with dates with more priority than block without" do
      get :index
      expect(response).to be_success
      expect(response.body).to match(present_text.content)
    end
  end
end
