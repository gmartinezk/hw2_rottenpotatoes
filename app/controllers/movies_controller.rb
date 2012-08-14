class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    debugger
    @all_ratings = Movie.ratings
    @ratings_values = {}
    if params[:ratings]
      params[:ratings].each_key do |rating|
        @ratings_values.merge!({rating => true})
      end
      @rel = Movie.where(:rating => params[:ratings].keys)
    else
      @rel = Movie.where("1=2")
    end
    if params[:order]
      if params[:order] == "title"
        @class_title = "hilite"
      else
        @class_date = "hilite"
      end
      @movies = @rel.order(params[:order])
    else
      @movies = @rel.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
