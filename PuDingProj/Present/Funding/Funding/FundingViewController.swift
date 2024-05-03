//
//  FundingViewController.swift
//  PuDingProj
//
//  Created by cho on 4/29/24.
//

import UIKit
import RxSwift
import RxCocoa

struct Funding {
    let product: String
    let dueDate: String
    let hostShelter: String
    let productName: String
    let attainment: String
    let price: String
    
}

class FundingViewController: BaseViewController {

    let mainView = FundingView()
    let viewModel = FundingViewModel()
    
    var list: [Funding] = [Funding(product: "111111", dueDate: "111111", hostShelter: "111111", productName: "111111", attainment: "111111", price: "111111")]
    var fundingList = PublishRelay<[Funding]>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fundingList.accept(list)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.tableView.register(FundingTableViewCell.self, forCellReuseIdentifier: "FundingTableViewCell")
        view.backgroundColor = .white
//        
        fundingList
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "FundingTableViewCell", cellType: FundingTableViewCell.self)) { (index, item, cell) in
                cell.attainmentLabel.text = item.attainment
                cell.dueDateLabel.text = item.dueDate
                cell.productNameLabel.text = item.productName
                cell.productImageView.image = UIImage(systemName: "star")
                cell.hostShelterLabel.text = item.hostShelter
                cell.priceLabel.text = item.price
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }


}
