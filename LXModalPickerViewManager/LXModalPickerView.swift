//
//  LXModalPickerView.swift
//  LXModalPickerViewModule
//
//  Created by XL on 2020/8/15.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

 // MARK: - 可滑动弹窗
public class LXModalPickerView: UIView,LXModalPickerViewCommomDelegate {

    /// 自定义构造器
    public init(_ frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height),style: UITableView.Style = .plain) {
        self.style = style
        super.init(frame: frame)
        self.frame = frame
        
        /// 背景色 默认不透明度
        self.viewOpaque = 0.7
    
        /// 原始弹出的Y坐标（原始坐标和最大坐标） 默认是屏幕的0.6倍
        self.contentViewOriginY = UIScreen.main.bounds.height * 0.6
        self.contentViewMaxY = UIScreen.main.bounds.height * 0.6
    
        /// 原始弹出可滑动后的的最小Y坐标 默认是屏幕的0.2倍
        self.contentViewMinY = UIScreen.main.bounds.height * 0.2
      
        /// 设置内容UI
        setContentUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 系统背景点击事件
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else {return}
        let view = self.hitTest(point, with: event)
        if view is LXModalPickerViewCommomDelegate && isDismissOfDidSelectBgView {  dismiss()  }
    }
    
    /// 延迟属性 加载内容
    internal lazy var tableView: UITableView = {
         let tableView = UITableView(frame: CGRect.zero, style: self.style)
        /// 设置背景色
         tableView.backgroundColor = UIColor.white
         /// 取消cell分割线
         tableView.separatorStyle = .none
         /// 设置代理
         tableView.dataSource = self
         tableView.delegate = self
         /// 设置滚动时图
         tableView.isScrollEnabled = true
    
         ///取消 tableHeaderView
         tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.01))
         ///取消 tableFooterView
         tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.01))

        /// 取消边界调整
         if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
         }else{
            tableView.translatesAutoresizingMaskIntoConstraints = false
         }
         return tableView
    }()
        
    /// 手势滑动
    private lazy var panGesture: UIPanGestureRecognizer = {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        panGesture.delegate = self
        return panGesture
    }()
    
    /// 设置当前代理  事件
    public weak var delegate: LXModalPickerViewDelegate?
    
    /// 设置当前代理  资源
    public weak var dataSouce: LXModalPickerViewDataSource? {
        didSet {
            /// 注册tableViewCell
            dataSouce?.modalPickerView(self, registerClass: tableView)
        }
    }
    
    /// 弹出来后 Y坐标 （原始坐标）
    private var contentViewOriginY: CGFloat?
    
    ///弹出来后 滑动后的最大Y坐标
    public var contentViewMaxY: CGFloat? {
        didSet {
            guard let contentViewMaxY = contentViewMaxY else { return }
            contentViewOriginY = contentViewMaxY
        }
    }
    
    ///弹出来后 滑动后的最小Y坐标
    public var contentViewMinY: CGFloat? {
        didSet {
            tableView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - contentViewMinY!)
        }
    }
    
    /// 背景黑色的不透明度
    public var viewOpaque: CGFloat? {
        didSet {
            guard let viewOpaque = viewOpaque else { return }
            self.backgroundColor = UIColor.black.withAlphaComponent(viewOpaque)
        }
    }
    
    /// 自定义 tableHeaderView
    public var tableHeaderView: UIView? {
        didSet {
            guard let tableHeaderView = tableHeaderView else { return }
            self.tableView.tableHeaderView = tableHeaderView
        }
    }
    
    /// 自定义 tableFooterView
    public var tableFooterView: UIView? {
        didSet {
            guard let tableFooterView = tableFooterView else {  return  }
            self.tableView.tableFooterView = tableFooterView
        }
    }
    
    /// 动画时长。默认为0.15
    public var animationDuration: TimeInterval = 0.15
    
    /// 默认是true 点击背景事件 dismiss
    public var isDismissOfDidSelectBgView: Bool = true
    
    /// 添加tableView 内边距 推荐在 style == style: UITableView.Style.grouped 场景使用 
    public var contentBottomInset: CGFloat? {
        didSet {
            guard let contentBottomInset = contentBottomInset else { return }
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: contentBottomInset, right: 0)
        }
    }
    
    /// 记录默认 tableView 滚动偏移量
    internal var tableViewOriginContentOffSetY: CGFloat = 0
    
    
    ///内容分组 和 不分组
    private var style: UITableView.Style
    
}

