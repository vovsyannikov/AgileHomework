//
//  ContentView.swift
//  AgileHomework
//
//  Created by Виталий Овсянников on 27.11.2020.
//

import SwiftUI

struct ContentView: View {
    
    @State var resultText: String = ""
    @State var resultColor: Color = .red
    
    @State var login: String = ""
    @State var loginIsCorrect: Bool = false
    
    @State var password: String = ""
    @State var passwordIsCorrect: Bool = false
    
    var disableButton: Bool { (login.isEmpty || password.isEmpty) }
    var buttonOpacity: Double { disableButton ? 0.25 : 1.0 }
    
    func evalutePasswordResult(_ result: [PasswordError]){
        resultText = "Проверьте пароль. Добавьте: "
        for error in result {
            switch error {
            case .noNumber: resultText.append("Число, ")
            case .noLowerCaseLetter: resultText.append("Строчную букву, ")
            case .noUpperCaseLetter: resultText.append("Заглавную букву, ")
            case .tooShort: do {
                let addCounter = 6 - password.count
                resultText.append("\(addCounter) ")
                if addCounter == 1 { resultText.append("знак, ") }
                else if addCounter == 2
                            || addCounter == 3
                            || addCounter == 4 {
                    resultText.append("знака, ")
                }
                else { resultText.append("знаков, ")}
            }
            }
        }
        resultText = "\(resultText.dropLast(2))"
        
        if result.isEmpty { passwordIsCorrect = true }
        else { passwordIsCorrect = false }
    }
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            // MARK: Top labels
            Text("Войти в систему")
                .font(.title2)
                .padding(5)
            
            if !resultText.isEmpty{
                Text(resultText)
                    .foregroundColor(resultColor)
                    .padding(5)
            }
            
            // MARK: Login section
            HStack {
                Image(systemName: "person.fill")
                    .frame(width: 30.0, height: 30.0)
                    .foregroundColor(.green)
                TextField("Почта", text: $login)
                    .modifier(ClearButton(type: "lc", text: $login))
                    .padding(5)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                
            }
            .padding(.horizontal, 50)
            
            // MARK: Password section
            HStack {
                Image(systemName: "lock.fill")
                    .frame(width: 30, height: 30)
                    .foregroundColor(.green)
                TextField("Пароль", text: $password, onEditingChanged: { _ in
                    print(login.isEmpty, password.isEmpty)
                })
                .modifier(ClearButton(type: "pc", text: $password))
                .padding(5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
            }
            .padding(.horizontal, 50)
            
            //MARK: Button
            Button (action: {
                let loginCheckPassed = Authentication.loginIsCorrect(for: login)
                let passwordCheckResult = Authentication.passwordIsStrong(for: password)
                
                if loginCheckPassed && passwordCheckResult.isEmpty {
                    resultColor = .green
                    resultText = "Успешный вход"
                } else {
                    resultColor = .red
                    if !loginCheckPassed {
                        resultText = "Проверьте почту"
                    }
                    
                    if !passwordCheckResult.isEmpty {
                        evalutePasswordResult(passwordCheckResult)
                    }
                }
            }) {
                Text("Войти")
                    .fontWeight(.semibold)
                    .font(.title2)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(Color.blue)
                    .cornerRadius(40)
                    .foregroundColor(.white)
                    .padding(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(Color.blue, lineWidth: 5)
                    )
                    .animation(.easeInOut)
            }
            .padding(.top, 15)
            .disabled(disableButton)
            .opacity(buttonOpacity)
        }
        
    }
    
}

// MARK: - ClearButton modifier
struct ClearButton: ViewModifier{
    var type: String
    @Binding var text: String
    
    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content
            
            if !text.isEmpty
            {
                Button(action: { self.text = ""} )
                {
                    Text(type)
                        .font(.footnote)
                        .fontWeight(.ultraLight)
                        .foregroundColor(.white)
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}

// MARK: -
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
