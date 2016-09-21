//
//  EmojiKeyboardView.swift
//  ECRJoeMojis Keyboard
//
//  Created by webwerks1 on 8/23/16.
//  Copyright © 2016 ECRJoeMojis. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        imageView?.contentMode = .ScaleAspectFit
        
        self.addSubview(imageView!)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

protocol ECRJEmojiKeyboardDelegate {
    func btnNextKeyboardPressed()
    func btnAlphaNumericKeyboardPressed()
    func btnDeletePressed()
    func btnSharePressed()
}

enum ECRJEmojiKeyboardType {
    case Emoji
    case Gif
    case Alphanumeric
}

class EmojiKeyboardView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    //Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
   // @IBOutlet weak var btnEmoji: UIButton!
   // @IBOutlet weak var lblSelectedKeyboardType: UILabel!
    
    //Local Variables
    
    var dataEmoji = [UIImage]()
    var currentKeyboard = ECRJEmojiKeyboardType.Emoji
    var delegate: ECRJEmojiKeyboardDelegate?
    var previouseSelectedButton:UIButton?
    
    override func awakeFromNib() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
       
        for index in 1...25 {
            if let img = UIImage(named: "emoji-\(index)") {
                dataEmoji.append(img)
            }
        }

        collectionView.registerClass(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8)
    }
    
    //Collection view delegate
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataEmoji.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomCell", forIndexPath: indexPath) as! CustomCell
        
       cell.imageView?.image = dataEmoji[indexPath.item]
        
        return cell
    }
    
    //Verticale space
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 10.0
    }
    
    //Horizontal space
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        
        return 5.0
    }
    
    //Cell size
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(45, 40)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        
        let pbWrapped: UIPasteboard? = UIPasteboard.generalPasteboard()
        
        if let pb = pbWrapped {
            if  currentKeyboard == ECRJEmojiKeyboardType.Emoji {
                if let data = UIImagePNGRepresentation(dataEmoji[indexPath.row]) {
                    pb.setData(data, forPasteboardType: "public.png")
                    
                      self.makeToast(pasteMessage, duration: 3.0, position: .Center)
                }
            }
            
        } else {
            var style = ToastStyle()
            style.messageColor = UIColor.redColor()
            style.messageAlignment = .Center
            //style.backgroundColor = UIColor.whiteColor()
            
            self.makeToast("To really enjoy the keyboard, please Allow Full Access in the settings application.", duration: 8.0, position: .Center, title: nil, image: UIImage(named: "toast.png"), style: style, completion: nil)
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        if currentKeyboard == .Emoji {
            cell.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5)
            
            UIView.animateWithDuration(0.3, delay: 0.3, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: .CurveEaseOut, animations: {
                cell.transform =
                    CGAffineTransformScale(CGAffineTransformIdentity, 1, 1)
                
            }) { (_) in
      
            }
        }
    }
    @IBAction func btnSharePressed(sender: AnyObject) {
        delegate?.btnSharePressed()
    }
    
    @IBAction func btnDeletePressed(sender: AnyObject) {
        delegate?.btnDeletePressed()
    }
    @IBAction func btnAlphaNumericKeyboardPressed(sender: AnyObject) {
        delegate?.btnAlphaNumericKeyboardPressed()
    }
    
    @IBAction func btnNextKeyboardPressed(sender: AnyObject) {
        delegate?.btnNextKeyboardPressed()
    }
    
    func isOpenAccessGranted() -> Bool {
        return UIPasteboard.generalPasteboard().isKindOfClass(UIPasteboard)
    }
}


