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

class VCLogin: UIViewController {
    
    @IBOutlet weak var txtUser: UITextField!
    @IBOutlet weak var txtPassword: HideShowPasswordTextField!
    @IBOutlet weak var lblValidasi: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblValidasi.isHidden = true
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnActionLogin(_ sender: Any) {
        let lock = NSLock()
        let url = "https://pkp.belajar.kemdikbud.go.id/webservice/rest/server.php?wstoken=099a8fd90660ed31991acc7c59d729f9&wsfunction=core_user_get_users_by_field&moodlewsrestformat=json&field=email&values[0]=adminpkp@simpkb.id";
        guard let urlObj = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: urlObj){(data, response,error) in
            do {
//                guard let data = data else { return }
//                print(data)
//                print("ini dari dalem cok")
//                let dataAsString  = String(data: data,
//                                           encoding: .utf8)
//                print(dataAsString)
//                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                var profiles = try JSONDecoder().decode([Profile].self, from: data!)
                for prof in profiles{
                    print(prof.firstname)
                }
                lock.unlock()
            } catch let jsonErr{
                print("We got error: ",jsonErr)
            }
        }
        task.resume()
        lock.lock()
        print("hi")
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
        UserDefaults.standard.set(true, forKey: "status")
        Switcher.updateRootVC()
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


