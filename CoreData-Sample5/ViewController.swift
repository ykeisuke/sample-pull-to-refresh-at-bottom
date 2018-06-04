//
//  ViewController.swift
//  CoreData-Sample5
//
//  Created by Keisuke Yamaguchi on 2018/06/04.
//  Copyright © 2018年 Keisuke Yamaguchi. All rights reserved.
//

import UIKit

private let PageSize = 20

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var dataSourceCount = PageSize

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        tableView.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Scroll view in table view
    var isLoadingMore = false

}

extension ViewController: UITableViewDelegate {

    // https://stackoverflow.com/questions/27190848/how-to-show-pull-to-refresh-element-at-the-bottom-of-the-uitableview-in-swift
    //func scrollViewDidScroll(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        // Use this 'canLoadFromBottom' variable only if you want to load from bottom iff content > table size
        let contentSize = scrollView.contentSize.height
        let tableSize = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
        let canLoadFromBottom = contentSize > tableSize

        // Offset
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let difference = maximumOffset - currentOffset

        // Difference threshold as you like. -120.0 means pulling the cell up 120 points
        if canLoadFromBottom, difference <= -120.0 {

            // When view is loading
            if (self.isLoadingMore == false) {
                
                // Save the current bottom inset
                
                // Add 50 points to bottom inset, avoiding it from laying over the refresh control.
                let previousScrollViewBottomInset = scrollView.contentInset.bottom
                scrollView.contentInset.bottom = previousScrollViewBottomInset + 50

                self.isLoadingMore = true

                // loadMoreData function call
                // original:
                // loadMoreDataFunction(){ result in
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
                    // Reset the bottom inset to its original value
                    scrollView.contentInset.bottom = previousScrollViewBottomInset
                    self.isLoadingMore = false
                }
                //}
            }
        }
    }

}


extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\((indexPath as NSIndexPath).row)"
        return cell
    }
}
