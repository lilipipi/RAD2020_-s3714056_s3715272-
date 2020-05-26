class User < ApplicationRecord
    attr_accessor :remember_token
    has_many :microposts, dependent: :destroy
    has_many :comments, as: :commentable, dependent: :destroy
    before_save{self.email=email.downcase}

    mount_uploader :avatar, PhotoUploader
    mount_uploader :card, PhotoUploader
    validate :avatar_size
    validate :card_size
    validates :name, presence: true, length: { maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255},
                      format: {with: VALID_EMAIL_REGEX},
                      uniqueness: {case_sensitive: false}
    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end 

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    def feed
        Micropost.where("user_id = ?", id)
    end

    private

        def card_size
            if card.size > 5.megabytes
                errors.add(:card, "should be less than 5mb")
            end
        end

        def avatar_size
            if avatar.size > 5.megabytes
                errors.add(:avatar, "should be less than 5mb")
            end
        end    
end
