//
//  MRC_BaseList.swift
//  OpenColseList
//
//  Created by william on 2022/3/14.
//

import Foundation
import UIKit

class MRC_BaseList : UIViewController{
    
    var baseModel : MRC_ItemModel!              //第一层model
    var arr_AnimationCell : [Int] = Array()     //要做展开或闭合动画的index数组
    var baseArr : [Any] = []                    //数据数组
    var isShowEmptyCell : Bool = true           //没有子层时,是否展示空cell
    weak var baseTbv : UITableView!             //tableview
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    func resetImageArrow(view : UIView,model:MRC_ItemModel){
        view.transform = .identity
        if model.isAlert == false &&
           model.isOpen == true{
            view.transform = view.transform.rotated(by: CGFloat(Double.pi/2.0))
        }
    }
    
    func didSelect_ItemWithModel(model : MRC_ItemModel,cell : MRC_ItemCell){
        //如果当前层是末层提示层,直接返回
        if model.isAlert{
            return
        }
        if self.isShowEmptyCell == false &&
            model.items.count == 0{
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
            
            if (model.items.count == 0 &&
                isShowEmptyCell == true){
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
    
    //确定当前列表数量
    func getCurrentListCount(model : MRC_ItemModel){
        if model.topModelIsShow == true{
            self.baseArr.append(model)
        }else{
            model.isOpen = true
        }
        
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
