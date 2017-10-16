require 'rails_helper'

RSpec.describe Front::TagsController, type: :controller do
  before(:each) do
    set_fake_token
  end

  describe 'GET #index' do
    it 'renders index page without errors' do
      expect(get(:index)).to be_success
    end
  end

  describe 'GET #show' do
    let(:tag) { FactoryGirl.create(:tag, name: 'k_test') }
    let(:expected_images) do
      [
        'https://scontent.cdninstagram.com/t51.2885-15/s320x320/e35/22344635_399631450452895_8400711217840128_n.jpg',
        'https://scontent.cdninstagram.com/t51.2885-15/s320x320/e35/22352452_861475647353734_6812599802618970112_n.jpg',
        'https://scontent.cdninstagram.com/t51.2885-15/e35/22344529_269632766879544_1352477985965342720_n.jpg'
      ]
    end

    context 'with search limit stub' do
      before(:each) do
        expect(SearchLimitChecker).to receive(:limit_is_reached?).and_return(false)
        expect(SearchLimitChecker).to receive(:search_is_performed)
        check_sidekiq_image_workers
       end

      it 'renders show page without errors' do
        VCR.use_cassette('instagram_media_recent') do
          expect(get(:show, params: { id: tag.id })).to be_success
        end
      end

      it 'assigns correct images' do
        VCR.use_cassette('instagram_media_recent') do
          get :show, params: { id: tag.id }
          expect(assigns(:recent_media_info).images).to match_array(expected_images)
        end
      end

      def check_sidekiq_image_workers
        sidekiq_mock = double
        expect(sidekiq_mock).to receive(:perform_later).exactly(3).times
        expect(ImageProcessWorkerJob).to receive(:set).exactly(3).times.and_return(sidekiq_mock)
      end
    end

    context 'tests for search limit (when limit is reached)' do
      before(:each) do
        expect(SearchLimitChecker).to receive(:search_is_performed)
        expect(SearchLimitChecker).to receive(:limit_is_reached?).and_return(true)
      end

      it 'redirects to index page if search limit is reached' do
        VCR.use_cassette('instagram_media_recent') do
          expect(get(:show, params: { id: tag.id })).to redirect_to(tags_path)
        end
      end
    end
  end

  describe 'POST #create' do
    it 'renders index page if tag do not pass validation' do
      expect(post(:create, params: { tag: { a: 1 } })).to render_template(:index)
    end

    it 'redirects to tag show page and create a new tag search records for a new tag' do
      expect(post(:create, params: { tag: { name: 'some name ' } })).to redirect_to(action: :show,
                                                                                    id: Tag.last.id,
                                                                                    tag_search_id: TagSearch.last.id)
    end

    it 'redirects to tag show page and create a new tag search records for an existing tag' do
      tag = FactoryGirl.create(:tag)
      expect(post(:create, params: { tag: { name: tag.name } })).to redirect_to(action: :show,
                                                                                id: tag.id,
                                                                                tag_search_id: TagSearch.last.id)
    end
  end
end
