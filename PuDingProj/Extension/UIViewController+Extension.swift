//
//  UIViewController+Extension.swift
//  PuDingProj
//
//  Created by cho on 4/22/24.
//

import UIKit

extension UIViewController {
    func moveToAView() {
            guard let navigationController = navigationController else {
                print("This view controller is not embedded in a navigation controller.")
                return
            }
        navigationController.present(LoginViewController(), animated: true, completion: nil)

        }
    
    func showAlert(title: String, messgae: String, action: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: messgae, preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "작성 취소", style: .destructive, handler: action)
        let postKeep = UIAlertAction(title: "계속 작성하기", style: .default)
        
        alert.addAction(cancel)
        alert.addAction(postKeep)
        
        present(alert, animated: true)
    }
    
    
    func setAlertDelete(title: String, message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "삭제", style: .destructive) { _ in
            action()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}
