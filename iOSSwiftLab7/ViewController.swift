//
//  ViewController.swift
//  iOSSwiftLab7
//
//  Created by Gates on 2017/3/24.
//  Copyright © 2017年 Gates. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {

    //IBOutlet
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var drinkTextField: UITextField!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var noteTextView: UITextView!
    
    //IBAction
    @IBAction func clearBtnAction(_ sender: UIButton) {
        drinkTextField.text = ""
    }
    
    @IBAction func orderBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
         if (sugarSegmentedControl.selectedSegmentIndex >= 0 && iceSegmentedControl.selectedSegmentIndex >= 0 && (nameTextField.text?.characters.count)! > 0 && (drinkTextField.text?.characters.count)! > 0) {
            let orderName = nameTextField.text!
            let orderDrink = drinkTextField.text!
            let orderDrinkIndex = drinkArray.index(of: orderDrink)!
            let orderSuger = sugarArray[sugarSegmentedControl.selectedSegmentIndex]
            let orderIce = iceArray[iceSegmentedControl.selectedSegmentIndex]
            let orderNote = noteTextView.text!
            let todaysDate:NSDate = NSDate()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyy-MM-dd HH:mm"
            let orderDatetime:String = dateFormatter.string(from: todaysDate as Date)
            print("訂單名字-\(orderName), 訂購飲料-\(orderDrink), 訂購飲料編號-\(orderDrinkIndex), 甜度-\(orderSuger), 溫度-\(orderIce), 備註-\(orderNote), 訂購時間-\(orderDatetime)")
        
            let url = URL(string: "https://sheetsu.com/apis/v1.0/ab8e38e50f31")
            var urlRequest = URLRequest(url: url!)
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let dictionary = ["name":orderName, "drink":orderDrink, "drinkIndex":orderDrinkIndex, "sugar":orderSuger, "ice":orderIce, "note":orderNote, "orderDatetime":orderDatetime] as [String : Any]
            do {
                let data = try  JSONSerialization.data(withJSONObject: dictionary, options: [])
                let task = URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { (retData, res,
                    err) in
                    if let retData = retData {
                        do {
                            var dic = try JSONSerialization.jsonObject(with: retData, options: [])
                        }
                        catch { }
                    } })
                task.resume()
            }
            catch { }
            
            
         } else {
            let alertController = UIAlertController(title: "您尚有資料尚未選擇", message: "記得再檢查一下哦！", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 建立 UIPickerView
    let myPickerView = UIPickerView()
    
    // 飲料品項資料
    var drinkArray = [String]()
    
    // 甜度選項
    var sugarArray = ["正常","半糖","微糖","無糖"]
    
    // 溫度選項
    var iceArray = ["正常","少冰","去冰","熱"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彼得潘請飲料"
        
        getJsondata()

        // 設定 UIPickerView 的 delegate 及 dataSource
        myPickerView.delegate = self
        myPickerView.dataSource = self
        
        // 將 UITextField 原先鍵盤的視圖更換成 UIPickerView
        drinkTextField.inputView = myPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.themeBlue()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確認", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneAction))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.closeKeyboard))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        drinkTextField.inputView = myPickerView
        drinkTextField.inputAccessoryView = toolBar
        
        //加上手勢按鈕
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func doneAction() {
        let selectedRowForPicker = myPickerView.selectedRow(inComponent: 0)
        drinkTextField.text = drinkArray[selectedRowForPicker]
        self.view.endEditing(true)
    }
    
    func closeKeyboard() {
        drinkTextField.text = ""
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // PickerView data source && function
    
    //有幾個區塊
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    //裡面有幾列
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return drinkArray.count
    }
//    //選擇到的那列要做的事
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        drinkTextField.text = drinkArray[row]
//    }
    //設定每列PickerView要顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return drinkArray[row]
    }
    
    // Get Json data
    func getJsondata() {
        
//        var returnDict:Dictionary = [String:String]()
        
        let url = URL(string: "https://sheetsu.com/apis/v1.0/1f3dccf61c93")
        let urlRequest = URLRequest(url: url!, cachePolicy:.returnCacheDataElseLoad, timeoutInterval: 5)
        let task = URLSession.shared.dataTask(with: urlRequest) {
            (data:Data?, response:URLResponse?, err:Error?) -> Void in
            guard err == nil else {
                return
            }
            if let data = data {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [Any]
                    var drinkShowString: String = ""
                    var drinkHotString: String = ""
                    for array in jsonArray! {
                        let drinkDict = array as! [String:String]
//                        returnDict["drinkName"] = drinkArray["drinkName"]!
//                        returnDict["drinkPrice"] = drinkArray["drinkPrice"]!
//                        returnDict["drinkHot"] = drinkArray["drinkHot"]!
                        if (Int(drinkDict["drinkHot"]!) == 1) {
                            drinkHotString = "🔥"
                        } else {
                            drinkHotString = ""
                        }
                        drinkShowString = "\(drinkHotString)\(drinkDict["drinkName"]! ) 💰\(drinkDict["drinkPrice"]! )"
                        self.drinkArray.append(drinkShowString)
//                        print("drinkName - \(drinkArray["drinkName"]!), drinkPrince - \(drinkArray["drinkPrice"]!), drinkHot - \(drinkArray["drinkHot"]!)")
                    }
                } catch {
                    print("Error - \(err)")
                }
                print(self.drinkArray.description)
            }
        }
        task.resume()
    }
}

