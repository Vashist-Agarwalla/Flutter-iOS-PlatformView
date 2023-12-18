//
//  SwiftUIView.swift
//  Runner
//
//  Created by Vashist Agarwalla on 15/12/23.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        ZStack {
            Image("Horse")
                .resizable()
                .frame(width: 300, height: 200)
            Button {
                EventHandler.eventHandlerInstance.sendEvent("ButtonClickedEvent")
            } label: {
                Text("Get Battery")
            }
            .accentColor(.black)
            .padding()
            .background(Color.blue)
            .cornerRadius(7)
        }
    }
}

#Preview {
   SwiftUIView()
}
