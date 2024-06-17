//
//  ContentView.swift
//  CatsAndModules_IrynaNazar
//
//  Created by Ira Nazar on 2024-05-28.
//

import SwiftUI
import Networking
import FirebasePerformance
import FirebaseCrashlytics


struct ContentView: View {
    @State private var animals: [Animal] = []
    @State private var selectedAnimal: Animal?
    @State private var isLoading = false
    @State private var currentPage = 0
    @State private var showAlert = false
    @State private var crashlyticsEnabled = false
    let service = Networking()
    
    var body: some View {
        NavigationView {
            ZStack {
                
                
                List {
                    ForEach(Array(animals.enumerated()), id: \.element.id) { index, animal in
                        CatRowView(animal: animal, index: index)
                            .onTapGesture {
                                selectedAnimal = animal
                            }
                    }
                    
                    if !isLoading {
                        Color.clear
                            .frame(height: 1)
                            .onAppear {
                                loadAnimals()
                            }
                    }
                }
                .navigationTitle("Animal App")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Crash") {
                            fatalError("Crash was triggered")
                        }
                    }
                }
                
                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.gray.opacity(0.3))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
        .fullScreenCover(item: $selectedAnimal) { animal in
            CatPhotoView(animal: animal, selectedAnimal: $selectedAnimal)
                .edgesIgnoringSafeArea(.all)
        }
        .onAppear {
            loadSelectedAnimals()
            checkCrashlyticsConsent()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Crash Reporting"),
                message: Text("Do you allow to share crash data?"),
                primaryButton: .default(Text("Yes")) {
                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
                    UserDefaults.standard.set(true, forKey: "CrashlyticsConsent")
                },
                secondaryButton: .cancel(Text("No")) {
                    Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
                    UserDefaults.standard.set(false, forKey: "CrashlyticsConsent")
                }
            )
        }
        
        
    }
    
    private func loadSelectedAnimals() {
        let trace = Performance.startTrace(name: "fetch_selected_animal")
        isLoading = true
        service.getAnimals { fetchedAnimals in
            if let fetchedAnimals = fetchedAnimals {
                DispatchQueue.main.async {
                    self.animals = fetchedAnimals
                    self.isLoading = false
                    trace?.stop()
                }
            }
        }
    }
    
    private func loadAnimals() {
        let trace = Performance.startTrace(name: "fetch_animals")
        isLoading = true
        currentPage += 1
        service.getAnimals(page: currentPage) { fetchedAnimals in
            if let fetchedAnimals = fetchedAnimals {
                DispatchQueue.main.async {
                    self.animals.append(contentsOf: fetchedAnimals)
                    self.isLoading = false
                    trace?.stop()
//                    Crashlytics.crashlytics().setCustomValue(self.cats.count, forKey: "loaded_cats_count")
//                    Crashlytics.crashlytics().setCustomValue(currentPage, forKey: "current_page_number")
//                                
                }
            }
        }
    }
    
    private func checkCrashlyticsConsent() {
        if UserDefaults.standard.object(forKey: "CrashlyticsConsent") == nil {
            showAlert = true
        } else {
            let consent = UserDefaults.standard.bool(forKey: "CrashlyticsConsent")
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(consent)
        }
    }
    
    
    //    private func triggerDivisionByZeroCrash() {
    //           let _ = 1 / (cats.isEmpty ? 1 : 0)
    //       }
}

#Preview {
    ContentView()
}
