class PushNotificationsController < ApplicationController
  protect_from_forgery except: :create

  def create
    server_key_pair = OpenSSL::PKey::EC.new('prime256v1')
    server_key_pair.public_key = OpenSSL::PKey::EC::Point.new(OpenSSL::PKey::EC::Group.new('prime256v1'), OpenSSL::BN.new(Base64.decode64(session[:public_key]), 2))
    server_key_pair.private_key = OpenSSL::BN.new(Base64.decode64(session[:private_key]), 2)
    client_public_key = OpenSSL::PKey::EC::Point.new(OpenSSL::PKey::EC::Group.new('prime256v1'), OpenSSL::BN.new(Base64.urlsafe_decode64(params[:p256dh]), 2))

    push_notification = PushNotification::GcmSender.new(params[:endpoint], client_public_key, Base64.urlsafe_decode64(params[:auth]), server_key_pair)
    msg = {
      title: 'hello',
      body: 'world!',
      tag: '!!'
    }.to_json

    res = push_notification.send(msg)

    data = {
      response_code: res.code.to_i,
      body: res.body
    }
    render json: data.to_json
  end
end
