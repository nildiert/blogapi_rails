class User < ApplicationRecord
    has_many :posts
    validates :email, presence: true
    validates :name, presence: true
    validates :auth_token, presence: true

    # Generación del token de auth
    after_initialize :generate_auth_token

    def generate_auth_token
        # User.new
        # If not ...
        unless auth_token.present?
            # Generate token
            self.auth_token = ::TokenGenerationService.generate   
        end
    end
end


