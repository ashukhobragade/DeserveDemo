//
//  DeserveDemoVC.swift
//  Deserve
//
//  Created by Ashish Khobragade on 07/06/21.
//

import UIKit

let searchUrl = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=2932ade8b209152a7cbb49b631c4f9b6&%20format=json&nojsoncallback=1&safe_search=1&text="

class DeserveDemoVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var nextPageToBeCalled = 2
    var searchQuery:String = ""
    
    var flickerImageDO:FlickerImage?{
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }
    

    func configureUI()  {
        collectionView.register(ImageCell.nib, forCellWithReuseIdentifier: ImageCell.identifier)
    }

}

// MARK: - Delegate & DataSource

extension DeserveDemoVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return flickerImageDO?.photos?.photo?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = cell as? ImageCell  else { print("ImageCell not found!!!"); return }
        
        guard let photo =  flickerImageDO?.photos?.photo else { return }
        
        let photoData = photo[indexPath.item]
        cell.photoDO = photoData
        
        if indexPath.item == (photo.count - 9) && nextPageToBeCalled > (flickerImageDO?.photos?.page ?? 0){
            
            getFlickerImages(searchQuery: searchQuery, pageNo: nextPageToBeCalled)
        }
    }
}

// MARK: - layout
extension DeserveDemoVC:UICollectionViewDelegateFlowLayout{
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        let width = (UIScreen.main.bounds.size.width - 40)/3
        
        return CGSize(width: width, height: width)
    }
}



// MARK: - API Calls

extension DeserveDemoVC{
    
    func getFlickerImages(searchQuery:String,pageNo:Int) {
     
        guard let url = URL(string: searchUrl + searchQuery + "&page=\(pageNo)") else { return }
        
        URLSession.shared.flickerImageTask(with: url) { flickerImage, response, error in
           
            if error == nil{
                
                if let flickerImage = flickerImage{
                
                    print("page No = \(flickerImage.photos?.page ?? 0)")

                    if flickerImage.photos?.page == 1{
                        self.flickerImageDO = flickerImage
                    }
                    else{
                        self.flickerImageDO?.photos?.page = flickerImage.photos?.page
                        self.flickerImageDO?.photos?.photo?.append(contentsOf: flickerImage.photos?.photo ?? [])
                    }
                    
                    self.nextPageToBeCalled = (flickerImage.photos?.page ?? 0) + 1
                }
            }
            else{
                print(error?.localizedDescription ?? "Some Error Occured")
            }
           
        }.resume()
    }
}

// MARK: - search bar

extension DeserveDemoVC:UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        self.flickerImageDO = nil
        self.collectionView.reloadData()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // searchBar.endEditing(true)
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
        
        if (searchBar.text?.count ?? 0) > 0{

            searchQuery = searchBar.text ?? ""

            self.getFlickerImages(searchQuery: searchQuery, pageNo: 1)
            self.searchBar.resignFirstResponder()
        }
        else{
                        
            let alert = UIAlertController(title: title, message: "PLEASE ENTER YOUR SEARCH QUERY", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title:"OKAY" , style: .default) { (action) in
                
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
    }
    
}
