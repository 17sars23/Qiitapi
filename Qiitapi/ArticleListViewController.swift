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
  
//    let QiitaTable = UITableView()
    @IBOutlet var QiitaTableView: UITableView!
    var articles: [[String: String?]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "新着記事たち"
//        let url = "https://qiita.com/api/v2/users/_ha1f/items"
        let url = "https://qiita.com/api/v2/items"
        getArticles(url: url)
        
        self.QiitaTableView.dataSource = self
        self.QiitaTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTableViewCell") as! ArticleTableViewCell
        let article = articles[indexPath.row]
        cell.articleTitle.text = article["title"]!
        cell.userName.text = article["userName"]!
        cell.dateLabel.text = dateFormat(dateInfo: article["date"]!!)
        cell.userIcon.loadImageAsynchronously(url: URL(string: article["userIcon"]!!))
        
        return cell
    }
    
    
    //APIから情報取得
    func getArticles(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON { response in
            guard let object = response.result.value else { return }
            let json = JSON(object)
            
            json.forEach {(_, json) in
                let article: [String: String?] = [
                    "title": json["title"].string,
                    "userName": json["user"]["name"].string,
                    "date": json["created_at"].string,
                    "userIcon": json["user"]["profile_image_url"].string
                ]
                self.articles.append(article)
            }
            self.QiitaTableView.reloadData()
        }
    }
    
    
    //日付フォーマット
    func dateFormat(dateInfo: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: dateInfo) {
            dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MMMMdd','yyyy", options: 0, locale: Locale(identifier: "en"))
            let dateStr = dateFormatter.string(from: date).description
            return dateStr
        }
        
        return nil
    }
    
}

//URL指定した画像を非同期でUIImageViewにセットする
//https://qiita.com/sensuikan1973/items/80ce3bd398cbbb8a4935
extension UIImageView {
    func loadImageAsynchronously(url: URL?, defaultUIImage: UIImage? = nil) -> Void {
        
        if url == nil {
            self.image = defaultUIImage
            return
        }
        
        DispatchQueue.global().async {
            do {
                let imageData: Data? = try Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.image = UIImage(data: data)
                    } else {
                        self.image = defaultUIImage
                    }
                }
            }
            catch {
                DispatchQueue.main.async {
                    self.image = defaultUIImage
                }
            }
        }
    }
}
