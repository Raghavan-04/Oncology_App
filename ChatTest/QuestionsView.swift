// provides layout for  question view
//  QuestionsView.swift
//  ChatTest
//
//  Created by Raghavan on 18/09/24.
//import SwiftUI
import SwiftUI

// Define the QuestionAnswer structure
struct QuestionAnswer: Identifiable {
    var id = UUID()
    let question: String
    let answer: String
    var isExpanded: Bool = false
}

// Define the BodySystem structure
struct BodySystem: Identifiable {
    var id = UUID()
    let name: String
    let commonIllnesses: [String]
    let cancers: [String]
    var isFavorite: Bool = false
    var isExpanded: Bool = false  // Add a property to track expanded state
}

struct QuestionsView: View {
    @State private var searchText = ""  // Add search text state
    @State private var filterByCancers = false  // Toggle filter
    @State private var bodySystems = [
        BodySystem(name: "Circulatory System", commonIllnesses: ["Hypertension", "Heart Disease", "Atherosclerosis"], cancers: ["Leukemia", "Lymphoma", "Myeloma"]),
            BodySystem(name: "Respiratory System", commonIllnesses: ["Asthma", "Chronic Obstructive Pulmonary Disease (COPD)", "Pneumonia"], cancers: ["Lung Cancer", "Mesothelioma"]),
            BodySystem(name: "Digestive System", commonIllnesses: ["Gastroesophageal Reflux Disease (GERD)", "Irritable Bowel Syndrome (IBS)", "Crohn’s Disease"], cancers: ["Colorectal Cancer", "Stomach Cancer", "Pancreatic Cancer"]),
            BodySystem(name: "Nervous System", commonIllnesses: ["Alzheimer’s Disease", "Multiple Sclerosis", "Parkinson’s Disease"], cancers: ["Brain Tumors", "Neuroblastoma"]),
            BodySystem(name: "Endocrine System", commonIllnesses: ["Diabetes", "Hyperthyroidism", "Hypothyroidism"], cancers: ["Thyroid Cancer", "Adrenal Cancer", "Pancreatic Cancer"]),
            BodySystem(name: "Musculoskeletal System", commonIllnesses: ["Osteoarthritis", "Rheumatoid Arthritis", "Osteoporosis"], cancers: ["Bone Cancer (Osteosarcoma)", "Soft Tissue Sarcomas"]),
            BodySystem(name: "Immune System", commonIllnesses: ["Autoimmune Diseases (e.g., Lupus, Rheumatoid Arthritis)"], cancers: ["Lymphoma", "Leukemia"]),
            BodySystem(name: "Integumentary System (Skin)", commonIllnesses: ["Eczema", "Psoriasis", "Acne"], cancers: ["Melanoma", "Basal Cell Carcinoma", "Squamous Cell Carcinoma"]),
            BodySystem(name: "Urinary System", commonIllnesses: ["Urinary Tract Infections (UTIs)", "Kidney Stones", "Chronic Kidney Disease"], cancers: ["Bladder Cancer", "Kidney Cancer", "Prostate Cancer"]),
            BodySystem(name: "Lymphatic System", commonIllnesses: ["Lymphedema", "Tonsillitis", "Lymphadenitis"], cancers: ["Hodgkin's Lymphoma", "Non-Hodgkin's Lymphoma"]),
            BodySystem(name: "Cardiovascular System", commonIllnesses: ["Coronary Artery Disease", "Arrhythmia", "Heart Failure"], cancers: ["Angiosarcoma", "Hemangiosarcoma"]),
            BodySystem(name: "Skeletal System", commonIllnesses: ["Fractures", "Osteoporosis", "Scoliosis"], cancers: ["Osteosarcoma", "Chondrosarcoma"]),
            BodySystem(name: "Excretory System", commonIllnesses: ["Urinary Tract Infection", "Kidney Stones", "Bladder Infections"], cancers: ["Renal Cell Carcinoma", "Bladder Cancer"]),
            BodySystem(name: "Sensory System", commonIllnesses: ["Glaucoma", "Macular Degeneration", "Hearing Loss"], cancers: ["Retinoblastoma", "Nasopharyngeal Carcinoma"]),
            BodySystem(name: "Reproductive System", commonIllnesses: ["Endometriosis", "Polycystic Ovary Syndrome (PCOS)", "Erectile Dysfunction"], cancers: ["Breast Cancer", "Ovarian Cancer", "Testicular Cancer"])
        // Add other body systems here
    ]

