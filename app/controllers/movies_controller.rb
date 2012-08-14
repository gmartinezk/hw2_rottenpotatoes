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

    if (not params[:ratings] and not params[:order]) and (session[:ratings] or session[:order])
      redirect_to movies_path(:ratings => session[:ratings], :order => session[:order])
    end

    if params[:ratings]
      params[:ratings].each_key do |rating|
        @ratings_values[rating] = true
      end
      # Remember filter in the session hash
      session[:ratings] = params[:ratings]
      @rel = Movie.where(:rating => params[:ratings].keys)
    else
      session[:ratings] = nil
      @rel = Movie.where("1=2")
    end

    if params[:order]
      if params[:order] == "title"
        @class_title = "hilite"
      else
        @class_date = "hilite"
      end
      session[:order] = params[:order]
      @movies = @rel.order(params[:order])
    else
      session[:order] = nil
      @movies = @rel.all
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:ratings => session[:ratings], :order => session[:order])
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
    redirect_to movies_path(:ratings => session[:ratings], :order => session[:order])
  end

end
