//
//  CardListTableViewController.swift
//  RCloudMessage
//
//  Created by impressly on 2017/3/15.
//  Copyright © 2017年 RongCloud. All rights reserved.
//

import Foundation
import UIKit

class CardTableViewController: UITableViewController {
    
    let cardListCellTableViewCellNibName = "CardListCellTableViewCell"
    let cardListCellTableViewCellID = "cardListCellTableViewCellIdentifier"
    
    var cards: [Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        // TODO: API请求获取名片
        self.getCards()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 导航栏颜色、标题颜色
        self.navigationController?.navigationBar.barTintColor = UIColor.kThemeColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    
    private func setupView() {
        
        // tableview setup
        self.navigationController?.navigationBar.isTranslucent = false;
        self.tableView.tableFooterView = UIView();
        
        // cell
        self.tableView.register(UINib(nibName: cardListCellTableViewCellNibName, bundle: nil), forCellReuseIdentifier: cardListCellTableViewCellID)
    }
    
    // test data
    private func getCards(){
        
        let card1 = Card(key: "", name: "张三", tel: "13656265656", job: "CEO", address: "上海市徐汇区番禺路888号方糖小镇405",email: "123456@163.com",com: "飞创信息科技有限公司")
        let card2 = Card(key: "",name: "李四", tel: "18689852365", job: "CFO", address: "广东省广州市天河区", email: "hello123@163.com",com: "天山实业有限公司")
        let card3 = Card(key: "",name: "王五", tel: "12653562356", job: "CTO", address: "广东省广州市花都区", email: "world345@163.com",com: "三菱汽车制造有限公司")
        let card4 = Card(key: "",name: "赵六", tel: "15625855252", job: "BOSS", address: "广东省广州市越秀区", email: "nice098@163.com", com: "如来重金属有限公司")
        self.cards.append(card1)
        self.cards.append(card2)
        self.cards.append(card3)
        self.cards.append(card4)
        
        guard let uuid = LoginManager.defaultManager.uuid else { return }
        guard let token = LoginManager.defaultManager.authToken else { return }
        
        ApiManager().getCards(forUser: uuid, token: token, successBlock: { (cards) in
            
            self.cards = cards
        }) { (error) in
            
            print("[CardTableViewController getCards] failed: \(error.localizedDescription)")
        }
    }
    
    
    // 颜色转换
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0xFF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
}

extension CardTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.cards.count == 0 {
            return 0
        } else {
            return 1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows: Int = 0
        
        if self.cards.count == 0 {
            rows = 0
        } else {
            switch section {
            case 0:
                rows = self.cards.count
                
            default:
                break
            }
        }
        
        return rows
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cardListCellTableViewCellID, for: indexPath) as! CardListCellTableViewCell
        cell.card = self.cards[indexPath.row]
        
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 35.5))
        
        sectionHeaderView.backgroundColor = UIColorFromRGB(rgbValue: 0xf0f0f6)
        
        let line = UIView(frame: CGRect(x: 0, y: 35.5-0.5, width: UIScreen.main.bounds.width, height: 0.5));
        
        line.backgroundColor = UIColor.gray
        
        sectionHeaderView.addSubview(line)
        
        let title = UILabel(frame: CGRect(x: 9, y: (35.5-20)/2.0, width: 200, height: 20))
        
        title.textColor = UIColorFromRGB(rgbValue: 0x000000)
        title.font = UIFont.systemFont(ofSize: 16.0)
        
        sectionHeaderView.addSubview(title)
        
        switch section {
        case 0:
            title.text = "收到的名片"
        default:
            break
        }
        
        return sectionHeaderView;
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 68.5
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    // segue to detailVC
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "Card", bundle: nil)
    
        let cardDetailVC: CardDetailTableViewController = storyboard.instantiateViewController(withIdentifier: "idDetail") as! CardDetailTableViewController
        
        // 传值
        let card: Card = self.cards[indexPath.row]
        cardDetailVC.card = card
        
        self.navigationController?.pushViewController(cardDetailVC, animated: true)
    }
    
}
