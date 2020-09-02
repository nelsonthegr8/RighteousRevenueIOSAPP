//
//  UserPresetViewMoreViewController.swift
//  RighteousRevenue
//
//  Created by Nelson Brumaire on 8/11/20.
//  Copyright © 2020 Nelson Brumaire. All rights reserved.
//

import UIKit
import SwiftTheme

class UserPresetViewMoreViewController: UIViewController {
  //MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
//MARK: - Variables
    private var itemStrings:[String] = []
    var selectedSection:Int = 0
    var pieSectionID = 0
    let db = dataAccess()
    
//MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setColorTheme()
        setSelectionStrings()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
//MARK: - Set up Color Scheme
    func setColorTheme(){
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        collectionView.theme_backgroundColor = GlobalPicker.backgroundColor
        overrideUserInterfaceStyle = GlobalPicker.userInterfaceStyle[ThemeManager.currentThemeIndex]
    }
}

//MARK: - CollectionView Data and Delegate and Flow Delegate

extension UserPresetViewMoreViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return itemStrings.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "viewMoreCell", for: indexPath) as! UserPresetCollectionViewCell
        
        if(selectedSection == 1){
            cell.imageOrIcon.backgroundColor = UIColor(named: itemStrings[indexPath.row])
        }else if(selectedSection == 2){
            cell.imageOrIcon.image = UIImage(named: itemStrings[indexPath.row])
            cell.imageOrIcon.theme_tintColor = GlobalPicker.tabButtonTintColor
        }
        
        cell.imageOrIcon.layer.cornerRadius = 10
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: collectionView.frame.height/4)
    }
}
