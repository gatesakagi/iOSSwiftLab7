//
//  OrderAllViewController.swift
//  iOSSwiftLab7
//
//  Created by Gates on 2017/3/26.
//  Copyright © 2017年 gatesakagi. All rights reserved.
//

import UIKit

class OrderAllViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 宣告飲料品項資料陣列
    var orderDrinkArray = [[String:String]]()
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var orderCountLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var orderDetailTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "查詢訂單資料"
        getJsondataforOrder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callStoreBtnAction(_ sender: UIButton) {
        guard let number = URL(string: "telprompt://0227063201") else { return }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }

    // Get Json data
    func getJsondataforOrder() {
        
        var returnDict:Dictionary = [String:String]()
        
        //let url = URL(string: "https://sheetsu.com/apis/v1.0/ab8e38e50f31")
        let url = URL(string: "https://spreadsheets.google.com/feeds/list/1qO1Gg_48IwnHGGFJBv-RVGKd-NrPmq3TI3rPBHa3baI/1/public/values?alt=json")
        let urlRequest = URLRequest(url: url!, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 0)

        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data:Data?, response:URLResponse?, err:Error?) -> Void in
            guard err == nil else {
                return
            }
            if let data = data {
                var orderAmount = 0
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
                    let jsonDictForFeed = jsonDict?["feed"] as! [String: AnyObject]
                    let jsonArray = jsonDictForFeed["entry"] as! [[String: AnyObject]]
                    for drinkDict in jsonArray {
                        let orderNameReadString: String = drinkDict["gsx$name"]!["$t"]! as! String
                        returnDict["orderName"] = orderNameReadString
                        
                        let orderDrinkReadString: String = drinkDict["gsx$drink"]!["$t"]! as! String
                        returnDict["orderDrink"] = orderDrinkReadString

                        let orderDrinkPriceReadString: String = drinkDict["gsx$drinkprice"]!["$t"]! as! String
                        returnDict["orderDrinkPrice"] = orderDrinkPriceReadString

                        let orderSugarReadString: String = drinkDict["gsx$sugar"]!["$t"]! as! String
                        returnDict["orderSugar"] = orderSugarReadString

                        let orderIceReadString: String = drinkDict["gsx$ice"]!["$t"]! as! String
                        returnDict["orderIce"] = orderIceReadString
                        
                        let orderNoteReadString: String = drinkDict["gsx$note"]!["$t"]! as! String
                        returnDict["orderNote"] = orderNoteReadString
                        
                        let orderDatetimeReadString: String = drinkDict["gsx$note"]!["$t"]! as! String
                        returnDict["orderDatetime"] = orderDatetimeReadString
                        
                        orderAmount += Int(orderDrinkPriceReadString)!
                        self.orderDrinkArray.append(returnDict)
                    }
                } catch {
                    print("Error - \(err)")
                }
                print(self.orderDrinkArray.description)
                DispatchQueue.main.async { //不加這個會很慢，因為更新Storyboard上面的UI都要在主線執行
                    self.loadingView.isHidden = true
                    self.orderCountLabel.text = String(self.orderDrinkArray.count)
                    self.orderAmountLabel.text = "💰\(String(orderAmount))"
                    self.orderDetailTableView.reloadData()
                }
            }
        }
        task.resume()
    }

    // Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDrinkArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderDetailCell", for: indexPath) as! OrderDetailTableViewCell
        cell.orderNoLabel.text = "#\(indexPath.row + 1)."
        cell.orderNameLabel.text = orderDrinkArray[indexPath.row]["orderName"]!
        cell.orderDrinkLabel.text = orderDrinkArray[indexPath.row]["orderDrink"]!
        cell.orderSugarLabel.text = orderDrinkArray[indexPath.row]["orderSugar"]!
        cell.orderIceLabel.text = orderDrinkArray[indexPath.row]["orderIce"]!
        if cell.orderIceLabel.text == "熱飲" {
            cell.orderIceLabel.backgroundColor = UIColor.drinkHotRed()
        } else {
            cell.orderIceLabel.backgroundColor = UIColor.drinkIceBlue()
        }
        if orderDrinkArray[indexPath.row]["orderNote"]!.characters.count == 0 {
            cell.orderNoteBtn.isHidden = true
        } else {
            cell.orderNoteBtn.isHidden = false
            cell.orderNoteBtn.tag = indexPath.row
            cell.orderNoteBtn.addTarget(self, action: #selector(orderNoteBtnAction), for: .touchUpInside)
        }
        cell.orderDatetimeLabel.text = orderDrinkArray[indexPath.row]["orderDatetime"]!
         
        return cell
     }
    
    func orderNoteBtnAction(sender:UIButton) {
        let alertController = UIAlertController(title: "給彼得潘的話..", message: orderDrinkArray[sender.tag]["orderNote"], preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
