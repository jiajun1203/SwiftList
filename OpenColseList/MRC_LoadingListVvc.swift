//
//  MRC_LoadingLostVvc.swift
//  OpenColseList
//
//  Created by william on 2022/4/19.
//  逐级请求加载模型（首次只获取一级model，点击加载下一级）  一次全部返回请参照  MRC_InheritVc

import Foundation
import UIKit

class MRC_LoadingListVvc: MRC_BaseList,UITableViewDelegate,UITableViewDataSource {
    var tableView : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "70代码完成开合列表"
        self.tableView = UITableView.init(frame: self.view.bounds)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        //给父类tableview赋值(父类已弱引用)
        self.baseTbv = self.tableView
        
        self.tableView.register(UINib.init(nibName: "MRC_ItemCell", bundle: nil), forCellReuseIdentifier: "MRC_ItemCell")
        
        self.isShowEmptyCell = true //是否在数据为空是展示空cell
        
        //模型可继承,可替换,items 属性换为后台返回对应字段后,整类搜索替换
        self.baseModel = MRC_ItemModel()
        
        //最顶级模型只是装有子模型的话，此处设置false，若要展示顶级模型(即包含子模型数组的model)，此处设置true
        self.baseModel.topModelIsShow = true
        
        self.getCurrentListCount(model: self.baseModel)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.baseArr[indexPath.row] as! MRC_ItemModel
        let cell = tableView.dequeueReusableCell(withIdentifier: "MRC_ItemCell") as! MRC_ItemCell
        cell.lab_Title.text = model.title
        
        if (self.isShowEmptyCell == true &&
            model.isAlert == true){
            //当允许展示提示cell,并且当前是提示model时,展示提示cell
            cell.imgv_Left.image = .init(named: "gantanhao")
            cell.lab_Title.font = UIFont.systemFont(ofSize: 15)
            cell.lab_Title.textColor = UIColor.lightGray
        }else{
            cell.imgv_Left.image = .init(named: "arrow_Right")
            cell.lab_Title.font = UIFont.systemFont(ofSize: 16)
            cell.lab_Title.textColor = UIColor.black
        }
        
        //此为最左侧imageView距离cell.contentView的左边距
        cell.lead_Space.constant = CGFloat((model.tier > 1 ? 20 : 15) * model.tier)
        //重置cell箭头指向(cell重用会导致箭头指向混乱)
        resetImageArrow(view: cell.imgv_Left, model: model)
        
        return cell
    }
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.baseArr[indexPath.row] as! MRC_ItemModel
        let cell = tableView.cellForRow(at: indexPath) as! MRC_ItemCell
        //交于父类处理，请求在父类
        loadingProcess(model: model, cell: cell)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //若果是自己的数组,直接修改父类数组名称为自己的数组,搜索MRC_BaseList类,全部替换
       return self.baseArr.count
    }
}

