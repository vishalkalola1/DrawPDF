//
//  HPAlertShow.swift
//  HPAlertShow
//
//  Created by Hasya.Panchasara on 21/11/17.
//  Copyright © 2017 Hasya Panchasara. All rights reserved.
//

import UIKit

public enum viewPositionInMainView : Int {
    
    
    case Top // Top allign within main screen - Status & navigation bar ( 84 )
    
    case Center // Center allign within main screen
    
    case Bottom // Bottom allign within main screen - tab bar ( 64 )
    
}

private struct Customs{

    static let viewHeight : Int = 160
    static let viewX : Int = 20
 
    static let viewTopPositionGap : Int = 84
    static let viewBottomPositionGap : Int = 64
    
    static let labelGapInView : CGFloat = 10
    static let labelBackgroundColor : UIColor = UIColor.clear
    
    static let animationDuration : Double = 0.5
 
    static let imageDimension : Int = 50
    static let imageTopOffset : Int = 10
}

class HPAlertShow: NSObject{
    
    private var viewCustom = UIView()
    private var imgCustom = UIImageView()
    private var lblCustom = UILabel()
    private var timer : Timer?
    private var viewMain : UIViewController?
    
    let position = Int()
    
    //sharedInstance
    static let sharedInstance = HPAlertShow()

    func showStatusView(state:Bool,
                        time:Int,
                        addToView:UIViewController,
                        text:String,
                        textFontColor:UIColor,
                        textFontSize:CGFloat,
                        position:viewPositionInMainView,
                        viewBackgroundColor:UIColor,
                        viewOpacity:Float,
                        viewCornerRadius:CGFloat,
                        viewBorderWidth:CGFloat,
                        viewBorderColor:UIColor,
                        completion: @escaping (_ result: Bool) -> Void)
    {
        
        viewMain = addToView
     
        let ViewControllerHeight : Int = Int(addToView.view.frame.size.height)
        let viewCustomY : Int = ( ViewControllerHeight / 2 ) - Customs.viewHeight / 2
       
        let ViewControllerWidth : Int = Int(addToView.view.frame.size.width)
        let viewCustomWidth : Int = ViewControllerWidth - Customs.viewX - Customs.viewX
        
        
        if position == .Top
        {
            viewCustom = UIView(frame: CGRect(x: Customs.viewX, y: Int(Customs.viewTopPositionGap), width: viewCustomWidth, height: Customs.viewHeight))
        }
        else if position == .Center
        {
            viewCustom = UIView(frame: CGRect(x: Customs.viewX, y: viewCustomY, width: viewCustomWidth, height: Customs.viewHeight))

        }
        else if position == .Bottom
        {
            viewCustom = UIView(frame: CGRect(x: Customs.viewX, y: ViewControllerHeight - Customs.viewHeight - Customs.viewBottomPositionGap
                , width: viewCustomWidth, height: Customs.viewHeight))
        }
        
        imgCustom = UIImageView(frame: CGRect(x: Int(viewCustom.frame.size.width) / 2 - Customs.imageDimension / 2, y: Customs.imageTopOffset, width: Customs.imageDimension, height: Customs.imageDimension))
        
        if state == true
        {
            imgCustom.image = UIImage(named: "True_150.png")
        }
        else
        {
            imgCustom.image = UIImage(named: "False_150.png")
        }
        
        viewCustom.backgroundColor = viewBackgroundColor
        viewCustom.layer.opacity = viewOpacity
        viewCustom.layer.cornerRadius = viewCornerRadius
        viewCustom.layer.borderWidth = viewBorderWidth
        viewCustom.layer.borderColor = viewBorderColor.cgColor
        
        
        lblCustom.text = text
   
        
        let fnt : UIFont = UIFont.systemFont(ofSize: textFontSize) //(name: UIFont.systemFontSize, size: textFontSize)
        
        print(self.heightForView(text: text, font: fnt, width: viewCustom.frame.size.width - Customs.labelGapInView - Customs.labelGapInView))
        lblCustom = UILabel(frame: CGRect(x: Customs.labelGapInView, y: imgCustom.frame.origin.y + imgCustom.frame.size.height + Customs.labelGapInView, width: viewCustom.frame.size.width - Customs.labelGapInView - Customs.labelGapInView, height: self.heightForView(text: text, font: fnt, width: viewCustom.frame.size.width - Customs.labelGapInView - Customs.labelGapInView)  ))
        
        lblCustom.backgroundColor = Customs.labelBackgroundColor
        lblCustom.textColor = textFontColor
        lblCustom.numberOfLines = 0
        lblCustom.textAlignment = .center
        lblCustom.text = text
        lblCustom.font = lblCustom.font.withSize(textFontSize)
        
        var frmView : CGRect = viewCustom.frame
        frmView.size.height = lblCustom.frame.origin.y + lblCustom.frame.size.height + Customs.labelGapInView
        viewCustom.frame = frmView
        
        if position == .Center
        {
            frmView = viewCustom.frame
            frmView.origin.y =  CGFloat(ViewControllerHeight / 2 - Int(frmView.size.height) / 2)
            viewCustom.frame = frmView
        }
        else if position == .Bottom
        {
            
            frmView = viewCustom.frame
            frmView.origin.y =  CGFloat(ViewControllerHeight - Int(frmView.size.height) - Customs.viewBottomPositionGap )
            viewCustom.frame = frmView
        }
        
        viewCustom.clipsToBounds = true
        viewCustom.addSubview(imgCustom)
        viewCustom.addSubview(lblCustom)
        
        
        UIView.animate(withDuration: Customs.animationDuration) {
            self.viewMain?.view.addSubview(self.viewCustom)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(time), repeats: false, block: { (tmr) in
            
            self.timer?.invalidate()
            self.timer = nil
            
            UIView.animate(withDuration: Customs.animationDuration) {
                self.viewCustom.removeFromSuperview()
            }
            
            completion(true)
            
        })
        
    }
 
    private func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
    
}
