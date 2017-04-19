//
//  CardTableViewCell.swift
//  CardMagusKit
//
//  Created by Jovito Royeca on 15/04/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

public let kCardTableViewCellHeight = CGFloat(88)

open class CardTableViewCell: UITableViewCell {

    // Variables
    open var card:CMCard?
    let preEightEditionFont      = UIFont(name: "Magic:the Gathering", size: 17.0)
    let preEightEditionFontSmall = UIFont(name: "Magic:the Gathering", size: 14.0)
    let eightEditionFont         = UIFont(name: "Matrix-Bold", size: 17.0)
    let eightEditionFontSmall    = UIFont(name: "Matrix-Bold", size: 14.0)
    let magic2015Font            = UIFont(name: "Beleren", size: 17.0)
    let magic2015FontSmall       = UIFont(name: "Beleren", size: 14.0)
    
    // MARK: Outlets
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var castingCostView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var rarityImage: UIImageView!
    
    @IBOutlet weak var setLabel: UILabel!
    
    // MARK: Overrides
    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        nameLabel.adjustsFontSizeToFitWidth = true
        typeLabel.adjustsFontSizeToFitWidth = true
        setLabel.adjustsFontSizeToFitWidth = true
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override open func prepareForReuse() {
        thumbnailImage.image = nil
        nameLabel.text = nil
        for c in castingCostView.subviews {
            c.removeFromSuperview()
        }
        typeLabel.text = nil
        rarityImage.image = nil
        setLabel.text = nil
    }
    
    // MARK: Custom methods
    open func updateDataDisplay() {
        if let card = card {
            // thumbnail image
            thumbnailImage.image = CardMagus.sharedInstance.imageFromCache("/images/cardback-crop-hq.jpg")
            CardMagus.sharedInstance.downloadCardImage(card, cropImage: true, completion: { (c: CMCard, image: UIImage?, croppedImage: UIImage?, error: NSError?) in
                if error == nil {
                    if self.card == c {
                        UIView.transition(with: self.thumbnailImage,
                                          duration: 1.0,
                                          options: .transitionCrossDissolve,
                                          animations: {
                                              self.thumbnailImage.image = croppedImage
                                          },
                                          completion: nil)
                    }
                }
            })
            
            // card name
            nameLabel.text = card.name
            if let releaseDate = card.set!.releaseDate {
                let isModern = CardMagus.sharedInstance.isModern(card)
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                if let m15Date = formatter.date(from: "2014-07-18"),
                    let setReleaseDate = formatter.date(from: releaseDate) {
                    if setReleaseDate.compare(m15Date) == .orderedSame ||
                        setReleaseDate.compare(m15Date) == .orderedDescending {
                        nameLabel.font = magic2015Font
                        typeLabel.font = magic2015FontSmall
                        setLabel.font = magic2015FontSmall
                    } else {
                        nameLabel.font = isModern ? eightEditionFont : preEightEditionFont
                        typeLabel.font = isModern ? eightEditionFontSmall : preEightEditionFontSmall
                        setLabel.font = isModern ? eightEditionFontSmall : preEightEditionFontSmall
                    }
                }
            }
            
            // casting cost
            if let manaCost = card.manaCost {
                let mc = manaCost.replacingOccurrences(of: "{", with: "")
                                 .replacingOccurrences(of: "}", with: " ")
                                 .replacingOccurrences(of: "/", with: "")
                let manaArray = mc.components(separatedBy: " ")
                
                var x = 0
                let y = 0
                var width = 20
                let height = 20
                var imageName = "32.png"
                
                for mana in manaArray {
                    if mana.characters.count == 0 {
                        continue
                    }
                    
                    if mana == "1000000" {
                        width = 20 * 3
                        imageName = "96.png"
                    }
                    
                    var image = CardMagus.sharedInstance.imageFromCache("/images/mana/\(mana)/\(imageName)")
                    
                    // fix for dual manas
                    if image == nil {
                        if mana.characters.count > 1 {
                            let reversedMana = String(mana.characters.reversed())
                            image = CardMagus.sharedInstance.imageFromCache("/images/mana/\(reversedMana)/\(imageName)")
                        }
                    }
                    
                    let imageView = UIImageView(frame: CGRect(x: x, y: y, width: width, height: height))
                    imageView.image = image
                    imageView.contentMode = .scaleAspectFit
                    castingCostView.addSubview(imageView)
                    
                    x += width
                }
            }
            
            // type
            var typePowerToughness = ""
            if let type = card.type_ {
                typePowerToughness = type.name!
            }
            if let power = card.power,
                let toughness = card.toughness {
                typePowerToughness += " (\(power)/\(toughness))"
            }
            typeLabel.text = typePowerToughness
            
            // rarity and set
            if let rarity = card.rarity_,
                let set = card.set {
                let index = rarity.name!.index(rarity.name!.startIndex, offsetBy: 1)
                var prefix = rarity.name!.substring(to: index)
                if rarity.name == "Basic Land" {
                    prefix = "C"
                }
                
                rarityImage.image = CardMagus.sharedInstance.imageFromCache("/images/set/\(set.code!)/\(prefix)/32.png")
                setLabel.text = set.name
            }
        }
    }
}