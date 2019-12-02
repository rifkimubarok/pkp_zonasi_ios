//
//  VCProfile.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 17/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

class VCProfile: UIViewController {
    
    let tokenMaster = TokenMaster()
    let profileHelper = ProfileHelper()
    
    @IBOutlet weak var tempat_tugas: UILabel!
    @IBOutlet weak var nuptk: UILabel!
    @IBOutlet weak var no_ukg: UILabel!
    @IBOutlet weak var mata_pelajaran: UILabel!
    @IBOutlet weak var pangkat_gol: UILabel!
    @IBOutlet weak var tempat_lahir: UILabel!
    @IBOutlet weak var jenjang: UILabel!
    @IBOutlet weak var jenis_kelamin: UILabel!
    
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var user_name: UILabel!
    
    override func viewDidLoad() {
        get_profile()
    }
    
    @IBAction func logout(_ sender: UIButton) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.set(false, forKey: "status")
        Switcher.updateRootVC()
    }
    
    func get_profile() {
        tokenMaster.requestToken { (status) in
            if status! {
                let token = UserDefaults.standard.string(forKey: "tokenSimpkb") ?? ""
                self.profileHelper.load_profile(token: token, no_ukg: "201500948333") { (status, profile) in
                    if status! {
                        DispatchQueue.main.async {
                            self.tempat_tugas.text = profile!.data?.sekolah?.nama
                            self.nuptk.text = profile?.data?.nuptk
                            self.no_ukg.text = profile?.data?.no_ukg
                            self.pangkat_gol.text = profile?.data?.golongan
                            let tgl_lahir = profile?.data?.tgl_lahir?.date?.prefix(10)
                            self.tempat_lahir.text = (profile?.data?.tmp_lahir)! + ", \(String(tgl_lahir!))"
                            self.jenjang.text = profile?.data?.sekolah?.jenjang?.keterangan
                            let kelamin = profile?.data?.kelamin == "L" ? "Laki-laki" : "Perempuan"
                            self.jenis_kelamin.text = kelamin
                        }
                    }
                }
            }
        }
        
        profileHelper.load_profile_moodle { (status, profile) in
            DispatchQueue.main.async {
                 self.fullname.text = profile?.fullname
                 self.user_name.text = profile?.username
            }
        }
    }
}
