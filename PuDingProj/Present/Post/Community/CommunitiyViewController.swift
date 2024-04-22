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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger.accept(())
        print("community input Trigger")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainView.collectionView.register(CommunityCollectionViewCell.self, forCellWithReuseIdentifier: "CommunityCollectionViewCell")
        navigationItem.titleView = textField
        postList
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "CommunityCollectionViewCell", cellType: CommunityCollectionViewCell.self)) { (index, item, cell) in
                cell.backgroundColor = .green
                cell.updateUI(item: item)
                cell.sizeThatFits(cell.intrinsicContentSize)
            }
            .disposed(by: disposeBag)
    }
    
    override func bind() {
        
        let input = CommunityViewModel.Input(inputTrigger: inputTrigger,
                                             searchText: textField.rx.text.orEmpty.asObservable(),
                                             searchButtonTapped: textField.rx.searchButtonClicked.asObservable(),
                                             postSelected: mainView.collectionView.rx.modelSelected(inqueryPostModel.self)
        )
        
        let output = viewModel.transform(input: input)
        
        output.inqueryResult
            .subscribe(with: self) { owner, model in
                owner.list = model.data
                owner.postList.accept(model.data)
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.specificPost
            .subscribe(with: self) { owner, model in
                owner.list = [model]
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
        
        output.moveToDetail
            .subscribe(with: self) { owner, model in
                let vc = PostDetailViewController()
                vc.item = model
                owner.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        inputTrigger
            .flatMap { value in
                return NetworkManager.requestNetwork(router: .post(.inqueryPost), modelType: inqueryUppperPostModel.self)
            }
            .subscribe { model in
                print("포스트 조회 서엉고옹")
                print(model)
                //result.accept(model)
            } onError: { error in
                print("포스트 조회 실패애")
            }
            .disposed(by: disposeBag)
    }
    override func loadView() {
        view = mainView
    }
}
