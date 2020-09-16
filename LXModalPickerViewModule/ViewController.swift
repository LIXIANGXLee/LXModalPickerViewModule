//
//  ViewController.swift
//  LXModalPickerViewModule
//
//  Created by XL on 2020/8/15.
//  Copyright © 2020 李响. All rights reserved.
//

import UIKit
import LXModalPickerViewManager

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white

        let button = UIButton(type: .custom)
        button.setTitle("弹窗", for: .normal)
        button.backgroundColor = UIColor.black
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
    }

    
    @objc private func buttonAction() {
        
        print("弹窗")
        let  modal = LXModalPickerView(style: UITableView.Style.grouped)
           modal.delegate = self
           modal.dataSouce = self
           modal.viewOpaque = 0.5
        
//          modal.setContentBackgroundColor = UIColor.clear
        
//        modal.animationDuration = 5
        modal.contentViewMinY = UIScreen.main.bounds.height * 0.2
//        
        modal.contentViewMaxY = UIScreen.main.bounds.height * 0.75
        
//        modal.isDismissOfDidSelectBgView = false
       
//        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 120))
//        header.backgroundColor = UIColor.orange
//        modal.bgFooterView =  header
         
        //          modal.contentBottomInset = 200

                 modal.setContentHeaderTopCornerRadii = 20
                
         let tableheader = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
         tableheader.isUserInteractionEnabled = true
           tableheader.image = UIImage(named: "timg")
        
        tableheader.setTopCornerRadii(20)
           modal.bgHeaderView = tableheader
                 

          modal.show()
 
        
    }

}

extension ViewController: LXModalPickerViewDelegate {
 
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 80
    }
    
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
        
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, scrollViewDidScroll offSetY: CGFloat, isFirst: Bool, isTop: Bool) {
          print("=-=-=-=-=-==\(offSetY)====\(isFirst)=====\(isTop)")
    }
    
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("======\(indexPath)")
    }
}


extension ViewController: LXModalPickerViewDataSource {
    func modalPickerView(_ modalPickerView: LXModalPickerView, registerClass tableView: UITableView) {
           tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ee")
       }
       
       func modalPickerView(_ modalPickerView: LXModalPickerView, numberOfRowsInSection section: Int) -> Int {
           return 3
       }
       
       func modalPickerView(_ modalPickerView: LXModalPickerView, numberOfSections tableView: UITableView) -> Int {
           return 4
       }
       func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell =  tableView.dequeueReusableCell(withIdentifier: "ee")
           cell?.textLabel?.text = "你是谁\(indexPath.section)组，排行\(indexPath.row)"
        
            return cell!
       }
       
    
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
        header.text  = "我是第\(section)组头部标题"
        header.textAlignment = .center
        header.font = UIFont.systemFont(ofSize: 20)
        header.textColor = UIColor.white
        header.backgroundColor = UIColor.blue
        return header
    }
       
    func modalPickerView(_ modalPickerView: LXModalPickerView, tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          let footer = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 80))
          footer.text  = "我是第\(section)组尾部标题"
          footer.textAlignment = .center
          footer.font = UIFont.systemFont(ofSize: 20)
          footer.textColor = UIColor.white
       
         footer.backgroundColor = UIColor.orange
         return footer
    }
       
}
