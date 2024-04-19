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
    
//    var list: [RegisterPost] = [
//        RegisterPost(post_id: "123", product_id: "productId", title: "하이하234이", content: "냉무", content1: "분류", createdAt: "2022.22.22", creator: CreatorInfo(user_id: "1", nick: "모아나", prifileImage: nil)),
//        RegisterPost(post_id: "123", product_id: "productId", title: "하이2344하이", content: "냉무", content1: "분류", createdAt: "2022.22.22", creator: CreatorInfo(user_id: "2", nick: "그리드", prifileImage: nil)),
//        RegisterPost(post_id: "123", product_id: "productId", title: "하23444이하이", content: "냉무", content1: "분류", createdAt: "2022.22.22", creator: CreatorInfo(user_id: "3", nick: "짹", prifileImage: nil)),
//        RegisterPost(post_id: "123", product_id: "productId", title: "하이2342342하이", content: "냉무", content1: "분류", createdAt: "2022.22.22", creator: CreatorInfo(user_id: "4", nick: "덴", prifileImage: nil))
//    ]
    
    let textField: UISearchBar = {
        let view = UISearchBar()
        view.placeholder = "텍스트필드 여기있따아아"
        return view
    }()
    var list: [inqueryPostModel] = [] {
        didSet {
            mainView.collectionView.reloadData()
        }
    }
    var inputTrigger: () = ()
    override func loadView() {
        view = mainView

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inputTrigger = ()
        print("input trigger 발동")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
        mainView.collectionView.register(CommunityCollectionViewCell.self, forCellWithReuseIdentifier: "CommunityCollectionViewCell")
        navigationItem.titleView = textField
        
    }
    
    override func bind() {
        let inputTriggerObservable = Observable.just(inputTrigger)
        
        let input = CommunityViewModel.Input(inputTrigger: inputTriggerObservable)
        
        let output = viewModel.transform(input: input)
        
        output.inqueryResult
            .subscribe(with: self) { owner, model in
                owner.list = model.data
                owner.mainView.collectionView.reloadData()
            }
            .disposed(by: disposeBag)
    }
    
}


extension CommunitiyViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommunityCollectionViewCell", for: indexPath) as! CommunityCollectionViewCell
        let item = list[indexPath.item]
        cell.backgroundColor = .green
        cell.updateUI(item: item)
        return cell
    }
}

