//
//  TableTableViewController.swift
//  Project68
//
//  Created by matsubaratomoki on 2020/05/02.
//  Copyright © 2020 com.magnet-magic. All rights reserved.
//

import UIKit

//
//  AccordionTableViewController.swift
//

import UIKit

struct DisplayObject {
    var index:[Int] = []
    var userInfo:Any
}
class AccordionTableViewController: UITableViewController {
    func setRecords( _ data:[Any]){
        self.data = data
        self.array = []
        for( i , value ) in data.enumerated() {
            array.append(DisplayObject(index: [i],userInfo: value))
        }
        self.tableView.reloadData()
    }
    func didSelectData( _ data:Any ){
        
    }
    func cellFor( _ data:Any , level:Int, indexPath:IndexPath, tableView:UITableView , isOpen:Bool ) -> UITableViewCell{
        return UITableViewCell()
    }

    var data:[Any]!
    var array:[DisplayObject] = []
}
extension AccordionTableViewController{

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array.count
    }
    private func deepest( _ list:[Any] ) -> Any {
        if let l = list.first as? [Any] {
            return deepest(l)
        }
        return list.first as Any
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let obj = array[indexPath.row]
        let originalData = indexesOfArray(data, obj.index)
        if let list = originalData as? [Any] {
            return cellFor(deepest(list), level: obj.index.count - 1, indexPath: indexPath, tableView: tableView , isOpen: isOpenedNext(at: indexPath.row))
        }

        return cellFor(obj.userInfo, level: obj.index.count - 1, indexPath:indexPath, tableView: tableView , isOpen: isOpenedNext(at: indexPath.row))
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let obj = array[indexPath.row]
        let originalData = indexesOfArray(data, obj.index)
        var work = 1
        if let list = originalData as? [Any] {
            if isOpenedNext(at:indexPath.row) {
                closeChildren(obj.index)
                self.tableView.reloadRows(at: [indexPath], with: .none)
                return
            }
            var insertedTarget:[IndexPath] = []
            for( i , value ) in list.enumerated() {
                self.array.insert(DisplayObject(index: obj.index + [i] ,userInfo: value), at: indexPath.row + work)
                insertedTarget.append(IndexPath(row: indexPath.row + work, section: 0))
                work += 1
                
            }
            self.tableView.insertRows(at: insertedTarget, with: .fade)
            self.tableView.reloadRows(at: [indexPath], with: .none)

        }else{
            didSelectData(originalData!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    private func indexesOfArray( _ list:[Any] , _ indexes :[Int] ) -> Any? {
        let object = list[indexes.first!]
        if indexes.count == 1 {
            return object
        }else{
            guard let array = object as? [Any] else { fatalError() }
            let newIndexes = indexes.dropFirst(1)
            return indexesOfArray( array ,Array(newIndexes) )
        }
    }
    private func stringIndexes( _ indexes: [Int]) -> String {
        var work:String = ""
        indexes.forEach { (i) in
            work.append(contentsOf: String(format: "%d-", i))
        }
        return work
    }
    private func isOpenedNext( at index:Int ) -> Bool {
        let current = self.array[index]
        if index + 1 >= self.array.count {
            return false
        }
        let next = self.array[index + 1]
        for ( i, _ ) in current.index.enumerated() {
            if next.index.count <= i {
                return false
            }
            if next.index[i] != current.index[i] {
                return false
            }
        }
        return true
    }
    private func closeChildren( _ index:[Int] ){
        var removeTarget:[IndexPath] = []
        for( i , object ) in self.array.enumerated() {
            
            if index.count >= object.index.count {
                continue
            }
            var b = true
            for ( i, _ ) in index.enumerated() {
                if object.index[i] != index[i] {
                    b = false
                    break
                }
            }
            if b {
                removeTarget.append(IndexPath.init(row: i, section: 0))
            }
        }
        removeTarget.reversed().forEach { (indexPath) in
            self.array.remove(at: indexPath.row)
        }
        self.tableView.deleteRows(at: removeTarget, with: .fade)
    }
}
