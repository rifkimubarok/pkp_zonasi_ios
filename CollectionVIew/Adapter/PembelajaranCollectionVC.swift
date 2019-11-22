//
//  PembelajaranCollectionVC.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 18/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Course"

class PembelajaranCollectionVC: UICollectionViewController {
    var course_obj = [Course]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let collectionViewLayout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.itemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewLayout.estimatedItemSize = CGSize(width : 175, height: 150)
        let count = 1...10
        for number in count {
            let course = Course(course_id: String(number), course_name: "Course Ke-"+String(number), imagename: String(number))
            course_obj.append(course)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Aktifitas"
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 10
    }

    // init banyaknya course
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return course_obj.count
    }

    
    //init set data to cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PembelajaranViewCell 
        let course = course_obj[indexPath.item]
        // Configure the cell
        cell.course_name.text = course.course_name
        cell.course_image.image = UIImage(named: course_obj[indexPath.item].imagename)?.resizeImage(120, opaque: true)
        return cell
    }
    
     func collectionView(_ collectionView: UICollectionView, sizeOfPhotoAtIndexPath indexPath: IndexPath) -> CGSize {
            return UIImage(named: course_obj[indexPath.item].imagename)!.size
        }
    
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
