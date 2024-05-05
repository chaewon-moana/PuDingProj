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
    lazy var addButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: nil, action: nil)
    
    var list: [inqueryFundingModel] = []
    var fundingList = PublishRelay<[inqueryFundingModel]>()
    var inputTrigger = PublishRelay<Void>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fundingList.accept(list)
        inputTrigger.accept(())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = addButton
        mainView.tableView.register(FundingTableViewCell.self, forCellReuseIdentifier: "FundingTableViewCell")
        view.backgroundColor = .white
        
        fundingList
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "FundingTableViewCell", cellType: FundingTableViewCell.self)) { (index, item, cell) in
                cell.updateUI(item: item)
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.contentOffset
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let tableView = self?.mainView.tableView else { return .empty() }
                guard let self = self else { return .empty() }
                let visibleHeight = tableView.frame.height - tableView.contentInset.top - tableView.contentInset.bottom
                let yOffset = contentOffset.y + tableView.contentInset.top
                let distanceToBottom = tableView.contentSize.height - yOffset - visibleHeight
                if distanceToBottom < 300, !self.viewModel.isLoading.value {
                    return .just(())
                }
                return .empty()
            }
            .subscribe(with: self, onNext: { owner, _ in
                if owner.viewModel.nextCursor.value != "0" {
                    owner.viewModel.fetchNextPage()
                }
            })
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.modelSelected(inqueryFundingModel.self)
            .subscribe(with: self) { owner, model in
                let vc = SponsorViewController()
                vc.item = model
                vc.hidesBottomBarWhenPushed = true
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
    override func bind() {
        let input = FundingViewModel.Input(fundingAddButton: addButton.rx.tap.asObservable(), inputTrigger: inputTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.fundingAddButton
            .drive(with: self) { owner, _ in
                let vc = FundingDetailViewController()
                owner.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.inqueryFunding
            .subscribe(with: self) { owner, model in
                owner.list = model
                owner.fundingList.accept(owner.list)
                owner.mainView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
    }


}
