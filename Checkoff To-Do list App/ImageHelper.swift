//
//  ImageHelper.swift
//  Checkoff To-Do list App
//
//  Created by Tanner Rozier on 8/4/22.
//

import UIKit
import PhotosUI
import Firebase
import SDWebImage
import MapKit

class ImageAssetHelper {
    
//    class func fetchImageWithAssetID(assetID: String, size: CGSize, completion: @escaping (UIImage?) -> ()) {
//        let requestOptions = PHImageRequestOptions()
//        requestOptions.deliveryMode = .highQualityFormat
//        requestOptions.resizeMode = .fast
//        requestOptions.isSynchronous = false
//        requestOptions.isNetworkAccessAllowed = true
//        requestOptions.version = .current
//
//        let assetFetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil)
//        guard let asset = assetFetchResult.firstObject else {
//            return
//        }
//
//        PHImageManager.default().requestImage(for: asset,
//                                              targetSize: size, contentMode: .aspectFill, options: requestOptions,
//                                              resultHandler: { image, info in
//
//                                                if let isDegraded = info?[PHImageResultIsDegradedKey] as? NSNumber, isDegraded.boolValue {
//                                                    return
//                                                }
//
//                                                completion(image)
//
//                                              })
//    }
    
//    @discardableResult
//    class func downloadImage(myImage: MyImage, overwriteCache: Bool = false, completion: @escaping (UIImage?) -> ()) -> Bool {
//        if let image = SDImageCache.shared.imageFromCache(forKey: myImage.imagePath), !overwriteCache {
//            completion(image)
//            return false
//        } else {
//            let ref = Storage.storage().reference().child(myImage.imagePath)
//            ref.getData(maxSize: 1024 * 1024 * 4) { data, error in
//                if let error = error {
//                    print(error)
//                    completion(nil)
//                } else {
//                    if let data = data, let image = UIImage(data: data) {
//                        SDImageCache.shared.storeImageData(toDisk: data, forKey: myImage.imagePath)
//                        completion(image)
//                    }
//                }
//            }
//            return true
//        }
//    }
    
    class func downloadImage(imageURL: String, overwriteCache: Bool = false, completion: @escaping (UIImage?) -> ()) {
        if let image = SDImageCache.shared.imageFromCache(forKey: imageURL), !overwriteCache {
            completion(image)
        } else {
            let ref = Storage.storage().reference().child(imageURL)
            ref.getData(maxSize: 1024 * 1024 * 4) { data, error in
                if let error = error {
                    print(error)
                    completion(nil)
                } else {
                    if let data = data, let image = UIImage(data: data) {
                        SDImageCache.shared.storeImageData(toDisk: data, forKey: imageURL)
                        completion(image)
                    }
                }
            }
        }
    }
    
    class func clearImage(imageURL: String) {
        SDImageCache.shared.removeImageFromDisk(forKey: imageURL)
        SDImageCache.shared.removeImageFromMemory(forKey: imageURL)
    }
    
//    class func downloadImageData(myImage: MyImage, completion: @escaping (Data?) -> ()) {
//        if let image = SDImageCache.shared.imageFromCache(forKey: myImage.imagePath) {
//            completion(image.jpegData(compressionQuality: 1))
//        } else {
//            let ref = Storage.storage().reference().child(myImage.imagePath)
//            ref.getData(maxSize: 1024 * 1024 * 4) { data, error in
//                if let error = error {
//                    print(error)
//                    completion(nil)
//                } else {
//                    completion(data)
//                }
//            }
//        }
//    }
    

}
