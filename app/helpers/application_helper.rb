module ApplicationHelper
  def can_view_photos?(user)
    return true if !user.private?
    return false unless current_user
    return true if current_user == user
    
    follow_request = user.received_follow_requests.find_by(sender: current_user)
    follow_request&.status == "accepted"
  end
end
