require 'rubygems'
require 'sinatra'
require 'rdiscount'

get '/' do
  "Hello World"
end

get '/blog/:article' do
  render_topic params[:article]
end

helpers do
  def render_topic(topic)
		source = File.read(topic_file(topic))
    @content = markdown(source)
    @title, @content = title(@content)
    @topic = topic
		erb :article
	rescue Errno::ENOENT
		status 404
	end
	def markdown(source)
		RDiscount.new(source, :smart).to_html
	end
  def title(content)
      title = "Yipee, you found something new!"
      unless content.match(/<h1>(.*)<\/h1>/).nil?
        title = content.match(/<h1>(.*)<\/h1>/)[1]
      end
      content_minus_title = content.gsub(/<h1>.*<\/h1>/, '')
      return title, content_minus_title
    end
    def topic_file(topic)
    if topic.include?('/')
      topic
    else
      "#{options.root}/articles/#{topic}.markdown"
    end
  end
end