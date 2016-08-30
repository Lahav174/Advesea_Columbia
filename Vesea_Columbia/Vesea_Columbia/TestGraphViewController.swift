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
    
//    var Q2 = NSMutableDictionary()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...5{
            print()
        }
        
        setupQ2()
        
        //let ref = FIRDatabase.database().reference()
        //ref.child("Q2").setValue("noting")
        
    }
    
    func setupQ2(){
        let ref = FIRDatabase.database().reference()
        let fileNames = ["A2_ConcurrentCourses_(00000-00726)",
                         "A2_ConcurrentCourses_(00727-01453)",
                         "A2_ConcurrentCourses_(01454-02180)",
                         "A2_ConcurrentCourses_(02181-02907)",
                         "A2_ConcurrentCourses_(02908-03634)",
                         "A2_ConcurrentCourses_(03635-04361)",
                         "A2_ConcurrentCourses_(04362-05088)",
                         "A2_ConcurrentCourses_(05089-05813)"]
        let catagories = ["0-726","727-1453","1454-2180","2181-2907",
                          "2908-3634","3635-4361","4362-5088","5089-5813"]
        
        for i in 0...7{
            var Q2 = NSMutableDictionary()
            
            //Readfile
            var csvColumns = [String : [String]]()
            let coursesFile = fileNames[i]//"A2_ConcurrentCourses2"
            do {
                let csvURL = NSBundle(forClass: FrontViewController.self).URLForResource(coursesFile, withExtension: "csv")!
                let csv = try CSV(url: csvURL)
                csvColumns = csv.columns
            } catch {
                print("Failed!")
                fatalError(coursesFile + ".csv could not be found")
            }
            
            //Write to Q2 dict
            var index = 0
            while index < csvColumns["Course1 Index"]!.count {
                let index1 = csvColumns["Course1 Index"]![index]
                let index2 = csvColumns[" Course2 index"]![index]
                let pairEntry : NSArray = [csvColumns[" Took first"]![index],
                                           csvColumns[" 2nd before 1st"]![index],
                                           csvColumns[" concurrently"]![index],
                                           csvColumns[" 2nd after 1st"]![index]]
                
                
                
                if let coursePairsForIndex1 = Q2.objectForKey(String(index1)) as? NSMutableDictionary{
                    coursePairsForIndex1.setValue(pairEntry, forKey: String(index2))
                } else {
                    let coursePairsForIndex1 = NSMutableDictionary()
                    coursePairsForIndex1.setValue(pairEntry, forKey: String(index2))
                    Q2.setValue(coursePairsForIndex1, forKey: String(index1))
                    //print(index1)
                }
                
                index += 1
            }
            print("Done with #\(i)")
            
            ref.child("Q2").child(catagories[i]).updateChildValues(Q2 as [NSObject : AnyObject])
        }
        
        print("done")
        
        //print(Q2["590"]!["1497"] as! NSArray)
        
        //ref.child("Q2").child("4381").setValue((self.Q2["4381"]! as! NSMutableDictionary) as! NSDictionary)
        
        //ref.child("Q2").setValue(self.Q2 as! NSDictionary)
        print("Done uploading")
    }
    
}
