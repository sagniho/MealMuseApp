import SwiftUI
/*
struct LandingView: View {
    let viewModel = RecipeViewModel()
    @State private var selectedTab: Int? = nil

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("GradientStart").opacity(0.5), Color("GradientEnd").opacity(0.5), Color("GradientEnd").opacity(1)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                VStack {
                    Spacer()
                    Image("Image")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    VStack {
                        Text("Meal Muse")
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Discover, Plan, and Savor Delicious Meals - All in One Place!")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                    }

                    Spacer()

                    NavigationLink(destination: AppTabView(selectedTab: Binding(get: { selectedTab ?? 0 }, set: { selectedTab = $0 })), tag: 0, selection: $selectedTab) {

                        Text("Explore 5k+ Recipes")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color("GradientEnd"))
                            .cornerRadius(40)
                    }
                    .padding(.horizontal, 20)

                    NavigationLink(destination: AppTabView(selectedTab: Binding(get: { selectedTab ?? 0 }, set: { selectedTab = $0 })), tag: 1, selection: $selectedTab) {

                        Text("Build Your Weekly Schedule")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color("GradientEnd"))
                            .cornerRadius(40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)

                    NavigationLink(destination: AppTabView(selectedTab: Binding(get: { selectedTab ?? 0 }, set: { selectedTab = $0 })), tag: 2, selection: $selectedTab) {

                        Text("Explore Grocery Stores")
                            .fontWeight(.semibold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(Color("GradientEnd"))
                            .cornerRadius(40)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
    }
}

*/
import SwiftUI

struct LandingView: View {
    let viewModel = RecipeViewModel()
    @State private var selectedTab: Int? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Image("Image 2")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.80)

                VStack {
                    Spacer()

                    VStack(alignment: .center) {
                                           Text("Meal Muse")
                                               .font(.system(size: 50, weight: .bold))
                                               .foregroundColor(.white)
                                               .multilineTextAlignment(.center)
                                             //  .background(Color.black.opacity(0.4))
                                              // .cornerRadius(8)
                                               .padding()

                                           Text("Discover, Plan, and Savor Delicious Meals - All in One Place!")
                                               .font(.system(size: 20).bold())
                                               .foregroundColor(.white)
                                               .multilineTextAlignment(.center)
                                               .frame(width: 350)
                                               .padding()
                                             //  .background(Color.black.opacity(0.4))
                                              // .cornerRadius(8)
                                       }

                   
                    Spacer()
                    
                    VStack(spacing: 20) {
                        NavigationLink(destination: AppTabView(selectedTab: Binding(get: { selectedTab ?? 0 }, set: { selectedTab = $0 })), tag: 0, selection: $selectedTab) {

                            Text("Explore 5k+ Recipes")
                                .fontWeight(.semibold)
                                .padding(.vertical, 15)
                                .frame(maxWidth: 300)
                                .background(Color.white)
                                .foregroundColor(Color("GradientEnd"))
                                .cornerRadius(40)
                        }

                        NavigationLink(destination: AppTabView(selectedTab: Binding(get: { selectedTab ?? 0 }, set: { selectedTab = $0 })), tag: 1, selection: $selectedTab) {

                            Text("Build Your Weekly Schedule")
                                .fontWeight(.semibold)
                                .padding(.vertical, 15)
                                .frame(maxWidth: 300)
                                .background(Color.white)
                                .foregroundColor(Color("GradientEnd"))
                                .cornerRadius(40)
                        }

                        NavigationLink(destination: AppTabView(selectedTab: Binding(get: { selectedTab ?? 0 }, set: { selectedTab = $0 })), tag: 2, selection: $selectedTab) {

                            Text("Explore Grocery Stores")
                                .fontWeight(.semibold)
                                .padding(.vertical, 15)
                                .frame(maxWidth: 300)
                                .background(Color.white)
                                .foregroundColor(Color("GradientEnd"))
                                .cornerRadius(40)
                        }
                    }
                    .padding(.horizontal, 20)

                    Spacer()
                }
            }
        }
    }
}

import SwiftUI


struct AppTabView: View {
    @Binding var selectedTab: Int

    var body: some View {
        TabView(selection: $selectedTab) {
            RecipeListView(viewModel: RecipeViewModel())
                .tabItem {
                    Label("Recipes", systemImage: "book")
                }.tag(0)

            ScheduleView()
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }.tag(1)

            GroceryStoreView()
                .tabItem {
                    Label("Grocery Store", systemImage: "cart")
                }.tag(2)
        }.accentColor(.green)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            UITabBar.appearance().barTintColor = UIColor(Color("GradientEnd"))
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().backgroundColor = UIColor(Color("GradientEnd"))
            UITabBar.appearance().unselectedItemTintColor = UIColor.white
        }
    }
}
