//
//  UserPresetViewMoreViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit

class UserPresetViewMoreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   
    private var itemStrings:[String] = []
    var selectedSection:Int = 0
    var pieSectionID = 0
    @IBOutlet weak var collectionView: UICollectionView!
    let db = dataAccess()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setSelectionStrings()
        setupCollectionView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return itemStrings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewMoreCell", for: indexPath) as! UserPresetCollectionViewCell
        
        if(selectedSection == 1){
            cell.imageOrIcon.backgroundColor = UIColor(named: itemStrings[indexPath.row])
        }else if(selectedSection == 2){
            cell.imageOrIcon.image = UIImage(named: itemStrings[indexPath.row])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        db.updatePieCustomization(type: selectedSection, section: pieSectionID, item: itemStrings[indexPath.row])
        self.performSegue(withIdentifier: "selectedUnwind", sender: nil)
    }
    
    func setSelectionStrings()
    {
        if(selectedSection == 1){
            itemStrings = ColorNames
        }else if(selectedSection == 2){
            itemStrings = ImageNames
        }
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}