// MARK: - private 函数
extension LXModalPickerView {
    
    ///初始化UI
    private func setContentUI() {

        /// 添加tableView
        addSubview(tableView)
       
        /// 添加手势 给tableView
        tableView.addGestureRecognizer(panGesture)
        
        /// 设置tableView尺寸
        self.tableView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - contentViewMinY!)

    }
    
    /// presented跟控制器
    private var aboveViewController: UIViewController? {
        var aboveController = UIApplication.shared.delegate?.window??.rootViewController
        while aboveController?.presentedViewController != nil {
            aboveController = aboveController?.presentedViewController
        }
        return aboveController
    }
    
    
    /// 手势滑动 事件处理
    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
       
        
        let point = gesture.translation(in: gesture.view)

        /// 开始滑动
        if gesture.state == .began {
            self.contentViewOriginY = self.tableView.frame.origin.y
        }else if gesture.state == .changed { /// 持续滑动修改

            self.tableView.frame.origin.y = max(self.contentViewOriginY! + point.y - self.tableViewOriginContentOffSetY, self.contentViewMinY!)
            
        }else { /// 结束 或者 取消滑动
            endAnimation(self.tableView.frame.origin.y)
        }
    }
}

// MARK: - public 函数
extension LXModalPickerView {
    
    /// 显示modalView
    public func show() {
        
        ///添加view到root视图
        aboveViewController?.view.addSubview(self)
        
        /// 开始动画
        starAnimation()
    }
    
    /// 退出modalView
    public func dismiss() {
        
        /// 结束动画
        endAnimation(UIScreen.main.bounds.height)
    }
    
    /// 开始动画
    private func starAnimation() {
        
          self.backgroundColor = UIColor.black.withAlphaComponent(0.001)
          self.tableView.frame.origin.y = UIScreen.main.bounds.height
          UIView.animate(withDuration: animationDuration, animations: {
              self.backgroundColor = UIColor.black.withAlphaComponent(self.viewOpaque!)
              self.tableView.frame.origin.y = self.contentViewOriginY!

          }) { (finish) in
              self.contentViewOriginY = self.tableView.frame.origin.y
          }
    }
    
    /// 结束动画
    private func endAnimation(_ y: CGFloat) {
        UIView.animate(withDuration: animationDuration, animations: {
            
            if y >= self.contentViewMinY! && y <= self.contentViewMaxY! { /// 最大和最小之间
                
                let isTop = (y - self.contentViewMinY! <= self.contentViewMaxY! - y) ? true : false
                self.tableView.frame.origin.y = isTop ? self.contentViewMinY! : self.contentViewMaxY!

                /// 判断动画结束后的偏移方向
                if isTop {
                    self.contentViewOriginY = max(self.tableView.frame.origin.y, self.contentViewMinY!)
                }else{
                    self.contentViewOriginY = max(self.tableView.frame.origin.y, self.contentViewMaxY!)
                }
                
            }else if  y > self.contentViewMaxY! && y <= UIScreen.main.bounds.height{/// 最大和底部的之间
                
                /// 判断动画结束后的偏移方向
                let isTop = (y - self.contentViewMaxY! <= UIScreen.main.bounds.height - y) ? true : false
                self.tableView.frame.origin.y = isTop ? self.contentViewMaxY! : UIScreen.main.bounds.height
                if isTop {
                    self.contentViewOriginY = max(self.tableView.frame.origin.y, self.contentViewMaxY!)
                }else{
                    self.contentViewOriginY = max(self.tableView.frame.origin.y, UIScreen.main.bounds.height)
                    self.backgroundColor = UIColor.black.withAlphaComponent(0.001)
                }
            }
            
        }) { (finish) in
            if  y > self.contentViewMaxY! && y <= UIScreen.main.bounds.height{
                let isTop = (y - self.contentViewMaxY! <= UIScreen.main.bounds.height - y) ? true : false
                if !isTop { self.removeFromSuperview() }
            }
        }
    }
}
