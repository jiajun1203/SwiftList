//
//  ViewController.swift
//  OpenColseList
//
//  Created by William on 2022/3/11.
//

/**
            超轻量级列表开合,主要通过2个方法来操作数据, 2个方法来确定动画cell
            使用时只要保持model中前三个属性不变, 而子列表属性替换为自己定义即可。
                
            代码量极少,使用极其方便,               ***欢迎star***
            QQ群 :   939394226
 */
import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var baseTbv: UITableView!
    
    var baseArr : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "开合列表"
        
        let item1 = MRC_ItemModel()
        item1.title = "开合列表（一次获取全部数据）"
        let item2 = MRC_ItemModel()
        item2.title = "开合列表（逐级加载子层数据）"
        self.baseArr.append(contentsOf: [item1,item2])
        
        self.baseTbv.delegate = self
        self.baseTbv.dataSource = self
        self.baseTbv.register(UINib.init(nibName: "MRC_ItemCell", bundle: nil), forCellReuseIdentifier: "MRC_ItemCell")
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.baseArr[indexPath.row] as! MRC_ItemModel
        let cell = tableView.dequeueReusableCell(withIdentifier: "MRC_ItemCell") as! MRC_ItemCell
        cell.lead_Space.constant = CGFloat((model.tier > 1 ? 20 : 15) * model.tier)
        cell.lab_Title.text = model.title
        cell.imgv_Left.isHidden = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.baseArr.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            self.navigationController?.pushViewController(MRC_InheritVc(), animated: true)
        }else{
            self.navigationController?.pushViewController(MRC_LoadingListVvc(), animated: true)
        }
    }
}

