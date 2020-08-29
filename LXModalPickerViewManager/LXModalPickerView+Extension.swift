//
//  LXModalPickerView+Extension.swift
//  LXModalPickerViewModule
//
//  Created by XL on 2020/8/16.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit

// MARK: - UITableViewDelegate 函数
extension LXModalPickerView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.modalPickerView?(self, tableView: tableView, heightForRowAt: indexPath) ?? 55
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.modalPickerView?(self, tableView: tableView, heightForHeaderInSection: section) ?? 0.001
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegate?.modalPickerView?(self, tableView: tableView, heightForFooterInSection: section) ?? 0.001

    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        ///点击事件回调 取消点击效果
        tableView.deselectRow(at: indexPath, animated: true)
        /// 点击事件回调
        delegate?.modalPickerView?(self, tableView: tableView, didSelectRowAt: indexPath)
    }
}

// MARK: - UITableViewDataSource 函数
extension LXModalPickerView: UITableViewDataSource {
    
    /// tableView有几个组
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSouce?.modalPickerView?(self, numberOfSections: tableView) ?? 1
    }
    
    /// cell 个数
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataSouce?.modalPickerView(self, numberOfRowsInSection: section) ?? 0
    }
    
    /// cell头
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return  dataSouce?.modalPickerView?(self, tableView: tableView, viewForHeaderInSection: section)
    }
    
    //cell 尾
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return  dataSouce?.modalPickerView?(self, tableView: tableView, viewForFooterInSection: section)
    }
    
    /// cell 加载
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return dataSouce!.modalPickerView(self, tableView: tableView, cellForRowAt: indexPath)
    }
    
}

// MARK: - UIGestureRecognizerDelegate 函数
extension LXModalPickerView:  UIGestureRecognizerDelegate {
    
    /// 支持多个 事件同时进行
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - UIScrollViewDelegate 函数
extension LXModalPickerView:  UIScrollViewDelegate {
    
    /// 滚动视图
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && Int(self.tableView.frame.origin.y) == Int(self.contentViewMinY!){
          
        }else{
            /// 处理滑动顶部bgHeaderView的时候tableView偏移量处理
            if self.isScrollBgHeaderView {
                self.tableView.contentOffset = CGPoint(x: 0, y: self.tableViewOriginContentOffSetY)
            }else {
                /// 非滑动顶部bgHeaderView的时候tableView偏移量处理
                self.tableView.contentOffset = CGPoint.zero
            }
        }
    }
    
    ///开始拖拽
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        /// 记录偏移量
        self.tableViewOriginContentOffSetY = self.tableView.contentOffset.y
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        /// 记录偏移量
        self.tableViewOriginContentOffSetY = self.tableView.contentOffset.y
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        /// 记录偏移量
        self.tableViewOriginContentOffSetY = self.tableView.contentOffset.y
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        /// 记录偏移量
        self.tableViewOriginContentOffSetY = self.tableView.contentOffset.y
    }
}
