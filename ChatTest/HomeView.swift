
/*import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Fixed Navigation Bar (Settings)
                HStack {
                    Spacer()

                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.top, 40) // Top padding for spacing from the top of the screen

                // Scrollable Content
                ScrollView {
                    VStack {
                        // Welcome Text
                        Text(viewModel.welcomeText)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.top, 40)
                            .onAppear {
                                viewModel.startTyping()
                            }

                        Spacer()

                        // Chat Button
                        if viewModel.showChatButton {
                            NavigationLink(destination: ContentView()) {
                                Text("Start Chatting")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .padding(.top, 50)
                            }
                            .transition(.opacity)
                        }

                        Spacer()
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(HomeViewModel())
    }
}
*/

/*    NavigationLink(destination: EmergencyView()) {
        VStack {
            Image(systemName: "phone.fill")
            Text("Emergency")
        }
    }
    .padding(.horizontal, 10)*/

//Provides main landing page
import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var viewModel: HomeViewModel

    var body: some View {
        NavigationView {
            VStack {
                Text(viewModel.welcomeText)
                    .font(.largeTitle)
                    .bold()
                    .multilineTextAlignment(.center)
                    .onAppear {
                        viewModel.startTyping()
                    }
                    .padding(.top, 100)

                Spacer()

                if viewModel.showChatButton {
                    NavigationLink(destination: ContentView()) {
                        Text("Start Chatting")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 50)
                    .transition(.opacity)
                }

                if viewModel.showChatButton {
                    NavigationLink(destination: BookAppointmentView()) {
                        Text("Book appointments")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 50)
                    .transition(.opacity)
                }

                Spacer()

                HStack {
                    NavigationLink(destination: QuestionsView()) {
                        VStack {
                            Image(systemName: "questionmark.circle.fill")
                            Text("Symptoms")
                        }
                    }
                    .padding(.horizontal, 9)

                    NavigationLink(destination: ContentView()) {
                        VStack {
                            Image(systemName: "message.fill")
                            Text("Chats")
                        }
                    }
                    .padding(.horizontal, 12)
                    
              

                    NavigationLink(destination: LabResultsView()) {
                        VStack {
                            Image(systemName: "doc.text.fill") // Icon for lab results
                            Text("Lab Results")
                                                        }
                    }
                    .padding(.horizontal, 12)

                    NavigationLink(destination: SettingsView()) {
                        VStack {
                            Image(systemName: "gearshape.fill")
                            Text("Settings")
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(HomeViewModel())
    }
}

