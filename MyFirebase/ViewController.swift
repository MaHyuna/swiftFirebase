//
//  ViewController.swift
//  MyFirebase
//
//  Created by maro on 22/09/2019.
//  Copyright © 2019 마현아. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet weak var labelLogin: UILabel!
    @IBOutlet weak var textfieldID: UITextField!
    @IBOutlet weak var textfieldPW: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    // 로그인 버튼
    @IBAction func onBtnLogin(_ sender: Any) {
        if let textID = textfieldID.text, let textPW = textfieldPW.text {
            if textID.count < 1 || textPW.count < 6 {
                print( "아이디나 암호의 길이가 짧습니다." )
                return
            }
            
            Auth.auth().signIn(withEmail: textID, password: textPW) {
                (authResult, error) in
                switch error {
                case .some(let error as NSError) where error.code == AuthErrorCode.wrongPassword.rawValue:
                    print( "wrong Password" )
                case .some(let error):
                    print( "Login error: \(error.localizedDescription)" )
                case .none:
                    if let user = authResult?.user {
                        print( "로그인 되었습니다." )
                        print( "\(user.email), \(user.uid)" )
                        self.updateUI()
                    }
                }
                
            }
            
            /*
             // 첫번째로 썼던 방식 위에가 더 개선된 코드
            Auth.auth().signIn(withEmail: textID, password: textPW) {
                [weak self] user, error in
                guard let strongSelf = self else {
                    return
                }
                
                print( "로그인 되었습니다." )
                
                let user = Auth.auth().currentUser
                print("\(user?.email), \(user?.uid)")
                
                self?.updateUI()
            }
            */
        }
    }
    
    // 로그아웃 버튼
    @IBAction func onBtnLogout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            self.updateUI()
            
        } catch let signOutError as NSError {
            print( "로그아웃 실패: ", signOutError )
        }
    }
    
    // 회원가입 버튼
    @IBAction func onBtnJoin(_ sender: Any) {
        if let textID = textfieldID.text, let textPW = textfieldPW.text {
            if textID.count < 1 || textPW.count < 6 {
                print( "아이디나 암호의 길이가 짧습니다." )
                return
            }
            
            Auth.auth().createUser(withEmail: textID, password: textPW) {
                // 후행 클로저
                autnResult, error in
                guard let user = autnResult?.user, error  == nil else {
                        print( error!.localizedDescription )
                    return
                }
                
                print( "\(user.email!) 회원가입 성공" )
            }
        }
    }
    
    // 로그인 여부
    func updateUI() {
        if let user = Auth.auth().currentUser {
            labelLogin.text = "로그인 상태: \(user.email)"
        }else {
            labelLogin.text = "로그인 상태: 로그아웃"
        }
    }
}

