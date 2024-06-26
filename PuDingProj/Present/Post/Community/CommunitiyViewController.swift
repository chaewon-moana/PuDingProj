//
//  CommunitiyViewController.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CommunitiyViewController: BaseViewController, UIScrollViewDelegate {
    let mainView = CommunitiyView()
    let viewModel = CommunityViewModel()
    
    let textField: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "키워드를 검색해보세요"
        return view
    }()
    var list: [inqueryPostModel] = []
    var postList = PublishRelay<[inqueryPostModel]>()
    var inputTrigger = PublishRelay<Void>()
    var paginationTrigger = PublishRelay<Void>()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.accept(())
        print("community input Trigger")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainView.tableView.register(CommunityTableViewCell.self, forCellReuseIdentifier: "CommunityTableViewCell")
        navigationItem.titleView = textField
        tabBarController?.tabBar.isHidden = false
        
        postList
            .bind(to: mainView.tableView.rx.items(cellIdentifier: "CommunityTableViewCell", cellType: CommunityTableViewCell.self)) { (index, item, cell) in
                cell.updateUI(item: item)
                cell.layoutIfNeeded()
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.willDisplayCell
            .subscribe(with: self) { owner, event in
                if(event.indexPath.row == owner.list.count - 1) && owner.viewModel.nextCursor.value != "0" {
                    owner.paginationTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)

//        mainView.tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
    }
    override func bind() {
        let input = CommunityViewModel.Input(inputTrigger: inputTrigger,
                                             searchText: textField.rx.text.orEmpty.asObservable(),
                                             searchButtonTapped: textField.rx.searchButtonClicked.asObservable(),
                                             postSelected: mainView.tableView.rx.modelSelected(inqueryPostModel.self),
                                             pagination: paginationTrigger.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.inputTrigger
            .subscribe(with: self) { owner, model in
                owner.list = model
                owner.postList.accept(owner.list)
            }
            .disposed(by: disposeBag)
        
        output.inqueryResult
            .subscribe(with: self) { owner, model in
                owner.list = model
                owner.postList.accept(owner.list)
            }
            .disposed(by: disposeBag)
        
        output.specificPost
            .subscribe(with: self) { owner, model in
                owner.list = [model]
                owner.mainView.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.moveToDetail
            .subscribe(with: self) { owner, model in
                let vc = PostDetailViewController()
                //TODO: 왜 이걸 해줘야,,,되는건가,,?
                vc.hidesBottomBarWhenPushed = true
                vc.item = model
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    override func loadView() {
        view = mainView
    }
}

