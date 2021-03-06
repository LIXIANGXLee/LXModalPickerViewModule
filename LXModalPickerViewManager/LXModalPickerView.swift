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
            /// 设置背景色
            self.setbackgroundColor(false)
        }
    }
    
    /// 自定义 tableHeaderView
    public var tableHeaderView: UIView? {
        didSet {
            guard let tableHeaderView = tableHeaderView else { return }
            
            /// 判断 如果有 setContentHeaderTopCornerRadii 则设置原角
             if let cornerRadii = setContentHeaderTopCornerRadii  {
                tableHeaderView.setTopCornerRadii(cornerRadii)
             }
            
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
    
    /// 背景的头部。推荐在 show() 函数之前调用
    public var bgHeaderView: UIView? {
        didSet {
            guard let bgHeaderView = bgHeaderView else { return }
            self.addSubview(bgHeaderView)
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(bgPanGesture(_:)))
            panGesture.delegate = self
            bgHeaderView.addGestureRecognizer(panGesture)
            /// Y坐标修改
            setBgHeaderViewFrameY(false)

        }
    }
    
    /// 背景的尾部 推荐在 show() 函数之前调用
    public var bgFooterView: UIView? {
        didSet {
            guard let bgFooterView = bgFooterView else { return }
            contentBottomInset = bgFooterView.frame.height
            setBgFooterViewFrameY(true)
            addSubview(bgFooterView)
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
    
    ///设置内容顶部圆角
    public var setContentHeaderTopCornerRadii: CGFloat? {
        didSet {
            guard let cornerRadii = setContentHeaderTopCornerRadii else { return }
            tableHeaderView?.setTopCornerRadii(cornerRadii)
        }
    }
    
    /// 设置内容背景色
    public var setContentBackgroundColor: UIColor? {
        didSet {
            guard let backgroundColor = setContentBackgroundColor else { return }
            self.tableView.backgroundColor = backgroundColor
        }
        
    }
    
    /// 记录默认 tableView 滚动偏移量
    internal var tableViewOriginContentOffSetY: CGFloat = 0
   
    ///滑动的事bgView的头部时 isScrollBgHeaderView == true
    internal var isScrollBgHeaderView: Bool = false
    
    
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
    
    /// presented跟控制器的view
    private var aboveRootView: UIView? {
        var aboveController = UIApplication.shared.delegate?.window??.rootViewController
        while aboveController?.presentedViewController != nil {
            aboveController = aboveController?.presentedViewController
        }
        return aboveController?.view
    }
    
    
    /// 手势滑动 事件处理
    @objc private func bgPanGesture(_ gesture: UIPanGestureRecognizer) {
        
        /// 滑动控件在减速中。禁止滑动顶部bgHeaderView
        if self.tableView.isDecelerating  { return }
          
        /// 获取偏移量
        let point = gesture.translation(in: gesture.view)

        ///滑动bgHeaderView的时候 重置 tableView的偏移量
        if point.y > 0 {
            self.isScrollBgHeaderView = true
        }
        
        /// 滑动事件处理
        panGesture(gesture)
    }
    
    /// 滑动事件处理
    @objc private func panGesture(_ gesture: UIPanGestureRecognizer) {
        
        let point = gesture.translation(in: gesture.view)

        /// 开始滑动
        if gesture.state == .began {
            self.contentViewOriginY = self.tableView.frame.origin.y
        }else if gesture.state == .changed {
            /// 持续滑动修改tableView 的Y坐标
            self.tableView.frame.origin.y = max(self.contentViewOriginY! + point.y - (self.isScrollBgHeaderView ? 0 : self.tableViewOriginContentOffSetY), self.contentViewMinY!)
            
            /// 布局BgHeaderView 的Y坐标
            setBgHeaderViewFrameY(false)
            
        }else {
            /// 结束 或者 取消滑动
            endAnimation(self.tableView.frame.origin.y)
        }
    }
    
    /// 修改BgHeaderView的Y坐标位置
    ///
    /// - Parameters:
    ///   - isFirst: 为 true时  是首次设置Y坐标
     private func setBgHeaderViewFrameY(_ isFirst: Bool = false) {
        
        /// 滚动事件 监听回调
        delegate?.modalPickerView?(self, tableView: tableView, scrollViewDidScroll:  max(self.contentViewMinY!, tableView.frame.origin.y), isFirst: isFirst, isTop: Int(tableView.frame.origin.y) == Int(self.contentViewMinY!))
        
        /// 判断bgHeaderView是不是为nil
        guard let bgHeaderView = bgHeaderView else { return }
        /// bgHeaderView Y坐标布局
        bgHeaderView.frame.origin.y = tableView.frame.origin.y - bgHeaderView.frame.height
        
    }
    
    /// 修改bgFooterView的Y坐标位置
    ///
    /// - Parameters:
    ///   - isDefault: 为 true时  默认弹出来后的Y坐标
     private func setBgFooterViewFrameY(_ isDefault: Bool = true) {
        /// 判断bgHeaderView是不是为nil
        guard let bgFooterView = bgFooterView else { return }
        bgFooterView.frame.origin.y = UIScreen.main.bounds.height - (isDefault ? bgFooterView.frame.height : 0)
    }
    
    /// 设置contentViewOriginY 原y坐标
    ///
    /// - Parameters:
    ///   - isBig: 为 true时 /// contentViewMinY ... self.contentViewMaxY 为false时/// self.contentViewMaxY <.. UIScreen.main.bounds.height
    ///   - isTop: 为 true时  偏上， 为false 偏下
    private func setContentViewOriginY(_ isBig: Bool, _ isTop: Bool ) {
        
        if isBig { /// contentViewMinY ... self.contentViewMaxY
            
            self.contentViewOriginY = isTop ? self.contentViewMinY! : self.contentViewMaxY!

            if isTop {  self.isScrollBgHeaderView = false }
            
        }else{ /// self.contentViewMaxY <.. UIScreen.main.bounds.height
            
             self.contentViewOriginY =  isTop ? self.contentViewMaxY! : UIScreen.main.bounds.height

        }
        
        self.tableView.frame.origin.y = self.contentViewOriginY!

    }
    
    /// 设置背景色
    ///
    /// - Parameters:
    ///   - isAlpha: 为 true时 /// 表示透明。透明度设置为 0.001 为false时表示自定义透明度viewOpaque的值
    private func  setbackgroundColor(_ isAlpha: Bool) {
        guard let viewOpaque = viewOpaque else { return }
        self.backgroundColor = UIColor.black.withAlphaComponent(isAlpha ? 0.001 : viewOpaque)
    }

/// 开始动画
   private func starAnimation() {
    
        /// 设置默认tableView的Y坐标
         self.tableView.frame.origin.y = UIScreen.main.bounds.height + (bgHeaderView?.frame.height ?? 0)
       
          /// 设置默认背景色
         setbackgroundColor(true)
       
         /// 默认布局BgHeaderView 的Y坐标
         setBgHeaderViewFrameY(false)

         /// 默认布局BgHeaderView 的Y坐标
         self.setBgFooterViewFrameY(false)

         UIView.animate(withDuration: animationDuration, animations: {
           
             self.tableView.frame.origin.y = self.contentViewOriginY!
           
               /// 设置背景色
              self.setbackgroundColor(false)
              /// 布局BgHeaderView 的Y坐标
              self.setBgHeaderViewFrameY(true)
            
              /// 布局BgHeaderView 的Y坐标
              self.setBgFooterViewFrameY(true)

         }) { (finish) in
             self.contentViewOriginY = self.tableView.frame.origin.y
         }
   }
   
   /// 结束动画
   private func endAnimation(_ y: CGFloat) {
    
//       self.isScrollBgHeaderView = false
       UIView.animate(withDuration: animationDuration, animations: {
           
           if y >= self.contentViewMinY! && y <= self.contentViewMaxY! { /// 最大和最小之间
               
               /// 判断动画结束后的偏移方向
               let isTop = (y - self.contentViewMinY! <= self.contentViewMaxY! - y) ? true : false
               
               /// 设置原contentViewOriginY 值
               self.setContentViewOriginY(true, isTop)

           }else if  y > self.contentViewMaxY! && y <= UIScreen.main.bounds.height{/// 最大和底部的之间

               /// 判断动画结束后的偏移方向
               let isTop = (y - self.contentViewMaxY! <= UIScreen.main.bounds.height - y) ? true : false
               
               /// 设置原contentViewOriginY 值
               self.setContentViewOriginY(false, isTop)
               
               if !isTop {
                  /// 设置背景色
                   self.setbackgroundColor(true)
                   /// 布局BgHeaderView 的Y坐标
                   self.setBgFooterViewFrameY(false)
               }
           }
           
           /// 布局BgHeaderView 的Y坐标
           self.setBgHeaderViewFrameY(false)
           
       }) { (finish) in
           if  y > self.contentViewMaxY! && y <= UIScreen.main.bounds.height{
               let isTop = (y - self.contentViewMaxY! <= UIScreen.main.bounds.height - y) ? true : false
               if !isTop {
                /// 动画结束 关闭页面 及回调
                self.removeFromSuperview()
                self.delegate?.modalPickerView?(dismiss: self, tableView: self.tableView)
              }
           }
       }
   }
}

// MARK: - public 函数
extension LXModalPickerView {
    
    /// 显示modalView
    ///
    /// - Parameters:
    ///   - rootView: 不为nill时，表示传进来了父view ，为nill时 则用aboveViewController?.view做为父view
    public func show(_ rootView: UIView? = nil) {
        
        if rootView != nil {
            ///添加view到root视图
            rootView?.addSubview(self)
        }else{
            ///添加view到root视图
            aboveRootView?.addSubview(self)
        }
        
        /// 开始动画
        starAnimation()
    }
    
    /// 退出modalView
    public func dismiss() {
        
        /// 结束动画
        endAnimation(UIScreen.main.bounds.height)
    }
    
    /// 刷新content数据
    public func reloadData() {
        self.tableView.reloadData()
    }
    
}
