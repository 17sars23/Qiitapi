//
//  ArticleListViewController.swift
//  Qiitapi
//
//  Created by 川岸樹奈 on 2019/02/21.
//  Copyright © 2019年 juna.Kawagishi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ArticleListViewController: UIViewController, UITableViewDataSource {
  
    let QiitaTable = UITableView()
    var articles: [[String: String?]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "新着記事"
        let url = "https://qiita.com/api/v2/items"
        
        getArticles(url: url)
        
        QiitaTable.frame = view.frame
        view.addSubview(QiitaTable)
        
        QiitaTable.dataSource = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let article = articles[indexPath.row] // 行数番目の記事を取得
        cell.textLabel?.text = article["title"]! // 記事のタイトルをtextLabelにセット
        cell.detailTextLabel?.text = article["userId"]! // 投稿者のユーザーIDをdetailTextLabelにセット
        return cell
    }
    
    func getArticles(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
            guard let object = response.result.value else { return }
            let json = JSON(object)
            
            json.forEach {(_, json) in
                let article: [String: String?] = [
                    "title": json["title"].string,
                    "userId": json["user"]["id"].string
                ]
                self.articles.append(article)
            }
            self.QiitaTable.reloadData()
        }
    }
    
}
