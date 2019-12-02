//
//  ViewController.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 15/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

struct Profile: Decodable {
    let username : String
    let firstname : String
    let fullname : String
    let email : String
}

struct Token : Decodable {
    let token : String
    let error : String
    let errorcode : String
//    let privatetoken : String
}

class VCLogin: UIViewController,UINavigationControllerDelegate {
    
    
    @IBOutlet weak var txtUser: UITextField!
  
    @IBOutlet weak var txtPassword: HideShowPasswordTextField!
    @IBOutlet weak var lblValidasi: UILabel!
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var apiHelper = ApiHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblValidasi.isHidden = true
        // Do any additional setup after loading the view.
        txtPassword.isSecureTextEntry = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigateLoginSimpkb() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginSimpkb") as! VCLoginSimpkb
        self.show(newViewController, sender: .none)
    }
    
    @IBAction func btnActionLogin(_ sender: Any) {

                guard let _ = txtUser.text, txtUser.text?.count != 0 else {
                    lblValidasi.isHidden = false
                    lblValidasi.text = "User Tidak boleh Kosong!"
                    return
                }
                
                guard let _ = txtPassword.text, txtPassword.text?.count != 0 else {
                    lblValidasi.isHidden = false
                    lblValidasi.text = "Password Tidak boleh Kosong!"
                    return
                }
                lblValidasi.isHidden = true
                
        //        let lock = NSLock()
                let dialog = CustomDialog.instance
                dialog.showLoaderView()
                checkUser_by_password(){status,json,error in
                    DispatchQueue.main.async {
                        dialog.hideLoaderView()
                        if status! {
        //                    var urlString : String = self.apiHelper.EndPointAPI
        //                    urlString += "admin/tool/mobile/launch.php?service=moodle_mobile_app&urlscheme=pkpzonasi://login/token?param=&passport="
        //                    guard let url = URL(string: urlString) else { return }
                            //Login via safari web browser
        //                    UIApplication.shared.open(url)
                            //login via webkit view
        //                    self.navigateLoginSimpkb()
                            UserDefaults.standard.set(true, forKey: "status")
                            Switcher.updateRootVC()
                        }else{
                            self.creatAlert(message: "Username/Password Salah!")
                        }
                    }
                    
                }
    }
//    @IBAction func btnActionLogin(_ sender: Any) {
//
//
////        UserDefaults.standard.set(true, forKey: "status")
////        Switcher.updateRootVC()
//    }
    // MARK: Login
    func checkUser(completion: @escaping (_ status : Bool?, _ json: Any?, _ error: Error?)->()){
        let username : String = txtUser.text!
        let password : String = txtPassword.text!
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        
        //Server PKP
//        let url = apiHelper.EndPointAPI + "webservice/rest/server.php?wstoken=" + apiHelper.default_token + "&wsfunction=core_user_get_users_by_field&moodlewsrestformat=json&field=email&values[0]="+username;
        
        // Server Bagren
        let url = apiHelper.EndPointAPI + "webservice/rest/server.php?wstoken=" + apiHelper.default_token + "&wsfunction=core_user_get_users_by_field&moodlewsrestformat=json&field=username&values[0]="+username;
        
        
            guard let urlObj = URL(string: url) else { return }
            let task = URLSession.shared.dataTask(with: urlObj){(data, response,error) in
                guard let data = data else {
                    print("Nothing data to retrive")
                    completion(false,nil,error)
                    return
                }
                do {
                    let json = try JSONDecoder().decode([Profile].self,from: data)
                    if json.count > 0 {
                        completion(true,json,error)
                        return
                    }else{
                        completion(false,json,error)
                        return
                    }
                    
                } catch let jsonErr{
                    print("We got error: ",jsonErr)
                }
            }
        task.resume()
    }
    
    // MARK: Create Alert
    func creatAlert(message: String){
        let alertController = UIAlertController(title: "Pemberitahuan", message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func checkUser_by_password(completion: @escaping (_ status : Bool?, _ json: Any?, _ error: Error?)->()){
        let username : String = txtUser.text!
        let password : String = txtPassword.text!
        
        UserDefaults.standard.set(username, forKey: "username")
        UserDefaults.standard.set(password, forKey: "password")
        
        let url = apiHelper.EndPointAPI + "login/token.php?service=moodle_mobile_app&username=" + username + "&password=" + password
        
        let urlreq = URL(string: url)!
        
        let request = URLSession.shared.dataTask(with: urlreq){(data, response,error) in
            guard let data = data else {
                print("Nothing data to retrive")
                completion(false,nil,error)
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
//                print(json)
                let token : String = json["token"] as? String ?? ""
                print("Hello this is my token = " + token)
                if json["token"] != nil {
                    UserDefaults.standard.set(token, forKey: "token")
                    completion(true,json,error)
                    return
                }else{
                    completion(false,json,error)
                    return
                }
            } catch let jsonErr{
                print("We got error: ",jsonErr)
            }
        }
        request.resume()
    }
    
}
    // MARK: HideShowPasswordTextFieldDelegate
    // Implementing this delegate is entirely optional.
    // It's useful when you want to show the user that their password is valid.
    extension VCLogin: HideShowPasswordTextFieldDelegate {
        func isValidPassword(_ password: String) -> Bool {
            return password.count > 7
        }
    }
    
    // MARK: Private helpers
    extension VCLogin {
        private func setupPasswordTextField() {

            
            txtPassword.passwordDelegate = self
            txtPassword.borderStyle = .none
            txtPassword.clearButtonMode = .whileEditing
            txtPassword.layer.borderWidth = 0.5
            txtPassword.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
            txtPassword.borderStyle = UITextField.BorderStyle.none
            txtPassword.clipsToBounds = true
            txtPassword.layer.cornerRadius = 0
            
            txtPassword.rightView?.tintColor = UIColor(red: 0.204, green: 0.624, blue: 0.847, alpha: 1)
            
            //txtUser.passwordDelegate = self
            txtUser.borderStyle = .none
            txtUser.clearButtonMode = .whileEditing
            txtUser.layer.borderWidth = 0.5
            txtUser.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
            txtUser.borderStyle = UITextField.BorderStyle.none
            txtUser.clipsToBounds = true
            txtUser.layer.cornerRadius = 0
            
            txtUser.rightView?.tintColor = UIColor(red: 0.204, green: 0.624, blue: 0.847, alpha: 1)
        }
    }


