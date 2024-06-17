//
//  CatRowView.swift
//  CatsAndModules_IrynaNazar
//
//  Created by Ira Nazar on 2024-05-28.
//

import SwiftUI
import Networking
import FirebaseCrashlytics

struct CatRowView: View {
    let animal: Animal
    let index: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Spacer()
                Text(generateRandomName())
                    .bold()
                Text(generateRandomDescription())
                    .padding(8)
                    .background(Color(.systemGray5))
                    .cornerRadius(8)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxHeight: .infinity)
                Spacer()
            }
            Spacer()
            if let url = URL(string: animal.url) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            } else {
                Image(systemName: "Photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .cornerRadius(8)
            }
        }
        .padding()
        
        .onAppear {
            logCatRowAppearance()
//            triggerRowSpecificCrash()
        }
    }
    
    private func generateRandomName() -> String {
        let names = ["Whiskers", "Fluffy", "Tom", "Nilla", "Zesty", "Simba", "Oliver", "Bella", "Shuryk", "Milo", "Luna", "Leo", "Charlie", "Chloe", "Max", "Sophie", "Nala", "Tiger", "Oreo", "Lucy"]
        return names.randomElement() ?? "Unknown"
    }
    
    private func generateRandomDescription() -> String {
        let descriptions = [
            "A playful and curious kitty.",
            "Loves to nap in sunny spots.",
            "Loves to cuddle.",
            "Enjoys chasing laser pointers.",
            "A friendly cat.",
            "Has a mischievous streak.",
            "A great companion for snuggles.",
            "Likes to explore new places.",
            "Likes to eat grass.",
            "Full of energy and fun."
        ]
        return descriptions.randomElement() ?? "No description."
    }
//    private func triggerRowSpecificCrash() {
//        if index == 15{
//            let _ = [0][1]
//        }
//    }
//    
    private func logCatRowAppearance() {
           Crashlytics.crashlytics().setCustomValue(index, forKey: "cat_index")
       }
    
}



