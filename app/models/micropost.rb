class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_by_create_at, -> {order created_at: :desc}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.validates.content_length}
  validate :picture_size

  private

  def picture_size
    errors.add :picture, t("micropost.img_should_be_less_than_5MB") if picture.size > Settings.micropost.validates.img_size.megabytes
  end
end
