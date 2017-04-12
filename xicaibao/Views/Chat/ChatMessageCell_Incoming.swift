

import UIKit

class ChatMessageCell_Incoming: UITableViewCell {
    
    @IBOutlet weak var cellTopLabel: UILabel!
    @IBOutlet weak var constraintView: UIView!
    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet var containerViewRightConstraint: NSLayoutConstraint!
    @IBOutlet var cellTopLabelHeightConstraint: NSLayoutConstraint!
    
//    var chatMessageCellData: ChatMessageCellData? {
//        didSet {
//            guard let m = chatMessageCellData else { return }
//            messageLabel.text = m.message()
//            cellTopLabelHeightConstraint.constant = m.isShowDate ? ZSY_ChatMessagesSize.cellTopLabelHeight : 0.0
//            if m.isShowDate {
//                cellTopLabel.text = m.messageDate().toMessageDate()
//            }
//        }
//    }
//    
//    var incomingAvatarUrl: String? {
//        didSet {
//            let emptyAvatarImage = UIImage(named: kEmpty_AvatarImage)
//            if let url = incomingAvatarUrl {
//                avatarImageView.sd_setImage(with: URL(string: url), placeholderImage: emptyAvatarImage)
//            } else {
//                avatarImageView.image = emptyAvatarImage
//            }
//            
//            // avatarImageView.height / 2
//            avatarImageView.layer.cornerRadius = 32.0 / 2.0
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleImageView.image = ZSY_BubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.kThemeColor()).messageBubbleImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerViewRightConstraint.constant = getContainerViewLeftConstraintConstant()
    }
    
    private func getContainerViewLeftConstraintConstant() -> CGFloat {
        let contentViewWidth = getMessagesLabelTextWidth() + ZSY_ChatMessagesSize.messageLabelBoderLayoutConstraint * 2
        let constant = kScreenWidth - contentViewWidth - ZSY_ChatMessagesSize.cellBoderWidth + ZSY_ChatMessagesSize.contentViewLeftLayoutConstraint - 2 * ZSY_ChatMessagesSize.cellBoderWidth - ZSY_ChatMessagesSize.avatarWidth
        return max(constant, ZSY_ChatMessagesSize.contentViewLeftLayoutConstraint)
    }
    
    private func getMessagesLabelTextWidth() -> CGFloat {
        let contentViewWidth: CGFloat = kScreenWidth - ZSY_ChatMessagesSize.avatarWidth - ZSY_ChatMessagesSize.cellBoderWidth * 2 - ZSY_ChatMessagesSize.contentViewLeftLayoutConstraint
        let textMaxWidth: CGFloat = contentViewWidth - ZSY_ChatMessagesSize.messageLabelBoderLayoutConstraint * 2
        let textViewSize = CGSize(width: textMaxWidth, height: 20)
        return messageLabel.sizeThatFits(textViewSize).width
    }
}
