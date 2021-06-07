//
//  ImageCell.swift
//  Deserve
//
//  Created by Ashish Khobragade on 07/06/21.
//

import UIKit

let DELEGATE : AppDelegate = UIApplication.shared.delegate as! AppDelegate

class ImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
  
    var photoDO:Photo?{
        didSet{
            configureUI()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.main)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configureUI()  {
        //http://farm{farm}.static.flickr.com/{server}/{id}_{secret}.jpg
        
        guard let photo = photoDO else { print("PhotoDO not found !!!"); return }
        
        if let farm = photo.farm,let server = photo.server,let photoId = photo.id,let secret = photo.secret, server.count > 1{
            
            let photoUrl = "http://farm\(farm).static.flickr.com/\(server)/\(photoId)_\(secret).jpg"
            
            if let image = DELEGATE.imageCache.object(forKey: photoUrl as NSString){

                DispatchQueue.main.async {
                    
                    self.imageView.image = image
                }
            }
            else{
                DELEGATE.downloadQueue.addOperation {
                    
                    ImageDownload.shared.download(photoUrl: photoUrl) { [self] image in
                        
                        DispatchQueue.main.async {
                            
                            self.imageView.image = image
                        }
                    }
                }
            }

        }
    }
}


class ImageDownload:Operation {
    
    static let shared = ImageDownload()
    
    func download(photoUrl:String,_ completion:@escaping (UIImage?)->() ) {
      
        guard let url = URL(string: photoUrl) else {
            DispatchQueue.main.async {
                print("No Url created !!!")
            }
            return
        }
       
        do {
            let imageData = try Data(contentsOf: url)
            
            guard let image = UIImage(data: imageData) else { return }
            
            DispatchQueue.main.async {
                DELEGATE.imageCache.setObject(image, forKey: NSString(string: photoUrl))
            }

            completion(image)
        }
        catch let error {
            DispatchQueue.main.async {
                print(error.localizedDescription)
            }
            completion(nil)
        }
    }
}

