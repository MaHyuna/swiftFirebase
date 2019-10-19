//
//  ListViewController.swift
//  MyFirebase
//
//  Created by maro on 28/09/2019.
//  Copyright © 2019 마현아. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

// 파이어베이스 DB에 들어갈 수 있는 데이터 구조
// NSNumber, NSString, MSDictionary, NSArray만 들어갈 수 있다.
// Struct, Class, Enum -> 바로 못들어감, Dictionary로 바꿔서 들어간다.
class ListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var idolArray: Array<IdolData> = []
    
    struct IdolData {
        var name: String = ""
        var imageStr: String = ""
        
        func getDic() -> [String: String] {
            let dic = [
                "name": self.name
                ,"imageStr": self.imageStr
            ]
            
            return dic
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    @IBAction func onBtnAdd(_ sender: UIButton) {
        setValueIntoList()
    }
    
    @IBAction func onBtnRead(_ sender: UIButton) {
        getValueFormList()
    }
    
    //MARK: -Datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.idolArray.count
    }
    
    //MARK: -Delegate
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell
        
        let idolStruct = self.idolArray[indexPath.row]
        cell.labelName.text = idolStruct.name
        cell.imageView.image = UIImage(named: idolStruct.imageStr)
        
        return cell
    }
    
    func getValueFormList() {
        // 구조체 배열을 비우기
        idolArray.removeAll()
        
        let db = Firestore.firestore()
        
        db.collection("idols").whereField("name", isEqualTo: "포켓몬").getDocuments() {    // isEqualTo 똑같은 것
        //db.collection("idols").whereField("name", isGreaterThan: "포켓몬").getDocuments() {    // 포함하고 있는 것
        //db.collection("idols").getDocuments() {
            (querySnapshot, err) in
            if let error = err {
                print("DB읽기 실패", error)
            }else {
                print("DB읽기 성공!")
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let dataDic = document.data() as NSDictionary
                    let name = dataDic["name"] as? String ?? ""         // dataDic[]가 nil 이면 빈값 ""으로 대체한다.
                    print("name: ", name)
                    
                    let imageStr = dataDic["imageStr"] as? String ?? ""
                    print("imageStr: ", imageStr)
                    
                    // dic을 struct로 바꿔서 배열로 넣어줌
                    var idol = IdolData()
                    idol.name = name
                    idol.imageStr = imageStr
                    
                    self.idolArray.append(idol)
                }
                
                // 데이터 읽기가 다 끝난 후, 콜렉션뷰를 리로드 함
                self.collectionView.reloadData()
            }
        }
    }
    
    func setValueIntoList() {
        var idol = IdolData()
        idol.name = "포켓몬_01"
        idol.imageStr = "p_img01.png"
        
        let dic = idol.getDic()
        let db = Firestore.firestore()
        
        var ref: DocumentReference? = nil
        ref = db.collection("idols").addDocument(data: dic) {
            // 후행 클로저
            
            err in
            if let error = err {
                print("DB 쓰기 에러발생", error)
            }else {
                print("DB 쓰기 성공!", ref!.documentID)
            }
        }
    }
    
    // 셀의 사이즈를 정해줌
    func collectionvView(_ collectionView: UICollectionView, layoutCollectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewCellWidth = collectionView.frame.width / 2
        
        return CGSize(width: collectionViewCellWidth, height: collectionViewCellWidth)
    }
    
    // 위, 아래 간격
    func collectionvView(_ collectionView: UICollectionView, layoutCollectionViewLayout: UICollectionViewLayout, minimuLineSpaceForSectionAsection: Int) -> CGFloat {
        
        return 1
    }
    
    // 옆라인 간경
    func collectionvView(_ collectionView: UICollectionView, layoutCollectionViewLayout: UICollectionViewLayout, minimuInteritemSpacionForSectionAt section: Int) -> CGFloat {
    
        return 1
    }

}

