

import UIKit
import CoreML
import Vision
import Social
import AudioToolbox
import AVFAudio

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var classificationResults : [VNClassificationObservation] = []
    var text = ""
    let imagePicker = UIImagePickerController()
    var audioPlayer : AVAudioPlayer?
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    func detect(image: CIImage) {
        
        // Load the ML model through its generated class
        guard let model = try? VNCoreMLModel(for: HandPoses_1().model) else {
            fatalError("can't load ML model")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                let topResult = results.first
                else {
                    fatalError("unexpected result type from VNCoreMLRequest")
            }
            
            if topResult.identifier.contains("Call") {
                DispatchQueue.main.async {
                    self.text = "Call"
                    self.navigationItem.title = "Call!"
                    
                    self.callTo(phoneNumber: "4793851212")

                }
            }
            else if topResult.identifier.contains("Palm") {
                DispatchQueue.main.async {
                    self.text = "Palm"
                    self.navigationItem.title = "Palm!"
                    
                    let scripts = ["Fortune in the Future", "Keeping Secrets", "Salt like Sugar", "Except for this One", "Hard work vs Laziness"]
//                    self.file = scripts.randomElement()!
                    
                    let pathToSound = Bundle.main.path(forResource: scripts.randomElement(), ofType: "mp3")!
                    let url = URL(fileURLWithPath: pathToSound)
                    
                    do {
                      self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                      self.audioPlayer?.play()
                    }
                    catch {
                    print(error)
                    }
                }
            } else if topResult.identifier.contains("Rock") {
                DispatchQueue.main.async {
                    self.text = "Rock"
                    self.navigationItem.title = "Rock!"
                    let pathToSound = Bundle.main.path(forResource: "Will Rock", ofType: "mp3")!
                    let url = URL(fileURLWithPath: pathToSound)
                    
                    do {
                      self.audioPlayer = try AVAudioPlayer(contentsOf: url)
                      self.audioPlayer?.play()
                    }
                    catch {
                    print(error)
                    }

                }
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            imagePicker.dismiss(animated: true, completion: nil)
            guard let ciImage = CIImage(image: image) else {
                fatalError("couldn't convert uiimage to CIImage")
            }
            detect(image: ciImage)
        }
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSecond", sender: self)
    }
    
    func callTo(phoneNumber: String) -> Bool {
        if !phoneNumber.isEmpty {
            if let url = URL(string: "tel://" + phoneNumber) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    return true
                }
            }
        }

        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToSecond" {
            let destinationVC = segue.destination as! SecondViewController
            destinationVC.text = text
        }
    }

}

