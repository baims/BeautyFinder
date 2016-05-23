//
//  BAOrderView.swift
//  CartForBeautyFinder
//
//  Created by Bader Alrshaid on 5/17/16.
//  Copyright © 2016 Bader Alrshaid. All rights reserved.
//

import UIKit
import PureLayout
import Kingfisher

class BAOrderView: UIView {

    var orderData : BAOrderData!

    init(frame: CGRect, withOrderData orderData: BAOrderData)
    {
        super.init(frame: frame)
        
        self.orderData = orderData
        
        backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        
        /*** Title label ***/
        let subcategoryNameLabel = UILabel()
        subcategoryNameLabel.text = self.orderData.subcategoryName
        subcategoryNameLabel.font = UIFont(name: "MuseoSans-500", size: 18)
        subcategoryNameLabel.sizeToFit()
        subcategoryNameLabel.textColor = UIColor(white: 0.1, alpha: 1)
        addSubview(subcategoryNameLabel)
        
        subcategoryNameLabel.autoPinEdgeToSuperviewEdge(.Top, withInset: 12)
        subcategoryNameLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        
        
        /*** Beautician Image View ***/
        let beauticianImageView = UIImageView(frame: CGRectMake(0, 0, 86, 86))
        beauticianImageView.kf_setImageWithURL(NSURL(string: self.orderData.beauticianImageUrl)!, placeholderImage: UIImage(named: "Icon-76"))
        beauticianImageView.contentMode = .ScaleAspectFill
        addSubview(beauticianImageView)
        
        beauticianImageView.autoSetDimensionsToSize(CGSizeMake(86, 86))
        beauticianImageView.autoPinEdge(.Top, toEdge: .Bottom, ofView: subcategoryNameLabel, withOffset: 15)
        beauticianImageView.autoAlignAxisToSuperviewAxis(.Vertical)
        
        beauticianImageView.layer.cornerRadius  = beauticianImageView.frame.size.width/2
        beauticianImageView.layer.masksToBounds = true
        
        /*** Beautician Name ***/
        let beauticianNameLabel = UILabel()
        beauticianNameLabel.text = self.orderData.beauticianName
        beauticianNameLabel.font = UIFont(name: "MuseoSans-300", size: 15)
        beauticianNameLabel.sizeToFit()
        addSubview(beauticianNameLabel)
        
        beauticianNameLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: beauticianImageView, withOffset: 5)
        beauticianNameLabel.autoAlignAxisToSuperviewAxis(.Vertical)
        
        /*** the view that will handle all the order data ***/
        let detailsView = UIView()
        detailsView.backgroundColor = UIColor.clearColor()
        addSubview(detailsView)
        
        detailsView.autoAlignAxisToSuperviewAxis(.Vertical)
        detailsView.autoPinEdge(.Top, toEdge: .Bottom, ofView: beauticianNameLabel, withOffset: 20)
        
        /*** Date row ***/
        let wordDateLabel = UILabel()
        wordDateLabel.text = "Date"
        wordDateLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        wordDateLabel.sizeToFit()
        detailsView.addSubview(wordDateLabel)
        
        wordDateLabel.autoPinEdgeToSuperviewEdge(.Leading)
        wordDateLabel.autoPinEdgeToSuperviewEdge(.Top)
        
        let separator1 = UIView(frame: CGRectMake(0,0, 2, 18))
        separator1.backgroundColor = UIColor(red: 213.0/255, green: 38.0/255, blue: 101.0/255, alpha: 1)
        detailsView.addSubview(separator1)
        
        separator1.autoSetDimensionsToSize(CGSizeMake(2, 18))
        separator1.autoPinEdge(.Left, toEdge: .Right, ofView: wordDateLabel, withOffset: 13)
        separator1.autoAlignAxis(.Horizontal, toSameAxisOfView: wordDateLabel)
        
        let dateLabel = UILabel()
        dateLabel.text = self.orderData.dateOfBooking
        dateLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        dateLabel.sizeToFit()
        detailsView.addSubview(dateLabel)
        
        dateLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: separator1)
        dateLabel.autoPinEdge(.Left, toEdge: .Right, ofView: separator1, withOffset: 8)
        dateLabel.autoPinEdgeToSuperviewEdge(.Trailing)
        
        /*** Start time row ***/
        let wordFromLabel = UILabel()
        wordFromLabel.text = "From"
        wordFromLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        wordFromLabel.sizeToFit()
        detailsView.addSubview(wordFromLabel)
        
        wordFromLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: wordDateLabel, withOffset: 8)
        wordFromLabel.autoPinEdge(.Left, toEdge: .Left, ofView: wordDateLabel)
        
        let separator2 = UIView(frame: CGRectMake(0,0, 2, 18))
        separator2.backgroundColor = UIColor(red: 213.0/255, green: 38.0/255, blue: 101.0/255, alpha: 1)
        detailsView.addSubview(separator2)
        
        separator2.autoSetDimensionsToSize(CGSizeMake(2, 18))
        separator2.autoAlignAxis(.Horizontal, toSameAxisOfView: wordFromLabel)
        separator2.autoAlignAxis(.Vertical, toSameAxisOfView: separator1)
        
        let fromLabel = UILabel()
        fromLabel.text = self.orderData.startTime
        fromLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        fromLabel.sizeToFit()
        detailsView.addSubview(fromLabel)
        
        fromLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: separator2)
        fromLabel.autoPinEdge(.Left, toEdge: .Right, ofView: separator2, withOffset: 8)
        fromLabel.autoPinEdgeToSuperviewEdge(.Trailing)
        
        /*** End time row ***/
        let wordEndLabel = UILabel()
        wordEndLabel.text = "To"
        wordEndLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        wordEndLabel.sizeToFit()
        detailsView.addSubview(wordEndLabel)
        
        wordEndLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: wordFromLabel, withOffset: 8)
        wordEndLabel.autoPinEdge(.Left, toEdge: .Left, ofView: wordFromLabel)
        
        let separator3 = UIView(frame: CGRectMake(0,0, 2, 18))
        separator3.backgroundColor = UIColor(red: 213.0/255, green: 38.0/255, blue: 101.0/255, alpha: 1)
        detailsView.addSubview(separator3)
        
        separator3.autoSetDimensionsToSize(CGSizeMake(2, 18))
        separator3.autoAlignAxis(.Horizontal, toSameAxisOfView: wordEndLabel)
        separator3.autoAlignAxis(.Vertical, toSameAxisOfView: separator2)
        
        let endLabel = UILabel()
        endLabel.text = self.orderData.endTime
        endLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        endLabel.sizeToFit()
        detailsView.addSubview(endLabel)
        
        endLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: separator3)
        endLabel.autoPinEdge(.Left, toEdge: .Right, ofView: separator3, withOffset: 8)
        
        /*** Price row ***/
        let wordPriceLabel = UILabel()
        wordPriceLabel.text = "Price"
        wordPriceLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        wordPriceLabel.sizeToFit()
        detailsView.addSubview(wordPriceLabel)
        
        wordPriceLabel.autoPinEdge(.Top, toEdge: .Bottom, ofView: wordEndLabel, withOffset: 8)
        wordPriceLabel.autoPinEdge(.Left, toEdge: .Left, ofView: wordEndLabel)
        wordPriceLabel.autoPinEdgeToSuperviewEdge(.Bottom)
        
        let separator4 = UIView(frame: CGRectMake(0,0, 2, 18))
        separator4.backgroundColor = UIColor(red: 213.0/255, green: 38.0/255, blue: 101.0/255, alpha: 1)
        detailsView.addSubview(separator4)
        
        separator4.autoSetDimensionsToSize(CGSizeMake(2, 18))
        separator4.autoAlignAxis(.Horizontal, toSameAxisOfView: wordPriceLabel)
        separator4.autoAlignAxis(.Vertical, toSameAxisOfView: separator3)
        
        let priceLabel = UILabel()
        priceLabel.text = String(format: "%.3f", arguments: [self.orderData.subcategoryPrice]) + " KD"
        priceLabel.font = UIFont(name: "MuseoSans-500", size: 15)
        priceLabel.sizeToFit()
        detailsView.addSubview(priceLabel)
        
        priceLabel.autoAlignAxis(.Horizontal, toSameAxisOfView: separator4)
        priceLabel.autoPinEdge(.Left, toEdge: .Right, ofView: separator4, withOffset: 8)
        
        
        /*** Making every UILabel dark gray ***/
        for label in detailsView.subviews where label is UILabel
        {
            (label as! UILabel).textColor = UIColor(white: 0.1, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
