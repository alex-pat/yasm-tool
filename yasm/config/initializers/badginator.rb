Badginator.define_badge do
  code :first_comment
  name "First Comment"
  description "For the first comment"
  condition ->(nominee, context) {
    nominee.comments.length == 1
  }
  image "first_comment.png"
end

Badginator.define_badge do
  code :ten_comments
  name "Ten Comments"
  description "For ten comments"
  condition ->(nominee, context) {
    nominee.comments.length == 10
  }
  image "ten_comments.png"
end

Badginator.define_badge do
  code :twenty_comments
  name "Twenty Comments"
  description "For twenty comments"
  condition ->(nominee, context) {
    nominee.comments.length == 20
  }
  image "twenty_comments.png"
end

Badginator.define_badge do
  code :first_site
  name "First Site"
  description "For the first site"
  condition ->(nominee, context) {
    nominee.sites.length == 1
  }
  image "first_site.png"
end

Badginator.define_badge do
  code :ten_sites
  name "Ten Sites"
  description "For ten sites"
  condition ->(nominee, context) {
    nominee.sites.length == 10
  }
  image "ten_sites.png"
end
