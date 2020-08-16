# LXModalPickerViewModule

#### 项目介绍
 **

### 最完美、最轻量级的滑动弹窗 类似地图、美团的滑动弹窗 可自定义 内容
** 

#### 安装说明
方式1 ： cocoapods安装库 
        ** pod 'LXModalPickerViewManager' **
        ** pod install ** 

方式2:   **直接下载压缩包 解压**    **LXModalPickerViewManager **   

#### 使用说明
 **下载后压缩包 解压   请先 pod install  在运行项目** 
  
```

    let  modal = LXModalPickerView()
    modal.delegate = self
    modal.dataSouce = self
    modal.show()
         
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

```

