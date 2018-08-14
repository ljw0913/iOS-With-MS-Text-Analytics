//
//  ViewController.swift
//  MyFirstTextAnalyticsApp
//
//  Created by Lee Jia Wei on 13/8/18.
//  Copyright © 2018 Lee Jia Wei. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire


class ViewController: UIViewController {

    
    @IBOutlet weak var inputTxtView: UITextView!
    @IBOutlet weak var outputTxtView: UITextView!
    
    let apiKey = "<REPLACE_WITH_YOUR_API_KEY_HERE>"
    let apiEndPoint = "<REPLACE_WITH_YOUR_API_ENDPOINT_HERE>" //https://southeastasia.api.cognitive.microsoft.com/text/analytics/v2.0/keyPhrases
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    @IBAction func GetKeyPhrasesTapped(_ sender: Any) {
        var results = [String]()
        var header = [String : String]()
        header["Ocp-Apim-Subscription-Key"] = apiKey
        
        let bodyRequest: [String:Any] = [
            "documents": [
                [
                    "language": "en",
                    "id": "1",
                    "text": "\(inputTxtView.text)"
                ]
            ]
        ]
        if inputTxtView.text != ""
        {
            let request = Alamofire.request(apiEndPoint, method: .post, parameters: bodyRequest, encoding: JSONEncoding.default, headers: header)
            
            request.responseJSON { (response) in
                if((response.result.value) != nil)
                {
                    let swiftyJsonVar = JSON(response.result.value!)
                    print(swiftyJsonVar)
                    let keyPhrases = swiftyJsonVar["documents"][0]["keyPhrases"]
                    
                    for phrase in keyPhrases.arrayValue
                    {
                        results.append(phrase.stringValue)
                    }
                }
                DispatchQueue.main.async {
                    print(results.minimalDescription)
                    self.outputTxtView.text = results.minimalDescription
                }
            }
        }
    }
}

extension Sequence {
    var minimalDescription: String {
        return map { "\($0)" }.joined(separator: ", ")
    }
}

