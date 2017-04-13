

import UIKit

class ChatMessageCell_Outgoing: UITableViewCell {
    
    @IBOutlet weak var cellTopLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var constraintView: UIView!
    @IBOutlet weak var bubbleImageView: UIImageView!

    @IBOutlet var containerViewLeftConstraint: NSLayoutConstraint!
    @IBOutlet var cellTopLabelHeightConstraint: NSLayoutConstraint!
    
    var chatMessageCellData: ChatMessageCellData? {
        didSet {
            guard let m = chatMessageCellData else { return }
            messageLabel.text = m.message()
            cellTopLabelHeightConstraint.constant = m.isShowDate ? ZSY_ChatMessagesSize.cellTopLabelHeight : 0.0
            if m.isShowDate {
                cellTopLabel.text = m.messageDate().toMessageDate()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleImageView.image = ZSY_BubbleImageFactory().outgoingMessagesBubbleImageWithColor(.kMessageBubbleLightGrayColor()).messageBubbleImage
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerViewLeftConstraint.constant = getContainerViewLeftConstraintConstant()
    }
    
    fileprivate func getContainerViewLeftConstraintConstant() -> CGFloat {
        let contentViewWidth = getTextViewTextWidth() + ZSY_ChatMessagesSize.messageLabelBoderLayoutConstraint * 2
        let constant = kScreenWidth - contentViewWidth - ZSY_ChatMessagesSize.cellBoderWidth + ZSY_ChatMessagesSize.contentViewLeftLayoutConstraint - 2 * ZSY_ChatMessagesSize.cellBoderWidth - ZSY_ChatMessagesSize.avatarWidth
        return max(constant, ZSY_ChatMessagesSize.contentViewLeftLayoutConstraint)
    }
    
    fileprivate func getTextViewTextWidth() -> CGFloat {
        let contentViewWidth: CGFloat = kScreenWidth - ZSY_ChatMessagesSize.avatarWidth - ZSY_ChatMessagesSize.cellBoderWidth * 2 - ZSY_ChatMessagesSize.contentViewLeftLayoutConstraint
        let textMaxWidth: CGFloat = contentViewWidth - ZSY_ChatMessagesSize.messageLabelBoderLayoutConstraint * 2
        let textViewSize = CGSize(width: textMaxWidth, height: frame.size.height)
        return messageLabel.sizeThatFits(textViewSize).width
    }
}