    var filteredSystems: [BodySystem] {
        bodySystems.filter { system in
            (searchText.isEmpty || system.name.localizedCaseInsensitiveContains(searchText) ||
             system.commonIllnesses.joined(separator: " ").localizedCaseInsensitiveContains(searchText) ||
             system.cancers.joined(separator: " ").localizedCaseInsensitiveContains(searchText)) &&
            (!filterByCancers || system.cancers.isEmpty == false)
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Search bar
                    HStack {
                        TextField("Search body systems", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Button(action: {
                            filterByCancers.toggle()  // Toggle between cancers or illnesses
                        }) {
                            Text(filterByCancers ? "Show All" : "Filter by Cancers")
                        }
                        .padding(.trailing, 10)
                    }

                    // Display favorites first
                    if bodySystems.contains(where: { $0.isFavorite }) {
                        Text("Favorite Body Systems")
                            .font(.title2)
                            .padding(.horizontal)
                        
                        ForEach(filteredSystems.filter { $0.isFavorite }) { system in
                            BodySystemCard(system: system, filterByCancers: filterByCancers, toggleFavorite: toggleFavorite, toggleExpanded: toggleExpanded)
                        }
                    }
                    
                    Text("Common Body Systems Related to Illnesses and Cancers")
                        .font(.title2)
                        .padding(.horizontal)
                    
                    ForEach(filteredSystems) { system in
                        BodySystemCard(system: system, filterByCancers: filterByCancers, toggleFavorite: toggleFavorite, toggleExpanded: toggleExpanded)
                    }
                }
                .padding(.bottom, 10)
            }
            .navigationTitle("Symptoms")
            .toolbar {
                // Add Help button in toolbar
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: QuestionAPIService()) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
    
    // Function to toggle the favorite status of a body system
    private func toggleFavorite(for system: BodySystem) {
        if let index = bodySystems.firstIndex(where: { $0.id == system.id }) {
            bodySystems[index].isFavorite.toggle()
        }
    }
    
    // Function to toggle the expanded state of a body system card
    private func toggleExpanded(for system: BodySystem) {
        if let index = bodySystems.firstIndex(where: { $0.id == system.id }) {
            bodySystems[index].isExpanded.toggle()
        }
    }
}

// New Card View for Body System with Favorite and Expand/Collapse
struct BodySystemCard: View {
    var system: BodySystem
    var filterByCancers = false
    var toggleFavorite: (BodySystem) -> Void
    var toggleExpanded: (BodySystem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(system.name)
                    .font(.headline)
                Spacer()
                // Favorite button
                Button(action: {
                    toggleFavorite(system)
                }) {
                    Image(system.isFavorite ? "star.fill" : "star")
                        .foregroundColor(system.isFavorite ? .yellow : .gray)
                }
            }
            
            if system.isExpanded {
                if filterByCancers {
                    Text("Cancers: \(system.cancers.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                } else {
                    Text("Common Illnesses: \(system.commonIllnesses.joined(separator: ", "))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            // Expand/Collapse button
            Button(action: {
                toggleExpanded(system)
            }) {
                Text(system.isExpanded ? "Show Less" : "Show More")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Preview for SwiftUI
struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView()
    }
}/*
 /HStack {
    
    NavigationLink(destination: QuestionsView()) {
        VStack {
            Image(systemName: "questionmark.circle.fill")
            Text("Questions")
        }
    }
    .padding(.horizontal, 13)
    
*/
