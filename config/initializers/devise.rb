Devise.setup do |config|
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'
  require 'devise/orm/active_record'

  config.case_insensitive_keys = [:email]

  config.strip_whitespace_keys = [:email]

  config.skip_session_storage = [:http_auth]

  config.stretches = Rails.env.test? ? 1 : 11

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  config.navigational_formats = []

  config.sign_out_via = :delete

  config.warden do |config|
    config.default_strategies(:scope => :user).unshift :jwt
  end

  config.jwt do |jwt|
    jwt.secret = ENV['DEVISE_JWT_SECRET_KEY']
    jwt.dispatch_requests = [
      ['POST', %r{^/login$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/logout$}]
    ]
    jwt.expiration_time = 5.days.to_i
  end
end

module Devise
  module Strategies
    class JWT < Base
      def valid?
        request.headers['Authorization'].present?
      end

      def authenticate!
        payload = JwtService.decode(token: token)
        success! User.find(payload['sub'])
      rescue ::JWT::ExpiredSignature
        fail! 'Auth token has expired. Please login again'
      rescue ::JWT::DecodeError
        fail! 'Auth token is invalid'
      rescue
        fail!
      end

      private

      def token
        request.headers.fetch('Authorization', '').split(' ').last
      end
    end
  end
end
Warden::Strategies.add(:jwt, Devise::Strategies::JWT)
