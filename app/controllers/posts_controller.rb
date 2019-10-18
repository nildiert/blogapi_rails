require "byebug"

class PostsController < ApplicationController
  include Secured
    before_action :authenticate_user!, only: [:create, :update]

    # Manejo de excepciones

    rescue_from Exception do |e|
      
      render json: {error: e.message}, status: :internal_error
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render json: {error: e.message}, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render json: {error: e.message}, status: :unprocessable_entity
    end

    # GET /posts
    def index
        @posts = Post.where(published: true)
        # Despues de implementar pruebas de filter en rspec
        # Si no es vacío y esta incluido present ...
        if !params[:search].nil? && params[:search].present?
        # Implementamos esta clase en una nueva carpeta (services)
            @posts = PostsSearchService.search(@posts, params[:search])
        end
            # .includes(:user) soluciona el error de N+1
            render json: @posts.includes(:user), status: :ok
    end

    # GET /posts/{id}
    def show
        @post = Post.find(params[:id])  #ActiveRecord::RecordNotFound
        if(@post.published? || (Current.user && @post.user_id == Current.user.id))
          render json: @post, status: :ok
        else
          render json: {error: 'Not Found'}, status: :not_found
        end
    end

    # CREATE /posts
    def create
        @post = Current.user.posts.create!(create_params)
        render json: @post, status: :created
    end

    # PUT /posts/{id}
    def update
        @post = Current.user.posts.find(params[:id])
        @post.update!(update_params)
        render json: @post, status: :ok
    end

    private

    def create_params
        params.require(:post).permit(:title, :content, :published)
    end

    def update_params
        params.require(:post).permit(:title, :content, :published)
    end


end