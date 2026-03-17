# Oncology_ChatBot
# 🩺 Oncowise AI Chatbot: Cancer Treatment Application
![Project Status](https://img.shields.io/badge/Status-Completed-success) 
![Project Year](https://img.shields.io/badge/Year-October%202024-blue)
![Affiliation](https://img.shields.io/badge/Affiliation-PSG%20College%20of%20Technology-red)

**Project Name:** CANCER TREATMENT APPLICATION BASED ON PUBMED ARTICLES
**Documented & Submitted By:** Raghavan SU 

---

## 💡 Project Summary & Goal

This project is a **Medical AI Chatbot** designed to provide Intelligent Healthcare Assistance for cancer treatment. Leveraging Deep Learning models fine-tuned on medical literature, the system aims to:
1.  **Bridge the gap** between complex medical knowledge (from sources like PubMed) and user-friendly communication.
2.  **Assist medical professionals** in quick information retrieval and decision support.
3.  **Provide accessible medical insights** for patients.

## ✨ Integrated Architectural Approach

The system employs a multi-task learning approach combining three distinct BioBERT and GPT-2 models for a cohesive output.

| Component | Base Model | Task | Key Function |
| :--- | :--- | :--- | :--- |
| **Classification Module** | Fine-tuned BioBERT | Cancer Type Prediction | Categorizes user queries (symptoms, diseases, treatment) to route the request. |
| **Question Answering (QA) Module** | Fine-tuned BioBERT | Knowledge Extraction (Extractive QA) | Retrieves relevant answer spans from medical context (MedQuAD/PubMed). |
| **Response Refinement Module** | Fine-tuned GPT-2 | Text Generation | Rephrases AI-generated responses for natural language flow and coherence. |
| **Client Side** | Swift-based Mobile App | User Interface | Provides a mobile interface for real-time interaction (OncoChats). |
| **Backend** | Flask API | Deployment | Secure query transmission and accessibility of the model pipeline. |


## 📊 Performance & Outcome Analysis

The model was evaluated using a multi-task approach. While individual tasks performed strongly, the Overall Accuracy reflects the complexity of the integrated system.

| Metric | Component | Value | Interpretation |
| :--- | :--- | :--- | :--- |
| **Classification Accuracy** | BioBERT Classification | **80%** | Strong performance in cancer type classification (Breast Cancer: 38% highest prediction). |
| **Question Answering (EM)** | BioBERT-QA on MedQuAD | **63%** | Reliable and consistent question-answering capabilities. |
| **Response Quality (BLEU)** | Fine-tuned GPT-2 | **68%** | High linguistic similarity and good quality of generated text. |
| **Overall Accuracy** | End-to-End Pipeline | **≈ 34%** | Indicates the challenge of balancing and integrating three complex tasks effectively in a multi-task learning environment. |

### Training Highlights
*   **Optimizer:** AdamW (`LR=0.0001`, `Weight Decay=1e-5`) for stable updates.
*   **Regularization:** L2 Regularization, Dropout (0.3), and Early Stopping to mitigate overfitting.
*   **Dataset Split:** 80% Training / 20% Testing.

## 🛠️ Implementation Details (Datasets & Preprocessing)

| Model / Task | Dataset Source | Preprocessing Techniques |
| :--- | :--- | :--- |
| **BioBERT QA** | MedQuAD Dataset (from PubMed) | Tokenization, Special Token Addition (`[CLS]`, `[SEP]`), Padding/Truncation. |
| **BioBERT Classification** | All cancer types model from Kaggle | BioBERT Tokenizer, Label Encoding, Cross-Entropy Loss. |
| **GPT-2 Model** | Health Counseling Conversations (Kaggle) | GPT-2 Tokenizer, Lowercasing, Merge conversations into structured format. |

---

## 🚀 Setup and Installation

*Due to the split nature of the project (Swift Client + Python/Flask Backend), both environments must be set up.*

1.  **Secure Setup:**
    *   The project requires an **OpenAI API Key** for the `APIService.swift`. **The key must be stored as an environment variable, NOT hardcoded.** The backend will not run without a valid key.

2.  **Backend (Flask API):**
    *   Clone the repository.
    *   Set up a Python environment and install dependencies (`pip install -r requirements.txt`).
    *   Run the Flask server.

3.  **Client (Swift Mobile Application):**
    *   Open the project in Xcode.
    *   Ensure all necessary pods/dependencies are installed.
    *   Configure Firebase/Google Sign-In by adding a valid `GoogleService-Info.plist` file (if necessary).
    *   Run the application on a simulator or physical device.
      ---

 **Home page**
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 15 Plus - 2024-11-25 at 10 30 10" src="https://github.com/user-attachments/assets/24e98f8a-30fd-491c-8377-1a2531c70d4f" />

**Chat page**
<img width="1290" height="2796" alt="Simulator Screenshot - iPhone 15 Plus - 2024-11-25 at 10 30 32" src="https://github.com/user-attachments/assets/f625a0fb-5616-4b2b-8cce-fb6fe45cc091" />

 ---

## ⚖️ License

This project is licensed under the **GNU General Public License v3.0 (GPL-3.0)** - see the `LICENSE` file for details.
