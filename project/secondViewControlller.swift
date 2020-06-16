//
//  secondViewControlller.swift
//  project
//
//  Created by Kunwardeep Singh on 2020-06-10.
//  Copyright © 2020 user174655. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class secondViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate{
    
    @IBOutlet weak var record: UIButton!
    @IBOutlet weak var text: UITextField!
    @IBOutlet weak var detail: UITextView!
    var counter = 0
   var recordButton: UIButton!
   var recordingSession: AVAudioSession!
   var audioRecorder: AVAudioRecorder!
    var audioFilename: URL!
    
    override func viewDidLoad() {
        recordingSession = AVAudioSession.sharedInstance()
        

        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            // failed to record!
        }
    
    super.viewDidLoad()
    }
  
        
    @IBAction func addNote(_ sender: Any) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
          let context = appdelegate.persistentContainer.viewContext
          let newNote = NSEntityDescription.insertNewObject(forEntityName: "Notes", into: context)
          
          let date = NSDate()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "y-MM-dd H:m:ss.SSSS"

          let finalDate = dateFormatter.string(from: date as Date)
          //print(finalDate)

          
          newNote.setValue(self.text.text, forKey: "title")
          newNote.setValue(self.detail.text, forKey: "descriptions")
          newNote.setValue(counter, forKey: "id")
        newNote.setValue(audioFilename, forKey: "audio")
          counter = counter + 1;
          newNote.setValue(finalDate, forKey: "date")
          newNote.setValue(selectedColor, forKey: "color")
          do{
              try context.save()
              print("saved")
            let alertController = UIAlertController(title: "Note Saved", message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                //self.performSegue(withIdentifier: "one", sender: nil)
                _ = self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)

          }
          catch
          {
              print("not saved:")
          }
          //performSegue(withIdentifier: "back", sender: self)
        
    }
    
   
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var textBox: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    var selectedColor:String = ""
    
    var list = ["","red", "blue", "green"]

        public func numberOfComponents(in pickerView: UIPickerView) -> Int{
            return 1
        }

        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

            return list.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

            self.view.endEditing(true)
            return list[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
            //self.label.text = list[row]
            selectedColor = list[row]
            
            if list[row] == "red"{
                
                self.label.backgroundColor = UIColor.red

            }else if (list[row] == "blue"){
                
                self.label.backgroundColor = UIColor.blue
                
            }else if(list[row] == "green"){
                
                self.label.backgroundColor = UIColor.green

            }else
            {
                self.label.backgroundColor = UIColor.white
            }
        
            print(list[row])
            self.picker.isHidden = false
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {

            if textField == self.textBox {
                self.picker.isHidden = false
                //if you don't want the users to se the keyboard type:

                textField.endEditing(true)
            }
        }
    
        func loadRecordingUI() {
            recordButton = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 64))
            recordButton.setTitle("Tap to Record", for: .normal)
            recordButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
            recordButton.backgroundColor = UIColor.red
            recordButton.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
            view.addSubview(recordButton)
        }
    
    
    func startRecording() {
         audioFilename = getDocumentsDirectory().appendingPathComponent("blabla.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            recordButton.setTitle("Tap to Stop", for: .normal)
        } catch {
            finishRecording(success: false)
        }
    }
 
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            recordButton.setTitle("Tap to Re-record", for: .normal)
        } else {
            recordButton.setTitle("Tap to Record", for: .normal)
            // recording failed :(
        }
    }
    
    
    @objc func recordTapped() {
        if audioRecorder == nil {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
   
    @IBAction func play(_ sender: Any) {
        do{
            let soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
            soundPlayer.delegate = self
            soundPlayer.prepareToPlay()
            soundPlayer.volume = 1.0
            soundPlayer.play()
        }
        catch
        {
            print("cannot play")
        }
        
    }
    
}

