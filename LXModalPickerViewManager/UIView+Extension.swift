//
//  UIView+Extension.swift
//  LXModalPickerViewManager
//
//  Created by XL on 2020/8/19.
//

import UIKit

extension UIView {
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - radii: 圆角半径
   public func setTopCornerRadii(_ radii: CGFloat) {
        setCornerRadii(radii, corners: [.topLeft,.topRight])
    }
    
    /// 部分圆角
    ///
    /// - Parameters:
    ///   - corners: 需要实现为圆角的角，可传入多个
    ///   - radii: 圆角半径
    public func setCornerRadii(_ radii: CGFloat, corners: UIRectCorner) {
           let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radii, height: radii))
           let maskLayer = CAShapeLayer()
           maskLayer.frame = self.bounds
           maskLayer.path = maskPath.cgPath
           self.layer.mask = maskLayer
       }
    
}
