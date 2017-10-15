module InstagramSessionTest
  def set_fake_token
    InstagramSession.new(session).save_token('fake_token')
  end
end
