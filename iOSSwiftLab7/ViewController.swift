//
//  ViewController.swift
//  iOSSwiftLab7
//
//  Created by Gates on 2017/3/24.
//  Copyright © 2017年 Gates. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate {

    // 宣告飲料選單PickerView
    let drinkPickerView = UIPickerView()
    
    // 宣告飲料品項資料陣列
    var drinkArray = [[String:String]]()
    
    // 宣告甜度選項陣列
    var sugarArray = ["全糖","少糖","半糖","微糖","無糖"]
    
    // 宣告溫度選項陣列
    var iceArray = ["正常","多冰","少冰","去冰","熱飲"]
    
    //IBOutlet
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var drinkTextField: UITextField!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var noteTextView: UITextView!
    
    // 使用者下單按鈕事件
    @IBAction func orderBtnAction(_ sender: UIButton) {
        
        self.view.endEditing(true)
        if sugarSegmentedControl.selectedSegmentIndex >= 0 && iceSegmentedControl.selectedSegmentIndex >= 0 && (nameTextField.text?.characters.count)! > 0 && (drinkTextField.text?.characters.count)! > 0 {
            self.loadingView.isHidden = false
            let orderName = nameTextField.text!
            let orderDrinkIndex = drinkPickerView.selectedRow(inComponent: 0)
            let orderDrink = drinkTextField.text!
            let orderDrinkPrice = drinkArray[orderDrinkIndex]["drinkPrice"]!
            let orderSuger = sugarArray[sugarSegmentedControl.selectedSegmentIndex]
            let orderIce = iceArray[iceSegmentedControl.selectedSegmentIndex]
            let orderNote = noteTextView.text!.replacingOccurrences(of: "有什麼話要留給彼得潘嗎？", with: "")
            let todaysDate:NSDate = NSDate()
            let dateFormatter:DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyy-MM-dd HH:mm"
            let orderDatetime:String = dateFormatter.string(from: todaysDate as Date)
            print("訂單名字-\(orderName), 訂購飲料編號-\(orderDrinkIndex), 訂購飲料-\(orderDrink), 訂購飲料金額-\(orderDrinkPrice), 甜度-\(orderSuger), 溫度-\(orderIce), 備註-\(orderNote), 訂購時間-\(orderDatetime)")
        
//            let url = URL(string: "https://sheetsu.com/apis/v1.0/ab8e38e50f31")
//            var urlRequest = URLRequest(url: url!)
//            urlRequest.httpMethod = "POST"
//            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//            let dictionary = ["name":orderName, "drinkIndex":orderDrinkIndex, "drink":orderDrink, "drinkPrice":orderDrinkPrice, "sugar":orderSuger, "ice":orderIce, "note":orderNote, "orderDatetime":orderDatetime] as [String : Any]
//            do {
//                let data = try  JSONSerialization.data(withJSONObject: dictionary, options: [])
//                let task = URLSession.shared.uploadTask(with: urlRequest, from: data, completionHandler: { (retData, res,
//                    err) in
//                    if let retData = retData {
//                        do {
//                            _ = try JSONSerialization.jsonObject(with: retData, options: [])
//                            if err != nil {
//                                let alertController = UIAlertController(title: "系統異常", message: "請再試一次", preferredStyle: UIAlertControllerStyle.alert)
//                                let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) -> Void in
//                                    self.loadingView.isHidden = true
//                                })
//                                alertController.addAction(okAction)
//                                self.present(alertController, animated: true, completion: nil)
//                            } else {
//                                let alertController = UIAlertController(title: "訂單資料已送出", message: "謝謝您的訂購", preferredStyle: UIAlertControllerStyle.alert)
//                                let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) -> Void in
//                                    self.loadingView.isHidden = true
//                                    self.nameTextField.text = ""
//                                    self.drinkTextField.text = ""
//                                    self.noteTextView.text = "有什麼話要留給彼得潘嗎？"
//                                    self.segmentedControlDisable()
//                                })
//                                alertController.addAction(okAction)
//                                self.present(alertController, animated: true, completion: nil)
//                            }
//                        }
//                        catch { }
//                    } })
//                task.resume()
//            }
            
            // 新增Google App Script的網址
            let scriptUrl = "https://script.google.com/macros/s/AKfycbyAhSHc9FtmXhM6b0J7ZZMoMgjjf6We8wL6ljtZV7kbmhRsi-I/exec"

            // QueryString與app 串資料
            let urlWithParams = scriptUrl + "?name=\(orderName)&drinkindex=\(orderDrinkIndex)&drink=\(orderDrink)&drinkprice=\(orderDrinkPrice)&sugar=\(orderSuger)&ice=\(orderIce)&note=\(orderNote)&orderdatetime=\(orderDatetime)&type=get"
            
            let url = URL(string: urlWithParams.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
            print(url)

            var urlRequest = URLRequest(url:url)
            
            // Set request HTTP method to GET. It could be POST as well
            urlRequest.httpMethod = "GET"
            
            // Excute HTTP Request
            let task = URLSession.shared.dataTask(with: urlRequest as URLRequest) {
                data, response, error in
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print("responseString = \(responseString!)")
                
                // Check for error
                if error != nil {
                    print("error=\(error!)")
                    let alertController = UIAlertController(title: "系統異常", message: "請再試一次", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                        self.loadingView.isHidden = true
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    let alertController = UIAlertController(title: "訂單資料已送出", message: "謝謝您的訂購", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                        self.loadingView.isHidden = true
                        self.nameTextField.text = ""
                        self.drinkTextField.text = ""
                        self.noteTextView.text = "有什麼話要留給彼得潘嗎？"
                        self.segmentedControlDisable()
                    })
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            task.resume()
         } else {
            let alertController = UIAlertController(title: "訂單資料沒有填齊全", message: "記得再檢查一下哦！", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "確認", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // 進入後台事件
    @IBAction func goAdminVCAction(_ sender: UIBarButtonItem) {
        if UserDefaults.standard.bool(forKey: "logonAdmin") == false {
            var inputTextField: UITextField?
            let passwordPrompt = UIAlertController(title: "查詢訂單資料", message: "請輸入密碼", preferredStyle: UIAlertControllerStyle.alert)
            passwordPrompt.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
            passwordPrompt.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: { (action) -> Void in
                let inputPasswordText = inputTextField?.text!
                if inputPasswordText == "deeplovepeter" {
                    UserDefaults.standard.set(true, forKey: "logonAdmin")
                    let adminVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderAllVC")
                    self.navigationController?.pushViewController(adminVC!, animated: true)
                } else {
                    UserDefaults.standard.set(false, forKey: "logonAdmin")
                    let passwordError = UIAlertController(title: "查詢訂單資料", message: "密碼錯誤", preferredStyle: UIAlertControllerStyle.alert)
                    passwordError.addAction(UIAlertAction(title: "確認", style: UIAlertActionStyle.default, handler: nil))
                    self.present(passwordError, animated: true, completion: nil)
                }
            }))
            passwordPrompt.addTextField(configurationHandler: {(textField: UITextField!) in
                textField.placeholder = "請輸入密碼"
                textField.isSecureTextEntry = true
                inputTextField = textField
            })
            
            self.present(passwordPrompt, animated: true, completion: nil)
        } else {
            let adminVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderAllVC")
            self.navigationController?.pushViewController(adminVC!, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "彼得潘請飲料"
        if UserDefaults.standard.object(forKey: "firstGetJson") != nil {
            // exist
            UserDefaults.standard.set(false, forKey: "firstGetJson")
        } else {
            // not exist
            UserDefaults.standard.register(defaults: ["firstGetJson" : false])
        }
        if UserDefaults.standard.object(forKey: "logonAdmin") != nil {
            // exist
            UserDefaults.standard.set(false, forKey: "logonAdmin")
        } else {
            // not exist
            UserDefaults.standard.register(defaults: ["logonAdmin" : false])
        }
        getJsondata()
        segmentedControlDisable()
//        initDrinkPickerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 初始飲料選單DrinkPickerView
    func initDrinkPickerView() {
        // 設定 UIPickerView 的 delegate 及 dataSource
        drinkPickerView.delegate = self
        drinkPickerView.dataSource = self
        
        // 將 UITextField 原先鍵盤的視圖更換成 UIPickerView
        drinkTextField.inputView = drinkPickerView
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.themeBlue()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確認", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneAction))
        let spaceLeftButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let noteButton = UIBarButtonItem(title:"搖晃手機隨機選飲料", style: UIBarButtonItemStyle.plain, target:nil, action: nil)
        noteButton.isEnabled = false
        let spaceRightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.closeKeyboard))
        
        toolBar.setItems([cancelButton, spaceLeftButton, noteButton, spaceRightButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        drinkTextField.inputView = drinkPickerView
        drinkTextField.inputAccessoryView = toolBar
        
        //加上手勢按鈕
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.closeKeyboard))
        view.addGestureRecognizer(tap)
    }

    // 飲料選項按下確定事件
    func doneAction() {
        let selectedRowForPicker = drinkPickerView.selectedRow(inComponent: 0)
        drinkTextField.text = drinkArray[selectedRowForPicker]["drinkShowString"]
        self.view.endEditing(true)
    }
    
    // 飲料選項按下取消事件
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    // PickerView data source && function
    // 有幾個區塊
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    // 裡面有幾列
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return drinkArray.count
    }
    
    // PickerView選擇到的那列要做的事
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        segmentedControlEnable()
        if Int(drinkArray[row]["drinkHot"]!) == 1 {
            iceSegmentedControl.setEnabled(true, forSegmentAt: 4)
        } else {
            iceSegmentedControl.setEnabled(false, forSegmentAt: 4)
        }
        print("drinkHot-\(drinkArray[row]["drinkHot"]!)")
    }
    
    //設定每列PickerView要顯示的內容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tmpDic = drinkArray[row]
        return tmpDic["drinkShowString"]
    }
    
    // 使用者清除飲料資料後判斷事件
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == drinkTextField {
            segmentedControlDisable()
        }
        return true
    }
    
    // 使用者選完飲料後判斷事件
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == drinkTextField {
            if drinkTextField.text?.characters.count == 0 {
                segmentedControlDisable()
            } else {
                segmentedControlEnable()
                let tmpDic = drinkArray[drinkPickerView.selectedRow(inComponent: 0)]
                if Int(tmpDic["drinkHot"]!) == 1 {
                    iceSegmentedControl.setEnabled(true, forSegmentAt: 4)
                } else {
                    iceSegmentedControl.setEnabled(false, forSegmentAt: 4)
                }
                print("drinkHot-\(tmpDic["drinkHot"]!)")
            }
        }
    }
    
    // 甜度選項、溫度選項設定Disable
    func segmentedControlDisable() {
        sugarSegmentedControl.isUserInteractionEnabled = false
        sugarSegmentedControl.selectedSegmentIndex = -1
        sugarSegmentedControl.alpha = 0.5
        iceSegmentedControl.isUserInteractionEnabled = false
        iceSegmentedControl.selectedSegmentIndex = -1
        iceSegmentedControl.alpha = 0.5
    }
    
    // 甜度選項、溫度選項設定Enable
    func segmentedControlEnable() {
        sugarSegmentedControl.isUserInteractionEnabled = true
        sugarSegmentedControl.alpha = 1.0
        iceSegmentedControl.isUserInteractionEnabled = true
        iceSegmentedControl.alpha = 1.0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == noteTextView {
            noteTextView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == noteTextView {
            if noteTextView.text?.characters.count == 0 {
               noteTextView.text = "有什麼話要留給彼得潘嗎？"
            }
        }
    }
    
    // Get Json data
    func getJsondata() {
        
        var returnDict:Dictionary = [String:String]()
        
        //let url = URL(string: "https://sheetsu.com/apis/v1.0/1f3dccf61c93")
        let url = URL(string: "https://spreadsheets.google.com/feeds/list/1n51rRWaDO4-X2EdszIsBqFBZ7ZbYs0dpoH2ul0Uoz-8/1/public/values?alt=json")
        print(UserDefaults.standard.bool(forKey: "firstGetJson"))
        var urlRequest:URLRequest?
        if UserDefaults.standard.bool(forKey: "firstGetJson") == false {
            urlRequest = URLRequest(url: url!, cachePolicy:.reloadIgnoringLocalCacheData, timeoutInterval: 5)
            UserDefaults.standard.set(true, forKey: "firstGetJson")
        } else {
            urlRequest = URLRequest(url: url!, cachePolicy:.returnCacheDataElseLoad, timeoutInterval: 5)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest!) {
            (data:Data?, response:URLResponse?, err:Error?) -> Void in
            guard err == nil else {
                return
            }
            if let data = data {
                do {
                    let jsonDict = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as? [String:AnyObject]
                    let jsonDictForFeed = jsonDict?["feed"] as! [String: AnyObject]
                    let jsonArray = jsonDictForFeed["entry"] as! [[String: AnyObject]]
                
                    var drinkShowString: String = ""
                    var drinkTopString: String = ""
                    for drinkDict in jsonArray {
                        let drinkNameReadString: String = drinkDict["gsx$drinkname"]!["$t"]! as! String
                        returnDict["drinkName"] = drinkNameReadString
                        let drinkPriceReadString: String = drinkDict["gsx$drinkprice"]!["$t"]! as! String
                        returnDict["drinkPrice"] = drinkPriceReadString
                        let drinkTopReadString: String = drinkDict["gsx$drinktop"]!["$t"]! as! String
                        let drinkHotReadString: String = drinkDict["gsx$drinkhot"]!["$t"]! as! String
                        returnDict["drinkHot"] = drinkHotReadString
                        
                        if Int(drinkTopReadString) == 1 {
                            drinkTopString = "🔥"
                        } else {
                            drinkTopString = ""
                        }
                        drinkShowString = "\(drinkTopString)\(drinkNameReadString) 💰\(drinkPriceReadString)"
                        returnDict["drinkShowString"] = drinkShowString
                        self.drinkArray.append(returnDict)
                        print(self.drinkArray)
//                        print("drinkName - \(drinkArray["drinkName"]!), drinkPrince - \(drinkArray["drinkPrice"]!), drinkHot - \(drinkArray["drinkHot"]!)")
                    }
                } catch {
                    print("Error - \(err)")
                }
                DispatchQueue.main.async { //不加這個會很慢，因為更新Storyboard上面的UI都要在主線執行
                    self.initDrinkPickerView()
                }
                print(self.drinkArray.description)
            }
        }
        task.resume()
    }
    
    // 搖晃手機，隨機選取飲料
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == .motionShake { //如果偵測到的事件是搖晃手機的話
            let randomNum = Int(arc4random()) % drinkArray.count
            let tmpDic = drinkArray[randomNum]
            print("shanking now - \(tmpDic["drinkShowString"]!)")
            drinkPickerView.selectRow(randomNum, inComponent: 0, animated: true)
            //drinkTextField.text = tmpDic["drinkShowString"]!
        }
    }
}

