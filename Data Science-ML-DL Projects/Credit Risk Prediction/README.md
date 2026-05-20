The Jupyter Notebook file, Loan Deault Notebook, is too big to be diplayed. I would suggest you download it and open it in Visual Studio Code (VSC).

# LendingClub Credit Risk Prediction

## Project Overview
This project focuses on building a machine learning model capable of predicting whether a loan issued through the LendingClub platform is likely to be repaid or defaulted (“Charged Off”).

LendingClub was originally a peer-to-peer lending platform that provided billions of dollars in small loans. Publicly available anonymized loan data from LendingClub is used in this project to analyze borrower behavior and identify patterns associated with loan repayment risk.

The objective of this project is to support proactive risk management by identifying potentially risky loans at the moment the loan is issued. Such predictions could help financial institutions:
- Reduce financial losses from defaults
- Improve lending decisions
- Offer early interventions to borrowers
- Enhance overall portfolio performance

## Problem Statement 
The dataset contains historical information about approved loans, including:
- Fully Paid loans
- Current loans
- Charged Off loans

The task is to build a classification model that predicts whether a loan is likely to default based only on information available at the start of the loan process.

The target variable is:
- Loan Status
  - Fully Paid
  - Charged Off
Loans labeled as Current are typically excluded from supervised modeling because their final outcome is still unknown.

## Project Objectives 
The notebook should include the following stages:

1. Exploratory Data Analysis (EDA)
   - Understand the dataset structure
   - Analyze distributions and relationships between variables
   - Identify missing values and anomalies
   - Detect trends related to loan repayment behavior
   - Eliminate irrelevant or redundant features early
 
2. Data Preprocessing
   - Handle missing values
   - Encode categorical variables
   - Normalize or scale features where necessary
   - Remove leakage variables
   - Feature engineering and transformation
   - Reduce the dataset to:
     - Minimum: 30 features
     - Maximum: 60 features
    
3. Model Building
Models used: Random Forest

4. Performance Evaluation
Evaluate model performance using:
- ROC Curve
- AUC Score
- Precision-Recall Curve (PR)
The model should demonstrate strong predictive capability on unseen data.

## Important Considerations 
### Data Leakage 
Some variables are only available after the loan has already been issued or while the loan is active. These variables must be removed because they would leak future information into the model. The model must only use information available at the beginning of the loan approval process.

## Dataset Information 
The dataset contains anonymized borrower and loan information. 

## Deliverables
The final submission should include:
- A clean and well-documented Jupyter Notebook
- Exploratory Data Analysis
- Data preprocessing pipeline
- Feature selection/preparation
- Model training and evaluation
- Predictions on the unknown test set
- Performance metrics and interpretation

## Technologies Used
- Python
- Pandas
- NumPy
- Scikit-learn
- Matplotlib
- Seaborn

## Expected Outcome
The final model should be capable of identifying loans with a higher probability of default before approval, enabling better lending decisions and improved risk management strategies.

## Repository Structure 
├── Loan Default Notebook.ipynb  
├── lendingClub_data => train_data  
├── test_set.txt  
├── test_set_result  
├── test_set_result_example  
└── REANME.md

## Author
Martha Geoffrey Kabakaki

## References 
[LendingClub Wikipedia Page](https://en.wikipedia.org/wiki/LendingClub)
