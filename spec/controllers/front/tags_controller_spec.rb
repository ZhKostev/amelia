require 'rails_helper'

RSpec.describe Front::TagsController, type: :controller do
  before(:each) do
    set_fake_token
  end

  describe 'GET #index' do
    it 'renders index page without errors' do
      expect(get :index).to be_success
    end
  end

  describe 'GET #show' do
    let(:tag) { FactoryGirl.create(:tag) }

    it 'renders show page without errors' do
      expect(get :show, params: { id: tag.id }).to be_success
    end
  end

  describe 'POST #create' do
    it 'renders index page if tag do not pass validation' do
      expect(post :create, params: {tag: {a:1}}).to render_template(:index)
    end

    it 'redirects to tag show page and create a new tag search records for a new tag' do
      expect(post :create, params: { tag: { name: 'some name ' } }).to redirect_to(action: :show, id: Tag.last.id)
    end

    it 'redirects to tag show page and create a new tag search records for an existing tag' do
      tag = FactoryGirl.create(:tag)
      expect(post :create, params: { tag: { name: tag.name } }).to redirect_to(action: :show, id: tag.id)
    end
  end
end
