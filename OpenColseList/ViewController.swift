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

    var baseModel : MRC_ItemModel!
    var arr_AnimationCell : [Int] = Array()     //要做展开或闭合动画的index数组
    var baseArr : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "开合列表"
        
        self.baseModel = MRC_ItemModel()
        self.baseModel.initSubs()
        
        self.baseTbv.delegate = self
        self.baseTbv.dataSource = self
        self.baseTbv.register(UINib.init(nibName: "MRC_ItemCell", bundle: nil), forCellReuseIdentifier: "MRC_ItemCell")
        
        self.getCurrentListCount(model: self.baseModel)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.baseArr[indexPath.row] as! MRC_ItemModel
        let cell = tableView.dequeueReusableCell(withIdentifier: "MRC_ItemCell") as! MRC_ItemCell
        cell.lead_Space.constant = CGFloat((model.tier > 1 ? 20 : 15) * model.tier)
        cell.lab_Title.text = model.title
        cell.imgv_Left.transform = .identity
        
        if model.isAlert{
            cell.imgv_Left.image = .init(named: "gantanhao")
            cell.lab_Title.font = UIFont.systemFont(ofSize: 15)
            cell.lab_Title.textColor = UIColor.lightGray
        }else{
            cell.imgv_Left.image = .init(named: "arrow_Right")
            cell.lab_Title.font = UIFont.systemFont(ofSize: 16)
            cell.lab_Title.textColor = UIColor.black
            
            if model.isOpen == true{
                cell.imgv_Left.transform = cell.imgv_Left.transform.rotated(by: CGFloat(Double.pi/2.0))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.baseArr.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! MRC_ItemCell
        let model = self.baseArr[indexPath.row] as! MRC_ItemModel
        
        //如果当前层是末层提示层,直接返回
        if model.isAlert{
            return
        }
        //展开闭合箭头动画
        UIView.animate(withDuration: 0.2) { () -> Void in
            cell.imgv_Left.transform = cell.imgv_Left.transform.rotated(by: CGFloat(model.isOpen ? -Double.pi/2.0 : Double.pi/2.0))
        }
        
        model.isOpen = !model.isOpen
        
        self.resetAnimation(model: model)
        
        if model.isOpen == false{
            //用户闭合，删除数组对应数据
            self.getDeleteIndex(model: model)
            var arr : [MRC_ItemModel] = []
            for index in self.arr_AnimationCell{
                arr.append(self.baseArr[index] as! MRC_ItemModel)
            }
            self.baseArr.removeAll{arr.contains($0 as! MRC_ItemModel)}
        }else{
            
            #warning("如果子层没有需要提示,添加这段话")
            if model.items.count == 0{
                let alert = MRC_ItemModel()
                alert.isAlert = true
                alert.title = "没有更多了"
                alert.isShowAnimation = true
                alert.items = []
                alert.tier = model.tier + 1
                model.items.append(alert)
            }
            
            //用户展开，重新获取数据
            self.baseArr.removeAll()
            self.getCurrentListCount(model: self.baseModel)
        }
        
        //创建要做动画indexpath
        var array : [IndexPath] = Array()
        for index in self.arr_AnimationCell{
            let indexp = IndexPath(row: index, section: 0)
            array.append(indexp)
        }
        self.arr_AnimationCell.removeAll()
        
        if #available(iOS 11.0, *){
            if model.isOpen == true{
                self.baseTbv.insertRows(at: array, with: UITableView.RowAnimation.automatic)
            }else{
                self.baseTbv.deleteRows(at: array, with: UITableView.RowAnimation.automatic)
            }
        }else{
            self.baseTbv.reloadData()
        }
    }
    
    #warning("主要通过下面4个方法控制列表开合,修改请留意")
    
    //确定当前列表数量
    func getCurrentListCount(model : MRC_ItemModel){
        self.baseArr.append(model)
        self.getSubModel(model: model)
    }
    
    //获取用户最新展开当前cell的子层级item
    func getSubModel(model : MRC_ItemModel ){
        if model.isOpen {
            for item in model.items {
                self.baseArr.append(item)
                self.getSubModel(model: item)
                if item.isShowAnimation{
                    item.isShowAnimation = false
                    let index = self.baseArr.firstIndex { (e) in
                        return e as! NSObject == item
                    }
                    self.arr_AnimationCell.append(index!)
                }
            }
        }
    }
    
    //获取重新展开时要做动画cell的index
    func resetAnimation(model : MRC_ItemModel){
        if model.isOpen {
            for item in model.items {
                item.isShowAnimation = true
                self.resetAnimation(model: item)
            }
        }
    }
    
    //获取要删除的index
    func getDeleteIndex(model : MRC_ItemModel){
        for item in model.items {
            item.isShowAnimation = false
            let index = self.baseArr.firstIndex { (e) in
                return e as! NSObject == item
            }
            self.arr_AnimationCell.append(index!)
            if item.isOpen == true{
                self.getDeleteIndex(model: item)
            }
        }
    }
}

