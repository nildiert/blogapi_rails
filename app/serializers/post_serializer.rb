class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :published, :author

  # Definimos autor porque no hace parte del model
  def author
    #Este self.object hace referencia al object que se esta serializando
    user = self.object.user
    {
      name: user.name,
      email: user.email,
      id: user.id
    }
  end
end
