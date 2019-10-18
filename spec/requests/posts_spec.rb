require "rails_helper"

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    #Si dejamos esto aqui, se ejecuta para todas las pruebas de aqui
    #Por eso lo comentamos
    #before { get '/posts' }

    it "should return OK" do
        # Pero aqui decimos que se haga para esta prueba
        get '/posts'
        payload = JSON.parse(response.body)
        expect(payload).to be_empty
        expect(response).to have_http_status(200)
    end

    describe "Search" do
      # Creamos algunos post con Factory_bot
      let!(:hola_mundo) { create(:published_post, title: 'Hola Mundo') }
      let!(:hola_rails) { create(:published_post, title: 'Hola Rails') }
      let!(:curso_rails) { create(:published_post, title: 'Curso Rails') }
      
      it "should filtre posts by title" do
        # Agregamos un query param ? 
        # Para buscar los posts que tienen hola en su titulo
        get "/posts?search=Hola"
        payload = JSON.parse(response.body)
        expect(payload).to_not be_empty
        expect(payload.size).to eq(2)
        expect(payload.map { |p| p["id"]}.sort).to eq([hola_mundo.id, hola_rails.id].sort)
        expect(response).to have_http_status(200)
      end
    end
  end
  
  describe "with data in the DB" do

    let!(:posts) { create_list(:post, 10, published: true) }
    before { get '/posts'}
    it "should return all the public posts" do
      get '/posts'
      payload = JSON.parse(response.body)
      expect(payload.size).to eq(posts.size)
      expect(response).to have_http_status(200)
    end
  end


  describe "GET /post/{id}" do
    let!(:post) { create(:post, published: true) }
    before { get '/posts'}
    it "should return a post" do
      get "/posts/#{post.id}"
      payload = JSON.parse(response.body)
      expect(payload).to_not be_empty
      expect(payload['id']).to eq(post.id)
      expect(payload['title']).to eq(post.title)
      expect(payload['content']).to eq(post.content)
      expect(payload['published']).to eq(post.published)
      expect(payload['author']['name']).to eq(post.user.name)
      expect(payload['author']['email']).to eq(post.user.email)
      expect(payload['author']['id']).to eq(post.user.id)

      expect(response).to have_http_status(200)
    end
  end

  # describe "POST /posts" do
  #   #Aquí creamos un usuario con Factory_bot
  #   let!(:user) { create(:user) }
  #   it "should create a post" do
  #     req_payload = {
  #       post: {
  #         title: "titulo",
  #         content: "content",
  #         published: false,
  #         user_id: 1
  #       }
  #     }
  #     # POST HTTP
  #     post "/posts", params: req_payload
  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["id"]).to_not be_nil
  #     expect(response).to have_http_status(:created)
  #   end

  #   it "should return error message on invalid post" do
  #     req_payload = {
  #       post: {
  #         content: "content",
  #         published: false,
  #         user_id: 1
  #       }
  #     }
  #     # POST HTTP
  #     post "/posts", params: req_payload
  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["error"]).to_not be_empty
  #     expect(response).to have_http_status(:unprocessable_entity)
  #   end
  # end

  # describe "PUT /posts/{id}" do
  #   #Aquí creamos un post con Factory_bot
  #   let!(:article) { create(:post) }

  #   it "should update a post" do
  #     req_payload = {
  #       post: {
  #         title: "titulo",
  #         content: "content",
  #         published: true,
  #       }
  #     }
  #     # POST HTTP
  #     put "/posts/#{article.id}", params: req_payload
  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["id"]).to eq(article.id)
  #     expect(response).to have_http_status(:ok)
  #   end


  #   it "should return error message on invalid post" do
  #     req_payload = {
  #       post: {
  #         title: nil,
  #         content: nil,
  #         published: false,
  #       }
  #     }
  #     # POST HTTP
  #     put "/posts/#{article.id}", params: req_payload
  #     payload = JSON.parse(response.body)
  #     expect(payload).to_not be_empty
  #     expect(payload["error"]).to_not be_empty
  #     expect(response).to have_http_status(:unprocessable_entity)
  #   end
  # end
end