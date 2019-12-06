//
//  CourseTableViewController.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 21/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import SDWebImage
// MARK: Definde course decodable
struct courseDecode  : Decodable{
let id : Int
let fullname: String
let shortname: String
let courseimage: String
}

struct CourseArr : Decodable {
    let courses : [courseDecode]
}

// MARK: Defined Course Object
struct courseObj {
    let id : Int
    let fullname: String
    let shortname: String
    let courseimage: String
    
    init(json: courseDecode) {
        self.id = json.id
        self.fullname = json.fullname
        self.shortname = json.shortname
        self.courseimage = json.courseimage
    }
}

// MARK: controller table
class CourseTableViewController: UITableViewController {
    let apiHelper = ApiHelper()
    var course_data = [courseObj]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        load_data_course(isRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return course_data.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCourse", for: indexPath) as! CourseTableViewCell
        let course = course_data[indexPath.item]
        cell.CourseName.text = course.fullname
        let urlImage = apiHelper.urlforImage + course.courseimage
        cell.bannerImage.sd_setImage(with: URL(string: urlImage), placeholderImage: UIImage(named: "Logo-PKP"))
        cell.bannerImage.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height - cell.CourseName.frame.height)
        cell.bannerImage.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let course = self.course_data[indexPath.item]
            self.navigateToSection(course_id: course.id)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width * 0.35	
    }
    
    // MARK: navigate to detail

    func navigateToSection(course_id : Int) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "detailCourse") as! VCDetailCourse
        newViewController.course_id = course_id;
        self.show(newViewController, sender: .none)
    }
    
    // MARK: Reload data
    func reload_data() {
        self.tableView.reloadData()
    }
    
    // MARK: Get Data
    
    func load_data_course(isRefresh : Bool) {
        course_data.removeAll()
        let token : String = UserDefaults.standard.string(forKey: "token") ?? ""
        if isRefresh {
            get_data()
        }else{
            let data = UserDefaults.standard.data(forKey: "course" + token)
            if data != nil {
                push_data(data: data!)
            }else{
                get_data()
            }
        }
    }
    
    func get_data() {
        CustomDialog.instance.showLoaderView()
        var endPointApi : String = apiHelper.EndPointAPI
        let token : String = UserDefaults.standard.string(forKey: "token") ?? ""
        endPointApi += "webservice/rest/server.php?";
        endPointApi += "wstoken=" + token + "&wsfunction=core_course_get_enrolled_courses_by_timeline_classification&moodlewsrestformat=json&classification=inprogress";
        guard let urlObj = URL(string: endPointApi) else { return }

        let task = URLSession.shared.dataTask(with: urlObj){
            (data,respone,error) in
            if(error != nil){
                print("We got error");
                CustomDialog.instance.hideLoaderView()
                return
            } 
            guard let data = data else { return }
            UserDefaults.standard.set(data, forKey: "course" + token)
            self.push_data(data: data)
        }
        task.resume()
    }
    
    func push_data(data: Data) {
        do{
        //                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: NSObject] else { return }
        //                guard let course : Any = json["courses"] as? Any ?? "" else { return }
                        
                        let json = try JSONDecoder().decode(CourseArr.self, from: data)
                        
                        for course in json.courses {
                            let cour = courseObj(json: course)
                            self.course_data.append(cour)
                        }
                        DispatchQueue.main.async {
                            self.reload_data()
                            CustomDialog.instance.hideLoaderView()
                        }
                    } catch let jsonErr{
                        print("Getting error", jsonErr, data)
                        DispatchQueue.main.async {
                            self.creatAlert(title: "Error", message: "Terjadi Kesalahan")
                            CustomDialog.instance.hideLoaderView()
                        }
                    }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: Creating Aler
    func creatAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }

}
extension UIView {
    func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
    }
}
