//
//  CommunitiyViewController.swift
//  PuDingProj
//
//  Created by cho on 4/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class CommunitiyViewController: BaseViewController {
    let mainView = CommunitiyView()
    let viewModel = CommunityViewModel()
    
    let textField: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "텍스트필드 여기있따아아"
        return view
    }()
    var list: [inqueryPostModel] = []
    var postList = PublishRelay<[inqueryPostModel]>()
    var inputTrigger = PublishRelay<Void>()
    var isFetchingNextPage = false
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
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.fetchNextPage()
            })
            .disposed(by: disposeBag)
    }
    override func bind() {
        
        
        let input = CommunityViewModel.Input(inputTrigger: inputTrigger,
                                             searchText: textField.rx.text.orEmpty.asObservable(),
                                             searchButtonTapped: textField.rx.searchButtonClicked.asObservable(),
                                             postSelected: mainView.tableView.rx.modelSelected(inqueryPostModel.self)
        )
        
        let output = viewModel.transform(input: input)
        
        output.inqueryResult
            .subscribe(with: self) { owner, model in
                owner.list = model
                owner.postList.accept(owner.list)
                owner.mainView.tableView.reloadData()
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
                //TODO: TabBarController가
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

