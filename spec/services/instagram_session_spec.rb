require 'rails_helper'

describe InstagramSession do
  let(:session) { {} }
  let(:token) { 'asd123asd' }

  describe '.token_set?' do
    it 'returns false if session is blank' do
      expect(described_class.token_set?(session)).to eq(false)
    end

    it 'returns false if session has id, but not token' do
      session['visitor_id'] = 123
      expect(described_class.token_set?(session)).to eq(false)
    end

    it 'returns false if session has token, but not id' do
      session['instagram_authorize_token'] = token
      expect(described_class.token_set?(session)).to eq(false)
    end


    it 'returns true if session has both id and token' do
      session['instagram_authorize_token'] = token
      session['visitor_id'] = 123
      expect(described_class.token_set?(session)).to eq(true)
    end
    
  end

  describe '.set_token' do
    it 'saves token into session and saves data to database' do
      expect { described_class.set_token(session, token) }.to change(Visitor, :count).by(1)
      expect(session['instagram_authorize_token']).to eq(token)
      expect(session['visitor_id']).to eq(Visitor.last.id)
    end
  end
end