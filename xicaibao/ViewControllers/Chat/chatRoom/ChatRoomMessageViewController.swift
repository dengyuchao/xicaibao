//
//  ChatRoomTableViewController.swift
//  xicaibao
//
//  Created by impressly on 2017/4/5.
//  Copyright © 2017年 impressly. All rights reserved.
//

import UIKit
import Foundation

// cell data used for displaying in chat
class ChatMessageCellData {
    
    var chatMessage: ChatMessage
    var isOutgoing: Bool
    
    // 初始化时未赋值
    var isShowDate: Bool = false
    var cellHeight: CGFloat = 0.0
    
    func message() -> String {
        return self.chatMessage.message
    }
    
    func messageDate() -> Date {
        return self.chatMessage.createdAt as Date
    }
    
    init(chatMessage: ChatMessage, isOutgoing: Bool) {
        self.chatMessage = chatMessage
        self.isOutgoing  = isOutgoing
    }
}

extension ChatMessage {
    
    func toCellData(forUser me: String) -> ChatMessageCellData {
        
        // check sender
        var isOutgoing: Bool = false
        if let userId = self.userId {
            isOutgoing = (userId == me)
        }
        return ChatMessageCellData(chatMessage: self, isOutgoing: isOutgoing)
    }
}


class ChatRoomMessageViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: ChatMessagesSendButton!
    @IBOutlet weak var textView: ChatMessagesTextView!
    
    @IBOutlet weak var chatMessageBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var inputViewHeightConstraint: NSLayoutConstraint!
    
    let incomingCellNibName = "ChatMessageCell_Incoming"
    let outgoingCellNibName = "ChatMessageCell_Outgoing"
    let kMerchantChatMessagesIncomingCellID = "MerchantChatMessagesIncomingCellID"
    let kMerchantChatMessagesOutgoingCellID = "MerchantChatMessagesOutgoingCellID"
    
    
    var incomingAvatarUrl: String? // calculated during viewDidLoad
    
    var currentUser: User?
    
    var chatRoom: ChatRoom?
    var page: Int = 1
    var chatMessageDataList: [ChatMessageCellData] = []
    
    
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        
        // get current user
        self.getCurrentUser()
        
        // get incomingAvatarUrl from chatRoom
        // kept as var for use in cell views
        self.fetchIncomingAvatarUrl()
        
        chatRoom?.chatMessages = []
        // get chatMessages from API
        
        // get chatMessages from API
        getMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 添加观察者
        self.addObserver()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // 移除观察者
        removeObserver()
    }
    
    override func viewDidLayoutSubviews() {
        
        textView.layer.cornerRadius = textView.frame.size.height / 8.0
    }
    
    
    
    private func setupViews() {
        
        // tableview
        tableView.register(UINib(nibName: incomingCellNibName, bundle: nil), forCellReuseIdentifier: kMerchantChatMessagesIncomingCellID)
        tableView.register(UINib(nibName: outgoingCellNibName, bundle: nil), forCellReuseIdentifier: kMerchantChatMessagesOutgoingCellID)
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        // refreshControl
        refreshControl.addTarget(self, action: #selector(ChatRoomMessageViewController.getMoreChatMessages), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    // MARK: - 键盘
    fileprivate func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(zsy_UIKeyboardWillShowNotification(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(zsy_UIKeyboardWillHideNotification(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    fileprivate func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    // 发送广播
    func zsy_UIKeyboardWillShowNotification(_ notification: Notification) {
        adjustTextViewByKeyboardState(true, notification: notification)
        scrollToBottomCell()
    }
    
    func zsy_UIKeyboardWillHideNotification(_ notification: Notification) {
        adjustTextViewByKeyboardState(false, notification: notification)
    }
    
    fileprivate func adjustTextViewByKeyboardState(_ showKeyboard: Bool, notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrameEnd = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let keyboardAnimationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let keyboardAnimationCurve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber else { return }
        let keyboardFrameEndCGRect = keyboardFrameEnd.cgRectValue
        let keyboardAnimationOptions = UIViewKeyframeAnimationOptions(rawValue: keyboardAnimationCurve.uintValue)
        chatMessageBottomConstraint.constant = showKeyboard ? keyboardFrameEndCGRect.height : 0.0
        UIView.animateKeyframes(withDuration: keyboardAnimationDuration, delay: 0.0, options: keyboardAnimationOptions, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (completion: Bool) -> Void in
        }
    }
    
    private func getCurrentUser() {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().getProfile(uuid, token: token, successBlock: {(user) in
            self.currentUser = user
            self.refresh()
        }, errorBlock: {(error) in
            // TODO: 错误提示
        })
    }
    
    private func refresh() {
        self.refreshControl.endRefreshing()
        
        let indSet = IndexSet([0])
        self.tableView.reloadSections(indSet, with: UITableViewRowAnimation.automatic)
        if page == 1 {
            self.scrollToBottomCell()
        }
    }
    
    fileprivate func scrollToBottomCell() {
        if chatMessageDataList.count > 0 {
            let indPath = IndexPath(row: chatMessageDataList.count - 1, section: 0)
            self.tableView.scrollToRow(at: indPath, at: UITableViewScrollPosition.bottom, animated: true)
        }
    }

    private func fetchIncomingAvatarUrl() {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let chatRoom = self.chatRoom else { return }
        
        // MARK: 获取聊天室的title和好友头像
        let (username, avatar) = chatRoom.counterparty(uuid)
        self.incomingAvatarUrl = avatar
        self.title = username
    }
    
    
    // MARK: API methods
    func getMessages() {
        
        let apiManager = ApiManager()
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        guard let chatRoom = self.chatRoom else { return }
        let chatRoomId = chatRoom.key
        
        apiManager.getChatMessages(page, forChatRoom: chatRoomId, forUser: uuid, token: token, successBlock: {(chatMessages: [ChatMessage]) in
            
            if chatMessages.count == 0 {
                self.noMoreMessages()
                return
            }
            chatRoom.chatMessages.insert(contentsOf: chatMessages, at: 0)
            chatRoom.sortMessages()
            
            self.setupChatMessageCellData(chatRoom.chatMessages)
            self.refresh()
        }, errorBlock: {(error: Error) in
//            NavigationAlert(viewController: self, title: "发送消息失败，请稍后再试", alertType: AlertType.caution).show()
        })
    }
    
    func getMoreChatMessages() {
        page = page + 1
        refreshControl.beginRefreshing()
        getMessages()
    }
    
    fileprivate func noMoreMessages() {
        //  TODO: 提示无更多消息
        refreshControl.endRefreshing()
        refreshControl.removeFromSuperview()
        refreshControl.removeTarget(self, action: #selector(ChatRoomMessageViewController.getMoreChatMessages), for: .valueChanged)
    }
    
    fileprivate func setupChatMessageCellData(_ chatMessages: [ChatMessage]) {
        // reset
        self.chatMessageDataList.removeAll()
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        for chatMessage in chatMessages {
            let chatMessageData = chatMessage.toCellData(forUser: uuid)
            self.chatMessageDataList.append(chatMessageData)
            self.configCellData(chatMessageData)
        }
    }
    
    // MARK: 调整 cellData
    fileprivate func configCellData(_ chatMessageCellData: ChatMessageCellData) {
        chatMessageCellData.isShowDate = shouldShowDateForCell(chatMessageCellData)
        chatMessageCellData.cellHeight = heightForCell(chatMessageCellData)
    }
    
    fileprivate func shouldShowDateForCell(_ chatMessageCellData: ChatMessageCellData) -> Bool {
        // find message by chatMessage.key
        let index = self.chatMessageDataList.index{(cellData: ChatMessageCellData) -> Bool in
            return cellData.chatMessage.key == chatMessageCellData.chatMessage.key
        }
        
        if let idx = index {
            if idx == 0 { return true } // first chat message
            else {
                let selfDate = chatMessageCellData.messageDate()
                let previousDate = self.chatMessageDataList[idx-1].messageDate()
                let compare = selfDate.timeIntervalSince(previousDate)
                
                // 与上一条信息对比 超过 10 分钟才显示时间
                return compare > 60 * 10 ? true : false
            }
        } else {
            return false
        }
    }
    
    fileprivate func heightForCell(_ chatMessageCellData: ChatMessageCellData) -> CGFloat {
        let cellTopLabelHeight: CGFloat = chatMessageCellData.isShowDate ? ZSY_ChatMessagesSize.cellTopLabelHeight : 0.0
        let textViewWidth = kScreenWidth - (ZSY_ChatMessagesSize.cellBoderWidth * 2 + ZSY_ChatMessagesSize.messageLabelBoderLayoutConstraint * 2 + ZSY_ChatMessagesSize.contentViewLeftLayoutConstraint + ZSY_ChatMessagesSize.avatarWidth)
        let textViewHeight: CGFloat = chatMessageCellData.message().textSizeWithFont(UIFont.systemFont(ofSize: Font.kTitleFontSize), constrainedToSize: CGSize(width: textViewWidth, height: kScreenHeight)).height
        let cellHeight: CGFloat = cellTopLabelHeight + ZSY_ChatMessagesSize.bottomViewHeight + textViewHeight
        return cellHeight
    }
    
    fileprivate func sendMessage(_ messageStr: String) {
        guard let user = self.currentUser else { return }
        
        guard let uuid = LoginManager.defaultManager.uuid
            else { return }
        guard let token = LoginManager.defaultManager.authToken
            else { return }
        
        let message = ChatMessage(key: nil, user: user, message: messageStr, createdAt: Date())
        
        ApiManager().postChatMessage(message, chatRoom: chatRoom!, forUser: uuid, token: token, successBlock: {(chatMessage) in
            
            // append
            let chatMessageData = chatMessage.toCellData(forUser: uuid)
            self.chatMessageDataList.append(chatMessageData)
            self.configCellData(chatMessageData)
            
            // insert tableView -- don't call reload!
            let indPath = IndexPath(row: self.chatMessageDataList.count - 1 , section: 0)
            self.tableView.insertRows(at: [indPath], with: UITableViewRowAnimation.automatic)
            
            self.scrollToBottomCell()
            
        }, errorBlock: {(error) in
            
            // TODO: error alert?
        })
        
        self.markChatMessages()
    }
    
    // 通知API已读取消息
    func markChatMessages() {
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        guard let chatRoomKey = chatRoom?.key else { return }
        ApiManager().markChatRoom(chatRoomKey, forUser: uuid, token: token, successBlock: {() in
        }, errorBlock: {_ in })
    }
    
    // MARK: Actions
    
    @IBAction func didSendAction(_ sender: UIButton) {
        sendMessage(textView.text)
        textView.text = nil
        textViewDidChange(textView)
    }
}

extension ChatRoomMessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessageDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chatMessageData = chatMessageDataList[indexPath.row]
        if !chatMessageData.isOutgoing {
            let cell = tableView.dequeueReusableCell(withIdentifier: kMerchantChatMessagesIncomingCellID, for: indexPath as IndexPath) as! ChatMessageCell_Incoming
            cell.chatMessageCellData = chatMessageData
            cell.incomingAvatarUrl = incomingAvatarUrl
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kMerchantChatMessagesOutgoingCellID, for: indexPath as IndexPath) as! ChatMessageCell_Outgoing
            cell.chatMessageCellData = chatMessageData
            return cell
        }
    }
}

extension ChatRoomMessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return chatMessageDataList[indexPath.row].cellHeight
    }
}

extension ChatRoomMessageViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = !textView.text.isEmpty
        inputNextLayoutBottomSubViews()
    }
    
    fileprivate func inputNextLayoutBottomSubViews() {
        textView.frame.size.height = textView.contentSize.height
        inputViewHeightConstraint.constant = textView.frame.size.height + 14
        view.layoutIfNeeded()
        scrollToBottomCell()
    }
}


