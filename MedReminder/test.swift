//
//  test.swift
//  MedReminder
//
//  Created by TA622 on 14.03.26.
//
import SwiftUI

struct TestView: View {
    var body: some View {
        ZStack{
            Color(red: 0x21/255, green: 0x9E/255, blue: 0xBC/255)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                Text("MedReminder")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
            }
        }
    }
}
#Preview {
    TestView()
}


//Könnt ihr ignorieren, ich mache das Intro weiter
