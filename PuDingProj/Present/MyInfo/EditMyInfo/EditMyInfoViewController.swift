//
//  EditMyInfoViewController.swift
//  PuDingProj
//
//  Created by cho on 4/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

final class EditMyInfoViewController: BaseViewController {
    var item: InqueryProfileModel?
    let viewModel = EditMyInfoViewModel()
    let mainView = EditMyInfoView()
    var trigger: () = ()
    var imageData = PublishRelay<Data?>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trigger = ()
    }
    
    private func setImage() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .any(of: [.images])
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true)
    }
    override func loadView() {
        view = mainView
    }
    
    override func bind() {
        let inputTrigger = Observable.of(trigger)
        //let editImage = BehaviorRelay(value: imageData)
        let infoResult = Observable.combineLatest(mainView.nicknameTextField.rx.text.orEmpty, mainView.phoneNumTextField.rx.text.orEmpty, imageData)
        
        let input = EditMyInfoViewModel.Input(inputTrigger: inputTrigger,
                                              editImageButtonTapped: mainView.editImageButton.rx.tap.asObservable(), editImageResult: infoResult,
                                              editDoneButtonTapped: mainView.button.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        
        output.inputTrigger
            .subscribe(with: self) { owner, _ in
                owner.mainView.updateUI(data: owner.item!)
            }
            .disposed(by: disposeBag)
        
        output.editImageButtonTapped
            .subscribe(with: self) { owner, _ in
                owner.setImage()
            }
            .disposed(by: disposeBag)
        }

    
}

extension EditMyInfoViewController: PHPickerViewControllerDelegate {
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            let itemProvider = results.first?.itemProvider
    
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { photo, error in
                    DispatchQueue.main.async { [self] in
                        let image = photo as? UIImage
                        let data = image?.jpegData(compressionQuality: 0.1)
                        self.mainView.profileImageView.image = image
                        self.imageData.accept(data)
                    }
                }
            } else {
                print(#function, "이미지 입력에 문제생김!!!!")
            }
        }
}
