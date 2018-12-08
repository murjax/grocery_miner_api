class JwtService
  def self.encode(payload:)
    JWT.encode(payload, self.secret)
  end

  def self.decode(token:)
    JWT.decode(token, self.secret).first
  end

  def self.secret
    ENV['DEVISE_JWT_SECRET_KEY']
  end
end
