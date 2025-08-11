//
//  AddContactView.swift
//  ContactsMix
//
//  Created by Abraham Duran on 8/11/25.
//

import SwiftUI

struct AddContactView: View {
    @StateObject var viewModel = AddContactViewModel()
    let onCancel: () -> Void
    let onSave: (Contact) -> Void

    var body: some View {
        Form {
            Section("Foto") {
                if let image = viewModel.imageUrl, let url = URL(string: image) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            case .success(let image):
                                image.resizable().scaledToFill()
                            case .failure:
                                Text("Error cargando imagen")
                                    .frame(height: 200)
                                    .background(.gray)
                            @unknown default:
                                EmptyView()
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Color.gray.opacity(0.2).frame(height: 200).overlay(Text("Sin foto"))
                }
                
                Button("Cargar foto aleatoria") { viewModel.loadRandomImage() }
            }

            Section("Datos") {
                TextField("Nombre", text: $viewModel.firstName)
                    .textContentType(.givenName)

                TextField("Apellido", text: $viewModel.lastName)
                    .textContentType(.familyName)

                TextField("Nombre", text: $viewModel.phone)
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
            }
        }
        .toolbar { toolbar }
    }

    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text("Nuevo contacto")
        }

        ToolbarItem(placement: .topBarLeading) {
            Button("Cancelar", action: onCancel)
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button("Guardar") {
                onSave(viewModel.buildContact())
            }
            .disabled(!viewModel.canSave)
        }
    }
}

#Preview {
    NavigationStack {
        AddContactView(onCancel: { }, onSave: { _ in })
    }
}
