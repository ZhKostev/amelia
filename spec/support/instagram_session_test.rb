module InstagramSessionTest
  def set_fake_token
    InstagramSession.new(session).set_token('123')
  end
end