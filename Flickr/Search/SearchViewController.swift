//
//  ViewController.swift
//  Flickr
//
//  Created by lawliet on 2020/9/30.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController {

    @IBOutlet var searchAndPageTextField: [UITextField]!
    @IBOutlet weak var searchButton: UIButton!
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func searchAction(_ sender: Any) {
        searchAndPageTextField.forEach { (textField) in
            textField.resignFirstResponder()
        }
        let text = searchAndPageTextField[0].text ?? ""
        let perPage = searchAndPageTextField[1].text ?? "10"
        guard let resultViewController = storyboard?.instantiateViewController(identifier: "ResultViewController", creator: { (coder) -> ResultViewController? in
            let searchModel = SearchModel(searchText: text, perPage: perPage, page: nil)
            return ResultViewController(coder: coder, searchModel: searchModel)
        }) else { return }
        show(resultViewController, sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
      }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        var change = true
        searchAndPageTextField.forEach { (textField) in
            change = viewModel.changeTextField(text: textField.text, bool: change)
        }
        guard change == true else {
            searchButton.backgroundColor = .systemGray4
            searchButton.isUserInteractionEnabled = false
            return
        }
        searchButton.backgroundColor = .systemBlue
        searchButton.isUserInteractionEnabled = true
    }
}
