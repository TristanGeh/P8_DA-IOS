//
//  AddExerciseView.swift
//  Arista
//
//  Created by Vincent Saluzzo on 08/12/2023.
//

import SwiftUI

struct AddExerciseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: AddExerciseViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Form {
                        TextField("Catégorie", text: $viewModel.category)
                        TextField("Heure de démarrage (HH:mm)", text: $viewModel.startTimeString)
                        TextField("Durée (en minutes)", text: $viewModel.durationString)
                        TextField("Intensité (0 à 10)", text: $viewModel.intensityString)
                    }.formStyle(.grouped)
                    
                    Spacer()
                    if let error = viewModel.validationError {
                        Text(error)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.red)
                            .cornerRadius(10)
                            .padding(.horizontal, 5)
                    }
                }
                Spacer()
                Button("Ajouter l'exercice") {
                    if viewModel.addExercise() {
                        presentationMode.wrappedValue.dismiss()
                    }
                }.buttonStyle(.borderedProminent)
                
            }
            .navigationTitle("Nouvel Exercice ...")
            
        }
    }
}


#Preview {
    AddExerciseView(viewModel: AddExerciseViewModel(context: PersistenceController.preview.container.viewContext))
}
