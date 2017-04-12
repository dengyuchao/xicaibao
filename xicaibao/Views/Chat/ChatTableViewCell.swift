

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    
    var chatRoomCellData: ChatRoomCellData? {
        didSet {
            guard let chatRoomCellData = self.chatRoomCellData else { return }
            let placeholderImage = UIImage(named: "tongxunlu_touxiang")
            if let avatarUrl = chatRoomCellData.avatarUrl {
                avatarImageView.af_setImage(withURL: URL(string: avatarUrl)!)
            } else {
                avatarImageView.image = placeholderImage
            }
            if let chatRoomName = chatRoomCellData.chatRoomName {
                nameLabel.text = chatRoomName
            }
            if let message = chatRoomCellData.message() {
                messageLabel.text =  message
            }
            if let messageDate = chatRoomCellData.messageDate() {
                dateLabel.text = messageDate.toMessageDate()
            }
            if let unreadCount = chatRoomCellData.unreadCount {
                badgeLabel.text = "\(unreadCount)"
                if unreadCount == 0 {
                    badgeLabel.isHidden = true
                } else {
                    badgeLabel.isHidden = false
                }
            } else {
                badgeLabel.isHidden = true
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // avatarImageView.height / kCornerRadiusNumber
        avatarImageView.layer.cornerRadius = avatarImageView.layer.bounds.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
