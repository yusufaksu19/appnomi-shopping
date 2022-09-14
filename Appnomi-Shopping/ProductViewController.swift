//
//  ProductViewController.swift
//  Appnomi-Shopping
//
//  Created by Yusuf Aksu on 9.09.2022.
//

import UIKit
import Alamofire

class ProductViewController: UIViewController {

    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var productsList = [Product]()
    
    var category: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let design: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let width = self.productCollectionView.frame.size.width
        
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let cellWidth = (width - 30)/2
        
        design.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.7)
        
        design.minimumInteritemSpacing = 10
        design.minimumLineSpacing = 10
        
        productCollectionView.collectionViewLayout = design
        
        if let c = category {
            if let cid = c.categoryId {
                navigationItem.title = c.name
                productsByCategoryID(category_id: cid)

            }
}
        
    }
    
    func productsByCategoryID(category_id:String){
        let url = "https://api.shopiroller.com/v2.0/products/advanced-filtered?categoryId=\(category_id)" 
        let headers = [
                "Api-Key":"xXspnfUxPzOGKNu90bFAjlOTnMLpN8veiixvEFXUw9I=",
                "Alias-Key" : "AtS1aPFxlIdVLth6ee2SEETlRxk=",
                "Content-Type": "application/json",
                "Accept-Language": "en"
            ]
        
        Alamofire.request(url, method: .get, headers: headers).responseJSON{
            response in
            dump(response)
            if let data = response.data {
                do {
                    let response = try JSONDecoder().decode(ProductResponse.self, from: data)
                    
                    
                    if let resultProductList = response.data {
                        
                        self.productsList = resultProductList
                    }
                    DispatchQueue.main.async {
                        self.productCollectionView.reloadData()
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let index = sender as? Int {
            let followingVC = segue.destination as! DetailViewController
            
            followingVC.product = productsList[index]
        }
    }
    
}

extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return productsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let product = productsList[indexPath.row]

        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "ProductCellCollectionViewCell", for: indexPath) as! ProductCellCollectionViewCell
       
        cell.labelProductName.text = product.title
        let priceString = String(format: "%.2f", product.price!) + " " + product.currency!

    
        
        if let campaignP = product.campaignPrice {
            cell.labelProductPrice.attributedText = priceString.strikeThrough()
            cell.labelProductCampaignPrice.text = String(format: "%.2f", campaignP) + " " + product.currency!

        } else {
            cell.labelProductPrice.text = priceString
            cell.labelProductCampaignPrice.isHidden = true
        }
        
        if let url = URL(string: product.images![0].t!){
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    cell.imageViewProductPicture.image = UIImage(data: data!)
                }

            }
            
        }
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    
    
        
}

extension String {
    func strikeThrough() -> NSAttributedString {
        let attributeString =  NSMutableAttributedString(string: self)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0,attributeString.length))
        return attributeString
    }
}
