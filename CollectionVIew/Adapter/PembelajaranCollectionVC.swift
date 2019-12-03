//
//  PembelajaranCollectionVC.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 18/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CourseItem"

class PembelajaranCollectionVC: UICollectionViewController {
    var courseSectionObj = [sectionObj]()
    var apiHelper = ApiHelper()
    var estimateWidth = 160.0
    var cellMarginSize = 16.0
    var Text : String = ""
    var course_id : Int = -1
    var iconName = ["1","2","2","3","4","5","6","7","8","9","10","1"];
    override func viewDidLoad() {
        super.viewDidLoad()
//        let collectionViewLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
//        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
//        collectionViewLayout.estimatedItemSize = CGSize(width : 175, height: 150)
        self.collectionView.register(UINib(nibName: "PembelajaranItemCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier);
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Aktivitas"
        self.setupGridView()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name:NSNotification.Name(rawValue: "load"), object: nil)
//        self.get_data(CourseId: 12)
        print(Text)
    }
    
    // MARK: NotificationCenter
    
    @objc func loadList(notification: NSNotification){
        
        let data = notification.userInfo
        guard let courseId = data!["courseId"] else { return }
        self.course_id = courseId as! Int
        load_data_course(isRefresh: false,CourseId: courseId as! Int)
//        get_data(CourseId: courseId as! Int)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // init banyaknya course
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return courseSectionObj.count
    }

    
    //init set data to cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PembelajaranItemCell
        let course = courseSectionObj[indexPath.item]
        // Configure the cell
        cell.course_name.text = course.name
        cell.course_image.contentMode = .scaleAspectFit
        if indexPath.item <= (iconName.count - 1) {
            cell.course_image.image = UIImage(named:iconName[indexPath.item])?.resizeImage(CGFloat(self.estimateWidth), opaque: false)
        }
        return cell
    }
    
//     func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
//            return UIImage(named: course_obj[indexPath.item].imagename)!.size
//        }
    
    
    // MARK: LOAD MODULE
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            let section = self.courseSectionObj[indexPath.item]
            self.navigateToSection(module: section)
        }
    }
    
    
    // MARK: navigate to detail

    func navigateToSection(module: sectionObj) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "detailModule") as! VCModule
        newViewController.moduleArr = module
        self.show(newViewController, sender: .none)
    }
    
    
    
    // MARK: Get_data
    
    func load_data_course(isRefresh : Bool, CourseId : Int) {
        courseSectionObj.removeAll()
        let token : String = UserDefaults.standard.string(forKey: "token") ?? ""
        if isRefresh {
            get_data(CourseId: CourseId)
        }else{
            let data = UserDefaults.standard.data(forKey: "sectionObj" + String(CourseId))
            if data != nil {
                push_data(data: data!)
            }else{
                get_data(CourseId: CourseId)
            }
        }
    }
    
    func get_data(CourseId : Int) {
//        let count = 1...10
//        for number in count {
//            let course = Course(course_id: String(number), course_name: "Course Ke-"+String(number), imagename: String(number))
//            course_obj.append(course)
//        }
//
//        collectionView.reloadData()
        
        CustomDialog.instance.showLoaderView()
        var endPointApi : String = apiHelper.EndPointAPI
        let token : String = UserDefaults.standard.string(forKey: "token") ?? ""
        endPointApi += "webservice/rest/server.php?";
        endPointApi += "wstoken=" + token + "&wsfunction=core_course_get_contents&moodlewsrestformat=json&courseid=" + String(CourseId);
        print(endPointApi)
        guard let urlObj = URL(string: endPointApi) else { return }
        
        let getData = URLSession.shared.dataTask(with: urlObj){
            (data,response,error) in
            if(error != nil){
                print("We got error");
                CustomDialog.instance.hideLoaderView()
                return
            }
            guard let data = data else { return }
            UserDefaults.standard.data(forKey: "sectionObj"+String(CourseId))
            self.push_data(data: data)
        }
        getData.resume()
    }
    
    func push_data(data: Data) {

        do{
            let json = try JSONDecoder().decode([sectionObj].self, from: data)
            for course in json {
                courseSectionObj.append(course)
                print(course.name)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                CustomDialog.instance.hideLoaderView()
            }
            
        }catch let jsonErr{
            print(jsonErr)
            self.creatAlert(title: "Error", message: "Terjadi Kesalahan")
            CustomDialog.instance.hideLoaderView()
        }
    }
    

}

extension PembelajaranCollectionVC : UICollectionViewDelegateFlowLayout{

    //    MARK: Layout spacing
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = self.calculateWith()
            return CGSize(width: width, height: width)
        }
        
        func calculateWith() -> CGFloat {
            let estimatedWidth = CGFloat(estimateWidth)
            let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
            
            let margin = CGFloat(cellMarginSize * 2)
            let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
            
            return width
        }
    
    
    // MARK: Creating Aler
    func creatAlert(title: String, message: String){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
}
