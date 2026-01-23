//It's the main only APPDELEGATE
//  ChatApp.swift
//  ChatTest
//
//  Created by Raghavan on 17/09/24.
//
import SwiftUI
import Firebase

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
@main
struct ChatApp: App {
    init() {
        if FirebaseApp.app() == nil{
            FirebaseApp.configure()
        }}
    
    let viewModel = HomeViewModel()
       
       var body: some Scene {
           WindowGroup {
               HomeView()
                   .environmentObject(viewModel)
           }
    }
}

/*. Imaging Tests

These tests help visualize the tumor or abnormal areas in the body.

    •    X-rays: Often used to identify tumors, particularly in bones and the lungs.
    •    CT (Computed Tomography) Scan: Provides detailed cross-sectional images of the body, showing the size, shape, and location of tumors.
    •    MRI (Magnetic Resonance Imaging): Uses strong magnets and radio waves to produce detailed images, especially useful for brain, spinal cord, and soft tissue tumors.
    •    Ultrasound: Uses sound waves to detect tumors, often used for breast, liver, and gynecologic cancers.
    •    PET (Positron Emission Tomography) Scan: Detects cancerous cells by measuring their metabolic activity; often combined with CT scans.
    •    Bone Scan: Detects the spread of cancer to bones.

2. Laboratory Tests (Blood and Urine Tests)

These tests look for biomarkers or abnormal substances in the blood or urine that may indicate cancer.

    •    Complete Blood Count (CBC): Measures the number of blood cells. Abnormalities in red or white blood cells could suggest blood cancers like leukemia.
    •    Tumor Markers: These are proteins or other substances produced by cancer cells or the body in response to cancer:
    •    PSA (Prostate-Specific Antigen) for prostate cancer
    •    CA-125 for ovarian cancer
    •    CA 19-9 for pancreatic cancer
    •    AFP (Alpha-fetoprotein) for liver cancer
    •    CEA (Carcinoembryonic Antigen) for colon and other cancers
    •    Liver Function Tests: Help identify liver involvement or liver cancer.
    •    LDH (Lactate Dehydrogenase): May indicate tissue damage from cancer.

3. Biopsy (Tissue Sampling)

A biopsy is the gold standard for diagnosing cancer. It involves taking a sample of tissue to look for cancer cells under a microscope.

    •    Needle Biopsy: A needle is inserted into the tumor to extract a sample.
    •    Surgical Biopsy: A part of or the entire tumor is surgically removed for examination.
    •    Bone Marrow Biopsy: Used to diagnose blood cancers like leukemia or lymphoma.
    •    Endoscopic Biopsy: A thin tube with a camera (endoscope) is inserted into the body to take a tissue sample (used in colonoscopies, bronchoscopies, etc.).

4. Genetic and Molecular Testing

These tests analyze genes, proteins, or other molecules in the cancer cells to determine the specific type and mutations of cancer, which can guide targeted therapies.

    •    BRCA1/BRCA2 Testing: For breast and ovarian cancer risk.
    •    HER2 Testing: For breast cancer to assess treatment options.
    •    PD-L1 Testing: To assess the suitability for immunotherapy in lung cancer.
    •    Next-Generation Sequencing (NGS): Analyzes multiple genes in cancer cells to guide personalized treatment.

5. Bone Marrow Tests

For blood cancers like leukemia or lymphoma, bone marrow tests help determine whether cancer has spread to the bone marrow.

6. Cytogenetic Tests

    •    FISH (Fluorescence In Situ Hybridization): Detects chromosomal abnormalities in cancer cells, often used for leukemia, lymphoma, and other cancers.
    •    Karyotyping: Analyzes the size, shape, and number of chromosomes to detect genetic changes in blood cancers.

7. Staging Tests

Staging tests determine the extent of cancer spread:

    •    Lymph Node Biopsy: To check if cancer has spread to the lymph nodes.
    •    Sentinel Node Biopsy: Specifically looks at the first lymph node that drains cancer cells.
    •    Chest X-ray, CT, MRI, PET scans: To check for metastasis (spread) to other organs.

8. Other Specialized Tests

    •    Colonoscopy/Endoscopy: Visualizes the gastrointestinal tract for cancers of the colon, esophagus, stomach, etc.
    •    Pap Smear: For detecting cervical cancer in women.
    •    Mammogram: For detecting breast cancer.
    •    Dermatoscopy: Used to examine skin lesions for melanoma (skin cancer).

*/
