require 'json'
require 'net/http'
require 'uri'

class BookmarksController < ApplicationController
  def new
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new
  end

  def create
    @list = List.find(params[:list_id])
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = @list
    @new_movie = movie_api(params[:bookmark][:search])
    @movie = Movie.new(
      title: @new_movie['title'],
      overview: @new_movie['overview'],
      poster_url: "https://image.tmdb.org/t/p/original/#{@new_movie['poster_path']}",
      rating: @new_movie['vote_average']
    )
    @movie.save

    @bookmark.movie_id = @movie.id
      if @bookmark.save
        redirect_to list_path(@list)
      else
        render :new, status: :unprocessable_entity
      end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to list_path(@bookmark)
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:comment, :list_id, :movie_id, :search)
  end
end

def movie_api(user_input)
  p = URI::Parser.new
  search = p.escape(user_input)
  url = URI("https://api.themoviedb.org/3/search/movie?query=#{search}&language=fr")

  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true

  request = Net::HTTP::Get.new(url)
  request['accept'] = 'application/json'
  request['Authorization'] = 'Bearer TMBD_KEY'

  response = http.request(request)
  movies = JSON.parse(response.read_body)
  movies['results'][0]
end
