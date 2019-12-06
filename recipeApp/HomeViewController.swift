//
//  HomeViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import Speech

class HomeViewController: UIViewController, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    @IBOutlet weak var ingredientInput: UITextField!
    @IBOutlet weak var detectedVoiceText: UILabel!
    
    @IBAction func micButtonPressed(_ sender: UIButton) {
        self.recordAndRecognizeSpeech()
    }
    
    @IBAction func stopRecording(_ sender: UIButton) {
        audioEngine.stop()
    }
  
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ingredientInput.delegate = self
        self.ingredientInput.text = "sugar"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipes" {
            let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
            showRecipes.query = self.ingredientInput.text
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientInput.resignFirstResponder()
        return true
    }
    
    
    //SPEECH RECOGNITION
    func recordAndRecognizeSpeech() {
        //initializing audioEngine
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
            buffer, _ in self.request.append(buffer) 
        }
        
        //starting up audioEngine
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            return print(error)
        }
        
        //Ensuring that the Recognizer is available
        guard let myRecognizer = SFSpeechRecognizer() else{
            //A recognizer not supported for current locale
            return
        }
        if !myRecognizer.isAvailable{
            //A recognizer is not available right now
            return
        }
        
        //Actually dealing with recognition and transcribing
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.detectedVoiceText.text = bestString
            
            } else if let error = error{
                print(error)
            }
        })
    }
}
