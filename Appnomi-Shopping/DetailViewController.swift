//
//  DetailViewController.swift
//  Appnomi-Shopping
//
//  Created by Yusuf Aksu on 9.09.2022.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    @IBOutlet weak var productDetailPicture: UIImageView!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProductPrice: UILabel!
    @IBOutlet weak var labelProductPriceDiscounted: UILabel!
    @IBOutlet weak var labelProductInformation: UILabel!
    
    var product:Product?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let p = product {
            navigationItem.title = p.title
             
        }

        guard let id = self.product?.id else {
            return
        }
        
        productDetailByProductID(product_id: id)
        
    }
    
    func productDetailByProductID(product_id:String){
        let url = "https://api.shopiroller.com/v2.0/products/\(product_id)"
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
                    let response = try JSONDecoder().decode(DetailResponse.self, from: data)
                    
                    
                    if let productDetail = response.data {
                        
                        self.labelProductName.text = productDetail.title
                        let priceString = String(format: "%.2f", productDetail.price!) + " " + productDetail.currency!
                        
                        
                        
                        if let campaignP = productDetail.campaignPrice {
                            self.labelProductPrice.attributedText = priceString.strikeThrough()
                            self.labelProductPriceDiscounted.text = String(format: "%.2f", campaignP) + " " + productDetail.currency!
                            
                        } else {
                            self.labelProductPrice.text = priceString
                            self.labelProductPriceDiscounted.isHidden = true
                        }
                        
                        
                        self.labelProductInformation.attributedText = productDetail.description!.htmlToAttributedString
                        
                        if let url = URL(string: productDetail.images[0].t!){
                            DispatchQueue.global().async {
                                let data = try? Data(contentsOf: url)
                                
                                DispatchQueue.main.async {
                                    self.productDetailPicture.image = UIImage(data: data!)
                                }
                                
                            }
                            
                        }
                        
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}
