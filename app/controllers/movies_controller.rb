class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end


  def index
    @movies = Movie.all
    if(@ticked != nil)
        @movies= @movies.find_all{ |m| @ticked.hs_key?(m.rating) and @ticked[m.rating]==true}
    end
   

	if(params[:sort].to_s == 'title')
	@movies = @movies.sort_by{|m| m.title }
	elsif(params[:sort].to_s == 'release')
	@movies= @movies.sort_by{|m| m.release_date.to_s }
	end
	if(params[:ratings] != nil)
        @movies = @movies.find_all{ |m| params[:ratings].has_key?(m.rating) }
        end

	@ticked = {}
        @all_ratings = ['G','PG','PG-13','R']

        @all_ratings.each { |rating|
                if params[:ratings] == nil
                @ticked[rating] = false
                else
                @ticked[rating] = params[:ratings].has_key?(rating)
                end
                }

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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

