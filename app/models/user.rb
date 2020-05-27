class User < ApplicationRecord
    attr_accessor :remember_token, :reset_token
    before_save :downcase_email

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
    validates :password, presence: true, length: {minimum: 8, maximum: 20}, allow_nil: true
    validates :phonenumber, length: {minimum: 10, maximum: 13}, allow_nil: true, allow_blank: true


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

    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    def feed
        Micropost.where("user_id = ?", id)
    end

    def create_reset_digest
        self.reset_token = User.new_token
        update_attribute(:reset_digest, User.digest(reset_token))
        update_attribute(:reset_sent_at, Time.zone.now)
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end
    
    # Sends password reset email.
    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    private

        def downcase_email
            self.email = email.downcase
        end

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
