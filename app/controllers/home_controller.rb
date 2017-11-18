class HomeController < ApplicationController
  def index
    public_key_pair = OpenSSL::PKey::EC.new('prime256v1')
    public_key_pair.generate_key
    @public_key = Base64.encode64(public_key_pair.public_key.to_bn.to_s(2)).gsub("\n", '')
    session[:public_key] = Base64.encode64(public_key_pair.public_key.to_bn.to_s(2))
    session[:private_key] = Base64.encode64(public_key_pair.private_key.to_s(2))
  end
end
