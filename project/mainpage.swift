//
//  mainpage.swift
//  project
//
//  Created by Kunwardeep Singh on 2020-06-10.
//  Copyright © 2020 user174655. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MainPage : UIViewController,UITableViewDelegate,UITableViewDataSource
{
    @IBOutlet weak var notenote: UITableView!
    var senttitle:String = ""
    var sentdescription:String = ""
    var sentColor:String = ""
    var sentid:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        notenote.dataSource = self
        notenote.delegate = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        notenote.reloadData()
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value:Int?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        
        //let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        //request.sortDescriptors = [sortDescriptor]
        //print(sortDescriptor)
        
        //let sdSortDate = NSSortDescriptor.init(key: "date", ascending: false)
        //request.sortDescriptors = [sdSortDate]
        //let result4 = try! context.fetch(request)
        //print(result4)
        
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            value = result.count
            //print(result.count)
            //for data in result as! [NSManagedObject] {
               //print(data.value(forKey: "descriptions") as! String)
          //}

        } catch {

            print("Failed")
        }

        return value!

    }
    
    //@IBOutlet weak var color: UIButton!
    
    @IBOutlet weak var viewNew: UIView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "one")
        
        
        
        
        if (cell == nil) {
            cell = UITableViewCell(
                style: UITableViewCell.CellStyle.default,
                reuseIdentifier: "one")
        }
        var blue:NSManagedObject?

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        let sdSortDate = NSSortDescriptor.init(key: "date", ascending: false)
        request.sortDescriptors = [sdSortDate]
        //let result4 = try! context.fetch(request)
        //print(result4)
               //print(sortDescriptor)
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            blue = result[indexPath.row] as? NSManagedObject
           //print(blue!)

            //for data in result as! [NSManagedObject] {
                
                
                
                //print(result[indexPath.row] as? String == "green")

          //}



        } catch {

            print("Failed")
        }



        //print(blue?.value(forKey: "color") as? String)
        cell?.textLabel!.text = blue?.value(forKey: "title") as? String
        //cell?.detailTextLabel?.text = (blue?.value(forKey: "date") as? String)
        //print(blue?.value(forKey: "date"))
        if ((blue?.value(forKey: "color") as? String) == "red") {
            
            
            //cell?.layer.addBorder(edge: UIRectEdge.top, color: UIColor.red, thickness: 0.5)
            let bottomBorder = CALayer()
//            bottomBorder.frame = CGRect(x: 0.0, y: (cell?.frame.size.height)!-1, width: UIScreen.main.bounds.width, height: 2.0)
            
            bottomBorder.frame = CGRect(x: UIScreen.main.bounds.width - 5, y: 0.0, width: 4.0, height: (cell?.frame.size.height)!)
            bottomBorder.backgroundColor = CGColor.init(srgbRed: 225, green: 0, blue: 0, alpha: 1)

            cell?.layer.addSublayer(bottomBorder)

        }
        
        else if blue?.value(forKey: "color") as? String == "green"{
            

            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: UIScreen.main.bounds.width - 5, y: 0.0, width: 5.0, height: (cell?.frame.size.height)!)
            //bottomBorder.frame = CGRect(x: self.frame.width - frame.width, y: 0, width: thickness, height: self.frame.height)


            bottomBorder.backgroundColor = CGColor.init(srgbRed: 0, green: 255, blue: 0, alpha: 1)
            cell?.layer.addSublayer(bottomBorder)

            
        }
        
        else if blue?.value(forKey: "color") as? String == "blue"{
            

            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect(x: UIScreen.main.bounds.width - 5, y: 0.0, width: 4.0, height: (cell?.frame.size.height)!)
            
            bottomBorder.backgroundColor = CGColor.init(srgbRed: 0, green: 0, blue: 255, alpha: 1)
            cell?.layer.addSublayer(bottomBorder)

            
        }
//        else{
//
//            let bottomBorder = CALayer()
//            bottomBorder.frame = CGRect(x: UIScreen.main.bounds.width - 5, y: 0.0, width: 4.0, height: (cell?.frame.size.height)!)
//
//            bottomBorder.backgroundColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
//            cell?.layer.addSublayer(bottomBorder)
//
//        }
        return cell!
    }
    
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       if (editingStyle == .delete) {
           // handle delete (by removing the data from your array and updating the tableview)
        
        
        
        
        var blue:NSManagedObject?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        request.returnsObjectsAsFaults = false
        do {
            
            
            var result = try context.fetch(request)
            blue = result[indexPath.row] as? NSManagedObject
            context.delete(blue!)
            result.remove(at: indexPath.row)
            notenote.deleteRows(at: [indexPath] , with: .fade)
            
            do{
                try context.save()
            }
            catch
            {
                
            }
        }
        catch {

                   print("Failed")
               }
   }
}
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var blue:NSManagedObject?
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        request.returnsObjectsAsFaults = false
        do {
            
            
            var result = try context.fetch(request)
            blue = result[indexPath.row] as? NSManagedObject
        }
        catch
        {
            
        }
        self.sentid = (blue?.value(forKey: "id") as? Int)!
        self.senttitle = blue?.value(forKey: "title") as! String
        self.sentdescription = blue?.value(forKey: "description") as! String
        performSegue(withIdentifier: "one", sender: self)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is secondViewController
        {
            let vc = secondViewController()
            //vc.text.text = self.senttitle
            //vc.detail!.text = self.sentdescription
            
        }
    }
}
