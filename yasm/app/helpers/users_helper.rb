module UsersHelper

  def link_to_user(user, mode = :none)

    font_icon = { "twitter" => :twitter, "facebook" => :facebook, "vkontakte" => :vk, nil => :user }
    modes = {
      :comments => -> { "(#{user.comments.length}) " },
      :sites    => -> { "(#{user.sites.length}) "},
      :badges  => -> { "(#{user.badges.length}) " },
      :none => -> { nil }
    }

    user_mod = modes[mode].call
    icon = font_icon[user.provider]
    link = link_to user.username, user_path(user)

    "#{user_mod}<i class='fa fa-#{icon}' aria-hidden='true'></i> #{link}".html_safe
  end

end
