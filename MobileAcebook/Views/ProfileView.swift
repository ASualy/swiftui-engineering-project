//
//  ProfileView.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 04/09/2024.
//
import SwiftUI
import PhotosUI

struct ProfileView: View {
    let token: String?
    @State private var user: User? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showImagePicker = false // Trigger image picker

    private let userService = UserService()

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading user profile...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if let user = user {
                VStack {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage) // Show selected image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .padding(.bottom, 20)
                    } else if let imageUrl = user.imgUrl, !imageUrl.isEmpty {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.bottom, 20)
                    }

                    Button("Change Profile Photo") {
                        showImagePicker = true // Show the image picker
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    
                    HStack {
                        Text("Full name:")
                        Spacer()
                        Text(user.username ?? "N/A")
                    }
                    .padding(.horizontal)

                    HStack {
                        Text("Email:")
                        Spacer()
                        Text(user.email)
                    }
                    .padding(.horizontal)
                }

//                HStack {
//                    Button("Save") {
//                        uploadProfilePhoto() // Handle saving the new image
//                    }
//                    .padding()
//                    .frame(width: 100)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(5.0)
//
//                    Button("Cancel") {
//                        // Cancel action
//                    }
//                    .padding()
//                    .frame(width: 100)
//                    .background(Color.gray)
//                    .foregroundColor(.white)
//                    .cornerRadius(5.0)
//                }
                .padding(.top, 20)
            }
        }
        .padding()
        .onAppear {
            fetchUserDetails()
        }
        .sheet(isPresented: $showImagePicker) {
            // Image Picker
            PhotoPicker(selectedImage: $selectedImage)
        }
    }

    private func fetchUserDetails() {
        userService.getUserDetails(token: token!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    private func uploadProfilePhoto() {
        guard let selectedImage = selectedImage else { return }
        // TODO: Upload logic goes here, use `userService` or another service to handle image upload
        print("Uploading new profile photo")
        // TODO: convert `UIImage` to data and send to backend
    }
}

// PhotoPicker view for picking images
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images // Limit to images only
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let provider = results.first?.itemProvider else { return }
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
                    DispatchQueue.main.async {
                        self?.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Copy your active token to generate preview
        ProfileView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjZkOTgwMmJhZWU3YTg4ZmMyYzI4ZDAwIiwiaWF0IjoxNzI1NTYyNDg5LCJleHAiOjE3MjU1NjMwODl9.Qf0p30YASlhpNvxEEGzlPIn6Bi4vC41rtw9yIpIAXHM")
    }
}


