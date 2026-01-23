// provides navigation page for setting view
//  SettingsView.swift
//  ChatTest
//
import SwiftUI
struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Progress")
                    .font(.largeTitle)
                    .padding(.top)

                // 3D Pie Chart for Progress Tracking
                TreatmentProgressPieChart(currentDay: 10, totalDays: 30)
                    .frame(width: 200, height: 200)
                    .padding()

                List {
                    NavigationLink(destination: ProfileView()) {
                        Text("Profile")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: LinkedDeviceView()) {
                        Text("Linked Devices")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: SecurityAndPrivacyView()) {
                        Text("Security and Privacy")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: BillingView()) {
                        Text("Billing")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: NotificationsView()) {
                        Text("Notifications")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: QualitySettingsView()) {
                        Text("Upload and Download Quality")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Text("Appearance")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: GeneralSettingsView()) {
                        Text("General Settings")
                            .buttonStyle(SettingsButtonStyle())
                    }
                    NavigationLink(destination: HelpAndSupportView()) {
                        Text("Help & Support")
                            .buttonStyle(SettingsButtonStyle())
                    }
                }
                .navigationTitle("Settings")
                .navigationBarBackButtonHidden(false)
            }
            .background(Color(UIColor.systemGroupedBackground)) // Background color to match iOS settings
        }
    }
}// Treatment Progress Pie Chart

struct TreatmentProgressPieChart: View {
    let currentDay: Int
    let totalDays: Int
    var size: CGFloat = 200 // Default size
    
    var percentage: Double {
        return Double(currentDay) / Double(totalDays)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 20)
            Circle()
                .trim(from: 0.0, to: percentage)
                .stroke(percentage < 1 ? Color.blue : Color.green, lineWidth: 20) // Change color based on completion
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: percentage) // Animation on percentage change
            
            VStack {
                Text("Day \(currentDay) of \(totalDays)")
                    .font(.headline)
                Text("\(Int(percentage * 100))%")
                    .font(.subheadline)
            }
            .padding()
        }
        .frame(width: size, height: size) // Customizable size
        .background(Color.white)
        .cornerRadius(size / 2)
        .shadow(radius: 10)
    }
}

struct TreatmentProgressPieChart_Previews: PreviewProvider {
    static var previews: some View {
        TreatmentProgressPieChart(currentDay: 10, totalDays: 30)
    }
}
// Profile View

struct ProfileView: View {
    @State private var username: String = "User Name"
    @State private var email: String = "test@example.com"
    @State private var password: String = ""
    @State private var phoneNumber: String = "+1 123 456 7890"
    @State private var birthdate: Date = Date()
    @State private var receiveNewsletters: Bool = true
    @State private var profileImage: Image? = nil
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        Form {
            // Profile Picture Section
            Section(header: Text("Profile Picture")) {
                VStack {
                    if profileImage != nil {
                        profileImage?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                    }
                    Button("Change Profile Picture") {
                        isImagePickerPresented = true
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(selectedImage: $profileImage)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }

            // Profile Information Section
            Section(header: Text("Profile Information")) {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                DatePicker("Date of Birth", selection: $birthdate, displayedComponents: .date)
                SecureField("Password", text: $password)
            }
            
            // Preferences Section
            Section(header: Text("Preferences")) {
                Toggle(isOn: $receiveNewsletters) {
                    Text("Receive Newsletters")
                }
            }
            
            // Save Changes Button
            Section {
                Button(action: {
                    // Save Profile Action
                    print("Profile Updated: Username - \(username), Email - \(email)")
                }) {
                    Text("Save Changes")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Image Picker for Profile Picture
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: Image?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.editedImage] as? UIImage {
                parent.selectedImage = Image(uiImage: uiImage)
            } else if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = Image(uiImage: uiImage)
            }
            picker.dismiss(animated: true)
        }
    }
}

// Linked Devices View

struct LinkedDeviceView: View {
    // Sample data for linked devices
    @State private var linkedDevices: [Device] = [
        Device(name: "MacBook Air", lastActive: "a second ago"),
        Device(name: "iPhone", lastActive: "10 minutes ago"),
        Device(name: "iPad", lastActive: "2 hours ago")
    ]

