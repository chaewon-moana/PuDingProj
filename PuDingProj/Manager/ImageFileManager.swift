//
//  FileManager.swift
//  PuDingProj
//
//  Created by cho on 4/19/24.
//

import UIKit

final class ImageFileManager {
    static let shared = ImageFileManager()
    
    func saveImageToDocument(imageName: String, image: UIImage) {
        guard let document = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let imageURL = document.appendingPathComponent(imageName)
        
        //이미지 압축
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            print(#function, "압축실패")
            return
        }
        
        if FileManager.default.fileExists(atPath: imageURL.path) {
            do {
                try FileManager.default.removeItem(at: imageURL)
                print("동일 경로 있어서 삭제")
            } catch {
                print("이미지 동일 경로 삭제 실패")
            }
        }
        do {
            print("이미지 돼써!", imageURL)
            try data.write(to: imageURL)
        } catch {
            print("이미지 저장 실패")
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let path = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let directoryPath = path.first {
            // 2. 이미지 URL 찾기
            let imageURL = URL(fileURLWithPath: directoryPath).appendingPathComponent(fileName)
            // 3. UIImage로 불러오기
            return UIImage(contentsOfFile: imageURL.path)
        }
        
        return UIImage(systemName: "x.circle")
    }
}
