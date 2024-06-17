//
//  CatPhotoView.swift
//  CatsAndModules_IrynaNazar
//
//  Created by Ira Nazar on 2024-05-28.
//

import SwiftUI
import Networking
import FirebasePerformance
import FirebaseCrashlytics

struct CatPhotoView: View {
    let animal: Animal
    @Binding var selectedAnimal: Animal?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if let url = URL(string: animal.url) {
                    let trace = Performance.startTrace(name: "load_animal_image")
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .clipped()
                            .onAppear {
                                trace?.stop()
                            }
                    } placeholder: {
                        ProgressView()
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                } else {
                    Image(systemName: "Photo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
            }
            .onAppear {
                Crashlytics.crashlytics().log("Cat photo view appeared for animal: \(animal.id)")
//                triggerArrayOutOfBoundsCrash()
            }
            .onTapGesture {
                selectedAnimal = nil
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
//    private func triggerArrayOutOfBoundsCrash() {
//            let array = [1]
//            let _ = array[2] 
//        }
}




