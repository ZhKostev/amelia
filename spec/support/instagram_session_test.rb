module InstagramSessionTest
  def set_fake_token
    InstagramSession.new(session).set_token('fake_token')
  end
end