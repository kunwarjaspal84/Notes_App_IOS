//
//  ViewController.swift
//  project
//
//  Created by user174655 on 6/8/20.
//  Copyright © 2020 user174655. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class ViewController: UIViewController,UIImagePickerControllerDelegate,CLLocationManagerDelegate, UINavigationControllerDelegate {

    var context:NSManagedObjectContext!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let locationManager = CLLocationManager()
    
    //var oneNmae:String = "jj"

    
    
    //override var systemMinimumLayoutMargins: NSDirectionalEdgeInsets

    @IBOutlet weak var noteName: UITextField!
       
    @IBOutlet weak var descriptions: UITextView!
    
    @IBOutlet weak var imagePickButton: UIImageView!
    
    @IBOutlet weak var imageWhichPicked: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = appDelegate.persistentContainer.viewContext
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

// For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
            
        
    }
    
    
    @IBOutlet weak var labelLat: UILabel!
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        let geoCoder = CLGeocoder()
        
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)

        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
             // Place details
        var placeMark: CLPlacemark!
        placeMark = placemarks?[0]

        // Location name
            if let locationName = placeMark.location {
                
            self.labelLat.text = "\(locValue.latitude)"

                
            print(locationName)
        }
        // Street address
        if let street = placeMark.thoroughfare {
            print(street)
        }
        // City
        if let city = placeMark.subAdministrativeArea {
            print(city)
        }
        // Zip code
        if let zip = placeMark.isoCountryCode {
            print(zip)
        }
        // Country
        if let country = placeMark.country {
            print(country)
        }
        })
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func saveData(UserDBObj:NSManagedObject)
        
    {
        UserDBObj.setValue(descriptions.text, forKey: "descriptions")
        UserDBObj.setValue(noteName.text, forKey: "title")
        //UserDBObj.setValue(oneNmae, forKey: "longitude")
        //UserDBObj.setValue(noteName.text, forKey: "latitude")
        UserDBObj.setValue(1, forKey: "id")

        print("Storing Data..")
        do {
            try context.save()
            print("Stored Data..")
           
            
        } catch {
            print("Storing data Failed")
        }

    }
    //@IBAction func imagePickButton(_ sender: Any) {
        
      //  imagePicker.delegate = self
        
        //imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
        //self.present(imagePicker,animated:true,completion:nil)
        
    //}
        
        


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            imageWhichPicked.image = image
        }
        
        dismiss(animated: true,completion: nil)
    }
    
   
    @IBAction func saveButton(_ sender: Any) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        saveData(UserDBObj:newUser)
    
        
    }
    
    @IBAction func edit(_ sender: Any) {
    }
    
    
    @IBAction func imagePickButton(_ sender: UIButton)
        
        
    {
    //self.btnEdit.setTitleColor(UIColor.white, for: .normal)
    //self.btnEdit.isUserInteractionEnabled = true
    
    imagePicker.delegate = self

    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
        self.openCamera()
    }))

    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
        self.openGallary()
    }))

    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        switch UIDevice.current.userInterfaceIdiom {

    case .pad:
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.bounds
        alert.popoverPresentationController?.permittedArrowDirections = .up
    default:
        break
    }

    self.present(alert, animated: true, completion: nil)
}

func openCamera()
{
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.camera
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    else
    {
        let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

func openGallary()
{
    imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
    imagePicker.allowsEditing = true
    self.present(imagePicker, animated: true, completion: nil)
        
}
    
}

