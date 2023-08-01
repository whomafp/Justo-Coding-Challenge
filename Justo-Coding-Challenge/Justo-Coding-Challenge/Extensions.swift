//
//  Extensions.swift
//  Justo-Coding-Challenge
//
//  Created by Miguel Fonseca on 28/07/23.
//

import Foundation
import UIKit
import MapKit

let imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - UIColor extension
extension UIColor {
    /// This set custom color to UIColor types in current bundle.
    static let mainColor = UIColor(named: "mainColor")
    static let background = UIColor(named: "background")
    static let text = UIColor(named: "text")
}
// MARK: - UIImageView extension
extension UIImageView{
    /// This loadThumbnail function is used to download thumbnail image using urlString
    /// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
    func loadThumbnail(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            DispatchQueue.main.async {
                self.image = imageFromCache as? UIImage
            }
            return
        }
        Networking.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let imageToCache = UIImage(data: data) else { return }
                imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                self.image = UIImage(data: data)
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.image = UIImage()
                }
            }
        }
    }
    /// Create custom rounded imageView.
    static func createUIImageView(_ named: String? = nil, _ sizeView: CGSize = .zero, isIcon: Bool? = false) -> UIImageView {
        let image = UIImageView()
        if let named = named {
            image.image = UIImage(named: named)
        }
        image.size(size: sizeView)
        if let isIcon = isIcon, isIcon {
            image.alpha = 0
        }
        image.clipsToBounds = true
        return image
    }
}
// MARK: - UICollectionViewCell extension
extension UICollectionViewCell {
    /// Add shadow to collectionViewCell.
    func shadowDecorate() {
        let radius: CGFloat = 10
        contentView.layer.cornerRadius = radius
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.mainColor?.cgColor
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.5
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
        layer.cornerRadius = radius
    }
}
// MARK: - MKMapView extension
extension MKMapView {
    /// Focus on mark in current map.
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
// MARK: - UILabel extension
extension UILabel {
    /// Set custom label to view.
    static func textLabel(size: CGFloat, textColor: UIColor = .white, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Medium Extended", size: size)
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
    /// Set custom label to view.
    static func textBoldLabel(size: CGFloat, textColor: UIColor = .white, numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica Neue Medium Extended", size: size)
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
}
// MARK: - UIView extension
extension UIView {
    /// Set constraints to fill view.
    func fillView(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
    }
    /// Set value for size of width and height of view.
    func size(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    // Set constraints to fill view in superview with no padding.
    func fillSuperView(padding: UIEdgeInsets = .zero) {
        fillView(
            top: superview?.topAnchor,
            leading: superview?.leadingAnchor,
            trailing: superview?.trailingAnchor,
            bottom: superview?.bottomAnchor,
            padding: padding
        )
    }
    // add shadow to view.
    func addShadow() {
        self.layer.shadowColor = UIColor.text?.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.masksToBounds = false
    }
}