    var body: some View {
        List {
            ForEach(linkedDevices.indices, id: \.self) { index in
                let device = linkedDevices[index]
                HStack {
                    Image(systemName: "desktopcomputer")
                    VStack(alignment: .leading) {
                        Text(device.name)
                            .font(.headline)
                        Text("Last active: \(device.lastActive)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Button(action: {
                        unlinkDevice(at: index)
                    }) {
                        Text("Unlink")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Linked Devices")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func unlinkDevice(at index: Int) {
        let device = linkedDevices[index]
        linkedDevices.remove(at: index)
        // Perform any additional actions related to unlinking
        print("\(device.name) has been unlinked.")
    }
}

// Device struct to represent linked devices
struct Device: Identifiable {
    let id = UUID()
    var name: String
    var lastActive: String
}

// Preview for LinkedDeviceView
struct LinkedDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LinkedDeviceView()
        }
    }
}
// Security and Privacy View

struct SecurityAndPrivacyView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var isTwoFactorEnabled: Bool = false
    @State private var profileVisibility: String = "Friends"
    @State private var locationSharing: Bool = false
    @State private var isAppLockEnabled: Bool = false
    @State private var isAnalyticsEnabled: Bool = true
    @State private var isPersonalizedAdsEnabled: Bool = false

    var body: some View {
        Form {
            // Section for Password Management
            Section(header: Text("Change Password")) {
                SecureField("New Password", text: $newPassword)
                SecureField("Confirm Password", text: $confirmPassword)
                
                Button(action: {
                    // Password change logic
                    print("Password Changed")
                }) {
                    Text("Change Password")
                        .foregroundColor(.blue)
                }
            }
            
            // Section for Two-Factor Authentication
            Section(header: Text("Two-Factor Authentication")) {
                Toggle(isOn: $isTwoFactorEnabled) {
                    Text("Enable Two-Factor Authentication")
                }
                if isTwoFactorEnabled {
                    Text("You will receive a one-time code each time you log in.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Section for Privacy Settings
            Section(header: Text("Privacy")) {
                Picker("Profile Visibility", selection: $profileVisibility) {
                    Text("Everyone").tag("Everyone")
                    Text("Friends").tag("Friends")
                    Text("Only Me").tag("Only Me")
                }
                
                Toggle(isOn: $locationSharing) {
                    Text("Share Location")
                }
            }
            
            // Section for App Lock Settings
            Section(header: Text("App Lock")) {
                Toggle(isOn: $isAppLockEnabled) {
                    Text("Enable App Lock (Face ID/Touch ID)")
                }
                if isAppLockEnabled {
                    Text("Use Face ID/Touch ID to unlock the app.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            // Section for Data Permissions
            Section(header: Text("Data Permissions")) {
                Toggle(isOn: $isAnalyticsEnabled) {
                    Text("Allow Usage Analytics")
                }
                Toggle(isOn: $isPersonalizedAdsEnabled) {
                    Text("Allow Personalized Ads")
                }
            }
        }
        .navigationTitle("Security & Privacy")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

// Billing View

struct BillingView: View {
    @State private var paymentMethod = "Credit Card"
    @State private var autoRenew = true
    @State private var billingAddress = "123 Main St, Springfield, USA"
    @State private var billingHistory = ["Invoice #001 - $10", "Invoice #002 - $20", "Invoice #003 - $15"]

    var body: some View {
        Form {
            Section(header: Text("Payment Method")) {
                Picker("Payment Method", selection: $paymentMethod) {
                    Text("Credit Card").tag("Credit Card")
                    Text("PayPal").tag("PayPal")
                    Text("Bank Transfer").tag("Bank Transfer")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Billing Address")) {
                TextField("Billing Address", text: $billingAddress)
            }

            Section(header: Text("Auto Renew Subscription")) {
                Toggle(isOn: $autoRenew) {
                    Text("Enable Auto Renew")
                }
            }

            Section(header: Text("Billing History")) {
                List(billingHistory, id: \.self) { item in
                    Text(item)
                }
            }

            Section {
                Button(action: {
                    // Save billing settings action
                    print("Billing settings saved")
                }) {
                    Text("Save Changes")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Billing")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NotificationsView: View {
    @State private var pushNotificationsEnabled = true
    @State private var emailNotificationsEnabled = false
    @State private var messagePreviewEnabled = true
    @State private var notificationSound = "Chime"

    var body: some View {
        Form {
            Section(header: Text("General Notifications")) {
                Toggle(isOn: $pushNotificationsEnabled) {
                    Text("Enable Push Notifications")
                }
                Toggle(isOn: $emailNotificationsEnabled) {
                    Text("Enable Email Notifications")
                }
            }
            
            Section(header: Text("Message Settings")) {
                Toggle(isOn: $messagePreviewEnabled) {
                    Text("Show Message Previews")
                }
                Picker("Notification Sound", selection: $notificationSound) {
                    Text("Chime").tag("Chime")
                    Text("Ding").tag("Ding")
                    Text("Alert").tag("Alert")
                }
            }
            
            Section {
                Button(action: {
                    // Save settings action
                    print("Notification settings saved")
                }) {
                    Text("Save Changes")
                        .foregroundColor(.blue)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Quality Settings View
// Quality Settings View

struct QualitySettingsView: View {
    @State private var uploadQuality = "High"
    @State private var downloadQuality = "High"
    @State private var dataSaverEnabled = false
    @State private var autoAdjustQuality = true

    var body: some View {
        Form {
            Section(header: Text("Upload Quality")) {
                Picker("Upload Quality", selection: $uploadQuality) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Download Quality")) {
                Picker("Download Quality", selection: $downloadQuality) {
                    Text("Low").tag("Low")
                    Text("Medium").tag("Medium")
                    Text("High").tag("High")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Data Saver")) {
                Toggle("Enable Data Saver", isOn: $dataSaverEnabled)
            }

            Section(header: Text("Auto Adjust Quality")) {
                Toggle("Enable Auto Adjust Quality", isOn: $autoAdjustQuality)
            }

            Section {
                Button(action: {
                    // Save quality settings action
                    print("Quality settings saved: Upload Quality - \(uploadQuality), Download Quality - \(downloadQuality)")
                }) {
                    Text("Save Changes")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("Upload & Download Quality")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Appearance Settings View

struct AppearanceSettingsView: View {
    @State private var selectedTheme = "Light"
    @State private var fontSize: CGFloat = 14

    var body: some View {
        Form {
            Section(header: Text("Theme")) {
                Picker("Select Theme", selection: $selectedTheme) {
                    Text("Light").tag("Light")
                    Text("Dark").tag("Dark")
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Font Size")) {
                Slider(value: Binding(
                    get: { fontSize },
                    set: { fontSize = $0 }
                ), in: 10...30, step: 1) {
                    Text("Font Size")
                }
                Text("Current Font Size: \(Int(fontSize))")
            }

            Section {
                Button(action: {
                    // Save appearance settings action
                    print("Appearance settings saved: Theme - \(selectedTheme), Font Size - \(fontSize)")
                }) {
                    Text("Save Changes")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("Appearance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// General Settings View

struct GeneralSettingsView: View {
    @State private var language = "English"
    @State private var notificationsEnabled = true

    var body: some View {
        Form {
            Section(header: Text("Language")) {
                Picker("Select Language", selection: $language) {
                    Text("English").tag("English")
                    Text("Spanish").tag("Spanish")
                    Text("French").tag("French")
                }
            }
            Section(header: Text("Region")) {
                      Picker("Region", selection: .constant("United States")) {
                          Text("United States").tag("United States")
                          Text("Europe").tag("Europe")
                          Text("Asia").tag("Asia")
                          Text("Africa").tag("Africa")
                          Text("Middle East").tag("Middle east")
                          Text("Australia").tag("Australia")

                      }
                  }
            Section(header: Text("Notifications")) {
                Toggle(isOn: $notificationsEnabled) {
                    Text("Enable Notifications")
                }
            }

            Section {
                Button(action: {
                    // Save general settings action
                    print("General settings saved: Language - \(language), Notifications - \(notificationsEnabled)")
                }) {
                    Text("Save Changes")
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .navigationTitle("General Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Help and Support View

struct HelpAndSupportView: View {
    var body: some View {
        List {
            Section(header: Text("FAQs")) {
                Text("How to change password?")
                Text("How to link devices?")
                Text("How to manage notifications?")
            }
            Section(header: Text("Contact Support")) {
                Text("Email: support@example.com")
                Text("Phone: +1 234 567 890")
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Preview for Settings View

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

struct SettingsButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 300, height: 50) // Set static width and height
            .background(configuration.isPressed ? Color.gray.opacity(0.3) : Color.white) // Change background on press
            .foregroundColor(.black) // Text color
            .font(.headline)
            .cornerRadius(10) // Rounded corners
            .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1) // Subtle shadow for depth
            .padding(.horizontal)
    }
}
