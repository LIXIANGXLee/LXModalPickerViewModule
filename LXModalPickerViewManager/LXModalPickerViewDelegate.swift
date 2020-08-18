//
//  LXModalPickerViewDelegate.swift
//  LXModalPickerViewModule
//
//  Created by XL on 2020/8/16.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

/// 仅模块内部使用
internal protocol LXModalPickerViewCommomDelegate {}

// MARK: - 协议  事件
@objc public  protocol LXModalPickerViewDelegate: AnyObject {
    
    /// Header 高度
    @objc optional  func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView,  heightForHeaderInSection section: Int) -> CGFloat
    
    /// Footer 高度
    @objc optional  func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView,  heightForFooterInSection section: Int) -> CGFloat
    
    /// cell 高度
    @objc optional  func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat

    /// cell点击事件
    @objc optional func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    
    ///滚动事件
    /// isTop == true 滚动到顶部
    /// offSet 滑动内容偏移量。tableView 的Y坐标变化
    /// isFirst == true 开始动画 isFirst == false 开始动画后的滑动
    @objc optional func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, scrollViewDidScroll offSetY: CGFloat, isFirst: Bool, isTop: Bool)
    
}

// MARK: - 协议  资源
@objc public  protocol LXModalPickerViewDataSource: AnyObject {
    /// 获取需要注册的UITableViewCell
    func modalPickerView(_ modalPickerView: LXModalPickerView, registerClass tableView: UITableView)

    /// 返回每组的cell个数
    func modalPickerView(_ modalPickerView: LXModalPickerView, numberOfRowsInSection section: Int) -> Int

    /// 设置对应索引的cell
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

    //cell 头
    @objc optional  func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView,  viewForHeaderInSection section: Int) -> UIView?

    //cell 尾
    @objc optional  func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView,  viewForFooterInSection section: Int) -> UIView?

    /// tableView 有几个组
    @objc optional  func modalPickerView(_ modalPickerView: LXModalPickerView, numberOfSections tableView: UITableView) -> Int

}
