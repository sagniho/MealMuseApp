//
//  GroceryStoreView.swift
//  recipetest
//
//  Created by Samriddhi Agnihotri on 13/04/23.
//

import Foundation
import Foundation
import SwiftUI
import MapKit

struct GroceryStoreView: View {
    @State private var groceryStores: [GroceryStore] = []
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    private let locationManager = CLLocationManager()
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: groceryStores) { groceryStore in
                MapAnnotation(coordinate: groceryStore.placemark.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .onTapGesture {
                                self.openInMaps(placemark: groceryStore.placemark)
                            }
                        Text(groceryStore.name)
                            .font(.caption)
                            .fontWeight(.bold)
                    }
                }
            }
            .frame(height: 300)
            .onAppear(perform: {
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                findGroceryStores()
            })
            List {
                Section(header: Text("Top 5 Grocery Stores Near You")) {
                    ForEach(groceryStores, id: \.id) { groceryStore in
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            Text(groceryStore.name)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.openInMaps(placemark: groceryStore.placemark)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Grocery Stores Near You")
    }
    
    private func findGroceryStores() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "grocery"
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            var stores: [GroceryStore] = []
            for item in response.mapItems.prefix(5) {
                if let groceryStore = GroceryStore(placemark: item.placemark) {
                    stores.append(groceryStore)
                }
            }
            
            self.groceryStores = stores
        }
    }
    
    private func openInMaps(placemark: MKPlacemark) {
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.openInMaps(launchOptions: nil)
    }
}


struct GroceryStoreView_Previews: PreviewProvider {
    static var previews: some View {
        GroceryStoreView()
    }
}

struct GroceryStore: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let placemark: MKPlacemark
    
    init?(placemark: MKPlacemark) {
        guard let name = placemark.name else { return nil }
        self.name = name
        self.placemark = placemark
    }
}
