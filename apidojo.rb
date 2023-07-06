# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)

Dotenv.load

loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.setup

require 'sinatra'

configure do
  enable :logging

  set :port, ARGV[ARGV.index('-p') + 1] if ARGV.index('-p')
end

helpers do
  def engine
    @engine ||= ApidojoEngine.new
  end
end

get '/favicon.ico' do
  [204, {}, '']
end

get '/__sinatra__/*' do
  [204, {}, '']
end

get '/data/*.*' do |path, ext|
  send_file "data/#{path}.#{ext}"
end

get '*' do
  # engine.squeak!
  response = engine.relay_get(request)

  [response.status, { 'Content-Type' => response.content_type }, response.body]
end

post '*' do
  response = engine.relay_post(request)

  [response.status, { 'Content-Type' => response.content_type }, response.body]
end

put '*' do
  response = engine.relay_put(request)

  [response.status, { 'Content-Type' => response.content_type }, response.body]
end

patch '*' do
  response = engine.relay_patch(request)

  [response.status, { 'Content-Type' => response.content_type }, response.body]
end

delete '*' do
  response = engine.relay_delete(request)

  [response.status, { 'Content-Type' => response.content_type }, response.body]
end

# Run with
# ruby apidojo.rb -p PORT_VALUE
