//
//  SideMenuVC.swift
//  DAZZLE AND BLOOM
//
//  Created by MacBook Pro on 20/12/22.
//

import UIKit

protocol SideMenuVCDelegate {
    func selectedCell(_ row: Int)
}

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet var sideMenuTableView: UITableView!

    var delegate: SideMenuVCDelegate?

    var defaultHighlightedCell: Int = 0
    
    var menu = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.menu = ["Home","Men","Women","Accessories","Kids","About Us","Contact"]

        // TableView
        self.sideMenuTableView.delegate = self
        self.sideMenuTableView.dataSource = self
        self.sideMenuTableView.separatorStyle = .none

        // Set Highlighted Cell
        DispatchQueue.main.async {
            let defaultRow = IndexPath(row: self.defaultHighlightedCell, section: 0)
            self.sideMenuTableView.selectRow(at: defaultRow, animated: false, scrollPosition: .none)
        }
        
        self.sideMenuTableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")

        // Update TableView with the data
        self.sideMenuTableView.reloadData()
        
        
        bgView.setOnClickListener {
            self.dismiss(animated: true) {
                self.delegate?.selectedCell(0)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension SideMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

// MARK: - UITableViewDataSource

extension SideMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell") as! SideMenuCell

        cell.titleLabel.text = self.menu[indexPath.row]
        cell.selectionStyle = .none
        
        if indexPath.row == 5 || indexPath.row == 6 {
            cell.externalLink.isHidden = false
        }else{
            cell.externalLink.isHidden = true
        }

        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Remove highlighted color when you press the 'Profile' and 'Like us on facebook' cell
        self.dismiss(animated: true) {
            self.delegate?.selectedCell(indexPath.row)
        }
    }
}
