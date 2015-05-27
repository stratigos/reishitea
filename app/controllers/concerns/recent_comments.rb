#############################################
# Allows selecting of sidebar Comment data
#############################################
module RecentComments
  def sidebar_recent_comments
    @sidebar_comments = Comment.recent.all
  end
end