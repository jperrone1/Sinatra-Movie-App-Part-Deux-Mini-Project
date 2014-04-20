require 'sinatra'
require 'sinatra/reloader'
require 'typhoeus'
require 'json'
require 'pry'

# A setup step to get rspec tests running.
configure do
  root = File.expand_path(File.dirname(__FILE__))
  set :views, File.join(root,'views')
end

################ 

get '/' do

	erb :index
end

# html_str = 
# <<-eos

# <html>
# <header>
# <h1 style="text-align:center;color:#4B0082">Super Awesome Movie Search!</h1>
# </header>
# <body style="background:#DCDCDC; text-align:center; color:#006400">
# Search for your favorite movies with:
# <br>Movie Title ~or~ IMDb ID number</br>
# <br>
# <form method="get" action="/results">
# <input type="text" name="movie">
# <input type="submit">
# </form>
# </br>
# </body>
# </html>

# eos
# end

get '/results' do
	if params[:movie] == ""
		erb :index
	else
		search = params[:movie]
		search = search.gsub(/\s/, "%20")
		results= Typhoeus.get("www.omdbapi.com/?s=#{search}")
		@omdb_data = JSON.parse(results.body)
		erb :search
	end
end

get '/poster/:imdbID' do
	results = Typhoeus.get("http://www.omdbapi.com/?i=#{params[:imdbID]}")
  	@movie_data = JSON.parse(results.body)
  	erb :show
end

