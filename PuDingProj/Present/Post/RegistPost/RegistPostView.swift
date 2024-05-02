//
//  RegistPostView.swift
//  PuDingProj
//
//  Created by cho on 4/18/24.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

final class RegistPostView: BaseView {
    let categoryButton = UIButton()
    let titleTextView = UITextView()
    let underLineView = UIView()
    let contentTextView = UITextView()
    let separateLineView = UIView()
    let addImageButton = UIButton()
    lazy var imageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    let disposeBag = DisposeBag()
    
    let titleTextPlaceHolder: UILabel = {
        let view = UILabel()
        view.text = "제목을 입력해주세요"
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 17, weight: .bold)
        return view
    }()
    let contentTextPlaceHolder: UILabel = {
        let view = UILabel()
        view.text = "내용을 입력해주세요. \n사진은 최대 5장까지 가능합니다 \n#으로 태그를 남겨보세요"
        view.numberOfLines = 0
        view.textColor = .lightGray
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let itemWidth: CGFloat = 130
        let itemHeight: CGFloat = 140
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 0)
        return layout
    }
    
    func setInitView() {
        categoryButton.setTitle("카테고리를 선택해주세요", for: .normal)
        contentTextView.text = ""
        contentTextPlaceHolder.isHidden = false
        titleTextView.text = ""
        titleTextPlaceHolder.isHidden = false
        titleTextView.becomeFirstResponder()
    }
    override func configureAttribute() {
        categoryButton.setTitle("카테고리를 선택해주세요", for: .normal)
        categoryButton.titleLabel?.font = .systemFont(ofSize: 14)
        categoryButton.layer.cornerRadius = 8
        categoryButton.layer.borderColor = UIColor.lightGray.cgColor
        categoryButton.layer.borderWidth = 1
        categoryButton.backgroundColor = .systemGray6
        categoryButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        categoryButton.setTitleColor(.black, for: .normal)
        
        titleTextView.backgroundColor = .white
        titleTextView.textColor = .black
        titleTextView.font = .systemFont(ofSize: 17, weight: .bold)
        titleTextView.delegate = self
        titleTextView.isScrollEnabled = false
        
        underLineView.layer.borderWidth = 0.5
        underLineView.backgroundColor = .systemGray6
        underLineView.layer.borderColor = UIColor.clear.cgColor
        
        separateLineView.layer.borderWidth = 0.5
        separateLineView.backgroundColor = .lightGray
        separateLineView.layer.borderColor = UIColor.clear.cgColor
        
        contentTextView.backgroundColor = .white
        contentTextView.textColor = .black
        contentTextView.font = .systemFont(ofSize: 15)
        contentTextView.delegate = self
        contentTextView.isScrollEnabled = false

        addImageButton.setImage(UIImage(systemName: "camera.circle"), for: .normal)
        addImageButton.setTitle("사진", for: .normal)
        addImageButton.setTitleColor(.black, for: .normal)
        addImageButton.titleLabel?.font = .systemFont(ofSize: 13)
        addImageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 4)
        addImageButton.tintColor = .lightGray
    }
    
    override func configureViewLayout() {
        self.addSubviews([categoryButton, titleTextView, underLineView, contentTextView, addImageButton, separateLineView, imageCollectionView])
        titleTextView.addSubview(titleTextPlaceHolder)
        contentTextView.addSubview(contentTextPlaceHolder)
        
        categoryButton.snp.makeConstraints { make in
            make.leading.top.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(40)
            make.width.greaterThanOrEqualTo(50)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(categoryButton.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(40)
        }
        
        titleTextPlaceHolder.snp.makeConstraints { make in
            make.top.equalTo(titleTextView).offset(8)
            make.leading.equalTo(titleTextView.snp.leading).offset(8)
        }
        underLineView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(titleTextView.snp.bottom).offset(4)
            make.height.equalTo(1)
        }
        contentTextView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(12)
            make.top.equalTo(underLineView.snp.bottom).offset(12)
            make.height.equalTo(140)
        }
        contentTextPlaceHolder.snp.makeConstraints { make in
            make.top.leading.equalTo(contentTextView).offset(8)
        }
        imageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom)
            make.height.equalTo(150)
            make.horizontalEdges.equalTo(self.safeAreaLayoutGuide).inset(8)
        }
        separateLineView.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-30)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(separateLineView.snp.bottom).offset(4)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(28)
            make.width.greaterThanOrEqualTo(50)
        }
    }
}

extension RegistPostView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            titleTextPlaceHolder.isHidden = !titleTextView.text.isEmpty
        } else if textView == contentTextView {
            contentTextPlaceHolder.isHidden = !contentTextView.text.isEmpty
        }
    }
}
