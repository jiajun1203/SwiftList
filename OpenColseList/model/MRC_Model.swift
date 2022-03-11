//
//  MRC_Model.swift
//  OpenColseList
//
//  Created by William on 2022/3/11.
//

import Foundation
class MRC_ItemModel : NSObject{
    // 主要参数 ,去掉会导致列表开合出错
    var isOpen : Bool = false           //当前是否为展开状态
    var isShowAnimation : Bool = false  //与当前模型对应cell是否要做开合动画
    var isAlert : Bool = false          //  没有下级时的提示状态
    var items : [MRC_ItemModel] = []    //数据源,需要时改成自己的model类型即可,属性名称改成后台返回,全局搜索替换即OK
    
    //次要参数,去留无关紧要
    var tier : Int = 1
    var title : String? = "这是层级（1）"
    var tag : NSInteger = 0
    
    
    func initSubs(){
        if self.tier < 6 {
            let arr = Array.init(repeating: 1, count: 2)
            var idx : NSInteger = 0
            for _ in arr {
                idx += 1
                let item = MRC_ItemModel()
                item.tier = self.tier + 1
                item.tag = item.tag + idx;
                item.title = "这是层级（\(item.tier)currentValue->\(item.tag)）"
                item.initSubs()
                self.items.append(item)
            }
        }
    }
}
