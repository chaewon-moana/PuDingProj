//
//  PostDetailViewController.swift
//  PuDingProj
//
//  Created by cho on 4/20/24.
//

import UIKit
import RxSwift
import RxCocoa

final class PostDetailViewController: BaseViewController {
    let mainView = PostDetailView()
    let viewModel = PostDetailViewModel()
    var item: inqueryPostModel?
    
    lazy var backButton: UIBarButtonItem = {
        let view = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: nil)
    return view
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = backButton
    }
    
    override func bind() {
        let input = PostDetailViewModel.Input(postItem: Observable.of(item!),
                                              backButtonTapped: backButton.rx.tap.asObservable(),
                                              commentSendButtonTapped: mainView.commentSendButton.rx.tap.asObservable(),
                                              commentText: mainView.commentTextView.rx.text.orEmpty.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.postResult
            .subscribe(with: self) { owner, model in
                owner.mainView.updateUI(item: model)
            }
            .disposed(by: disposeBag)
        
        output.backButtonTapped
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}
