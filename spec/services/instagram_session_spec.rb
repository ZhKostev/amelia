require 'rails_helper'

describe InstagramSession do
  let(:session) { {} }
  let(:token) { 'asd123asd' }
  let(:subject) { described_class.new(session) }

  describe '.token_set?' do
    it 'returns false if session is blank' do
      expect(subject.token_set?).to eq(false)
    end

    it 'returns false if session has id, but not token' do
      session['visitor_id'] = 123
      expect(subject.token_set?).to eq(false)
    end

    it 'returns false if session has token, but not id' do
      session['instagram_authorize_token'] = token
      expect(subject.token_set?).to eq(false)
    end


    it 'returns true if session has both id and token' do
      session['instagram_authorize_token'] = token
      session['visitor_id'] = 123
      expect(subject.token_set?).to eq(true)
    end
    
  end

  describe '.set_token' do
    it 'saves token into session and saves data to database' do
      expect { subject.set_token(token) }.to change(Visitor, :count).by(1)
    end

    it 'saves info about visitor' do
      subject.set_token(token)
      expect(session).to include({ instagram_authorize_token: token, visitor_id: Visitor.last.id }.stringify_keys)
    end
  end
end