//
//  TestGraphViewController.swift
//  Vesea_Columbia
//
//  Created by Lahav Lipson on 5/26/16.
//  Copyright © 2016 Lahav Lipson. All rights reserved.
//

import UIKit
import SwiftCSV
import Firebase

class TestGraphViewController: UIViewController {
    
    var Q2 = NSMutableDictionary()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupQ2()
    }
    
    func setupQ2(){
        let ref = FIRDatabase.database().reference()
        
        print("HI LETS GET STARTED")
        var csvColumns = [String : [String]]()
        let coursesFile = "A2_ConcurrentCourses2"
        do {
            let csvURL = NSBundle(forClass: FrontViewController.self).URLForResource(coursesFile, withExtension: "csv")!
            let csv = try CSV(url: csvURL)
            csvColumns = csv.columns
        } catch {
            print("Failed!")
            fatalError(coursesFile + ".csv could not be found")
        }
        print("csv collumn count is \(csvColumns["Taken first"]!.count)")
        
        var index = 0
        while index < csvColumns["Course1 Index"]!.count {
            let index1 = csvColumns["Course1 Index"]![index]
            let index2 = csvColumns["Course2 index"]![index]
            let pairEntry : NSArray = [csvColumns["Taken first"]![index],
                                     csvColumns["2nd before 1st"]![index],
                                     csvColumns["2nd concurrent 1st"]![index],
                                     csvColumns["2nd after 1st"]![index]]
            
            
            
            if let coursePairsForIndex1 = Q2.objectForKey(String(index1)) as? NSMutableDictionary{
                coursePairsForIndex1.setValue(pairEntry, forKey: String(index2))
            } else {
                let coursePairsForIndex1 = NSMutableDictionary()
                coursePairsForIndex1.setValue(pairEntry, forKey: String(index2))
                Q2.setValue(coursePairsForIndex1, forKey: String(index1))
                print(index1)
            }
            
            
            
            
           index += 1
        
        }
        
        print("done")
        
        print(Q2["15488"]!["2940"] as! NSArray)
        
        //ref.child("Q2").child("4381").setValue((self.Q2["4381"]! as! NSMutableDictionary) as! NSDictionary)
        
        ref.child("Q2").setValue(self.Q2 as! NSDictionary)
        print("Done uploading")
    }
    
}
