//
//  ViewController.swift
//  Project68
//
//

import UIKit

typealias Addr = (addr:String,city:String,name:String)
class ViewController:AccordionTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let records = [
        [
            [   Addr(addr:"Japan",city:"Tokyo",name:"name1"),
                Addr(addr:"Japan",city:"Tokyo",name:"name2"),
                Addr(addr:"Japan",city:"Tokyo",name:"name3")],
            [   Addr(addr:"Japan",city:"Osaka",name:"name4"),
                Addr(addr:"Japan",city:"Osaka",name:"name5"),
                Addr(addr:"Japan",city:"Osaka",name:"name6")]
            ],
        [   [   Addr(addr:"China",city:"Beijing",name:"name7"),
                Addr(addr:"China",city:"Beijing",name:"name8"),
                Addr(addr:"China",city:"Beijing",name:"name9")],
            [   Addr(addr:"China",city:"Shanghai",name:"name10"),
                Addr(addr:"China",city:"Shanghai",name:"name11")]]
        ]
        self.setRecords(records)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

    }
    override func didSelectData( _ data:Any ){
        print(data)
    }
    override func cellFor( _ data:Any , level:Int, indexPath:IndexPath, tableView:UITableView , isOpen:Bool ) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let data = data as? Addr else { abort() }
        let padding = String(repeating: " ", count: level)
        let open = isOpen ? "v" : "^"
        switch level {
            case 0:
                cell.textLabel?.text = padding + data.addr + ":\(open)"
            case 1:
                cell.textLabel?.text = padding + data.city + ":\(open)"
            default:
                cell.textLabel?.text = padding + data.name
        }
        return cell
    }
}
