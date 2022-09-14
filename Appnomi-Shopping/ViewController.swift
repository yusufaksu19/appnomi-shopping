//
//  ViewController.swift
//  Appnomi-Shopping
//
//  Created by Yusuf Aksu on 9.09.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    @IBOutlet weak var categoryTableView: UITableView!
    
    var categoryList = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        
        getCategories()
    }
    
    func getCategories(){
        let url = "https://api.shopiroller.com/v2.0/categories"
        let headers = [
                "Api-Key":"xXspnfUxPzOGKNu90bFAjlOTnMLpN8veiixvEFXUw9I=",
                "Alias-Key" : "AtS1aPFxlIdVLth6ee2SEETlRxk=",
                "Content-Type": "application/json",
                "Accept-Language": "en"
            ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON{
            response in
//            dump(response)
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(CategoryResponse.self, from: data)
                    
                    
                    if let resultCategoryList = response.data {
                        
                        self.categoryList = resultCategoryList
                    }
                    DispatchQueue.main.async {
                        self.categoryTableView.reloadData()
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        
        let followingVC = segue.destination as! ProductViewController
        
        followingVC.category = categoryList[index!]
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categoryList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCellTableViewCell
        
        cell.labelCategoryName.text = category.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toProduct", sender: indexPath.row)
    }
}

