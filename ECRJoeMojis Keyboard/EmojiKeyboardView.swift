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
        imageView?.contentMode = .scaleAspectFit
        
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
    case emoji
    case gif
    case alphanumeric
}

class EmojiKeyboardView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    // @IBOutlet weak var btnEmoji: UIButton!
    // @IBOutlet weak var lblSelectedKeyboardType: UILabel!
    
    //Local Variables
    
    var dataEmoji = [UIImage]()
    var currentKeyboard = ECRJEmojiKeyboardType.emoji
    var delegate: ECRJEmojiKeyboardDelegate?
    var previouseSelectedButton:UIButton?
    
    override func awakeFromNib() {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        for index in 1...32 {
            if let img = UIImage(named: "emoji-\(index)") {
                dataEmoji.append(img)
            }
        }
        
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 8, bottom: 20, right: 8)
    }
    
    //Collection view delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataEmoji.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        cell.imageView?.image = dataEmoji[(indexPath as NSIndexPath).item]
        
        return cell
    }
    
    //Verticale space
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout:UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        
        return 10.0
    }
    
    //Horizontal space
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat{
        
        return 5.0
    }
    
    //Cell size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 45, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        let pbWrapped: UIPasteboard? = UIPasteboard.general
        
        if (isOpenAccessGranted())
        {if let pb = pbWrapped {
            print("ACCESS : ON")
            if  currentKeyboard == ECRJEmojiKeyboardType.emoji {
                if let data = UIImagePNGRepresentation(dataEmoji[(indexPath as NSIndexPath).row]) {
                    pb.setData(data, forPasteboardType: "public.png")
                    
                    self.makeToast(pasteMessage, duration: 3.0, position: .center)
                }
            }
            }
        }
        else{
            print("ACCESS : OFF")
            var style = ToastStyle()
            style.messageColor = UIColor.red
            style.messageAlignment = .center
            //style.backgroundColor = UIColor.whiteColor()
            
            self.makeToast("To really enjoy the keyboard, please Allow Full Access in the settings application.", duration: 8.0, position: .center, title: nil, image: UIImage(named: "toast.png"), style: style, completion: nil)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if currentKeyboard == .emoji {
            cell.transform = CGAffineTransform.identity.scaledBy(x: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 0.3, delay: 0.3, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.8, options: .curveEaseOut, animations: {
                cell.transform =
                    CGAffineTransform.identity.scaledBy(x: 1, y: 1)
                
            }) { (_) in
                
            }
        }
    }
    @IBAction func btnSharePressed(_ sender: AnyObject) {
        delegate?.btnSharePressed()
    }
    
    @IBAction func btnDeletePressed(_ sender: AnyObject) {
        delegate?.btnDeletePressed()
    }
    @IBAction func btnAlphaNumericKeyboardPressed(_ sender: AnyObject) {
        delegate?.btnAlphaNumericKeyboardPressed()
    }
    
    @IBAction func btnNextKeyboardPressed(_ sender: AnyObject) {
        delegate?.btnNextKeyboardPressed()
    }
    
    func isOpenAccessGranted() -> Bool {
        //      return UIPasteboard.general.isKind(of: UIPasteboard.self)
        if #available(iOSApplicationExtension 10.0, *) {
            UIPasteboard.general.string = "TEST"
            
            if UIPasteboard.general.hasStrings {
                // Enable string-related control...
                UIPasteboard.general.string = ""
                return  true
            }
            else
            {
                UIPasteboard.general.string = ""
                return  false
            }
        } else {
            // Fallback on earlier versions
            if UIPasteboard.general.isKind(of: UIPasteboard.self) {
                return true
            }else
            {
                return false
            }
            
        }
        
    }
}


