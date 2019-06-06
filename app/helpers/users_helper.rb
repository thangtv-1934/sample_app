module UsersHelper
  def gravatar_for user, size: Settings.user.avatar_size
    gravatar_id = Digest::MD5::hexdigest user.email.downcase
    gravatar_url = "#{Settings.user.avatar_url}#{gravatar_id}?s=#{size}"
    image_tag gravatar_url, alt: user.name, class: "gravatar"
  end

  def user_follow
    current_user.active_relationships.build
  end

  def find_user_unfollow user_id
    current_user.active_relationships.find_by followed_id: user_id
  end
end
