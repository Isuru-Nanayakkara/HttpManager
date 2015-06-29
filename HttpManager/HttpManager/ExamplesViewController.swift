//
//  ExamplesViewController.swift
//  HttpManager
//
//  Created by Isuru Nanayakkara on 6/29/15.
//  Copyright (c) 2015 BitInvent. All rights reserved.
//

import UIKit

class ExamplesViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            let url = "http://httpbin.org/get"
            
            HttpManager.get(url).execute({ (result, error) -> () in
                println(result)
            })
            
        case 1:
            let url = "http://httpbin.org/get"
            let params = ["show_env": 1]
            
            HttpManager.get(url).parameters(params).execute({ (result, error) -> () in
                println(result)
            })
            
        case 2:
            let url = "http://httpbin.org/headers"
            let header = ["X-Custom-Header": "Hello World"]
            
            HttpManager.get(url).headers(header).execute({ (result, error) -> () in
                println(result)
            })
            
        case 3:
            let url = "http://httpbin.org/post"
            HttpManager.post(url).execute({ (result, error) -> () in
                println(result)
            })
            
        case 4:
            let url = "http://httpbin.org/post"
            let bodyData = ["now": NSDate()]
            HttpManager.post(url).data(bodyData).execute({ (result, error) -> () in
                println(result)
            })
            
        default:
            break
        }
    }

}
