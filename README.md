# Retail Store Inventory Forecasting App

##  Mission
Enable data‑driven retail operations by forecasting daily product demand and optimizing inventory across multiple stores. This helps retailers to:
- Minimize stockouts and overstock  
- Adapt ordering to weather and promotion cycles  
- Improve profitability through precise demand signals  

---

##  Demo Video
[video Demo](https://www.youtube.com/watch?v=bqFQ0xkSgFs)

---

##  Dataset Description

**Source:**  
Kaggle – [Retail Store Inventory Forecasting Dataset](https://www.kaggle.com/datasets/anirudhchauhan/retail-store-inventory-forecasting-dataset)

This synthetic dataset contains over 73 000 daily records across multiple stores and products, with attributes that allow you to explore demand forecasting, inventory optimization, and dynamic pricing.

### Key Data Features
| Feature               | Type         | Description                                           |
|-----------------------|--------------|-------------------------------------------------------|
| **Date**              | Date         | Daily timestamp                                       |
| **Store ID**          | Categorical  | Unique store identifier                               |
| **Product ID**        | Categorical  | Unique product identifier                             |
| **Category**          | Categorical  | e.g. Electronics, Clothing, Groceries                 |
| **Region**            | Categorical  | Geographic region                                     |
| **Inventory_Level**   | Numerical    | Opening‑of‑day stock level                            |
| **Units_Sold**        | Numerical    | **Target**: units sold per day                        |
| **Units_Ordered**     | Numerical    | Units ordered by store for that day                   |
| **Demand_Forecast**   | Numerical    | Historical forecasted demand index                    |
| **Discount**          | Numerical    | Percentage discount applied                           |
| **Weather_Condition** | Categorical  | e.g. Sunny, Rainy, Snowy                              |
| **Holiday_Promotion** | Binary       | 1 if holiday or promotion, else 0                     |
| **Seasonality**       | Categorical  | e.g. Low, Medium, High                                |
| **Competitor_Pricing**| Numerical    | Average competitor price                              |

---

##  Analysis Objectives
1. **Demand Forecasting**  
   Predict next‑day units sold for each (store, product) pair.  
2. **Inventory Optimization**  
   Recommend restock levels to minimize stockouts and overstock.  
3. **Dynamic Pricing**  
   Simulate pricing strategies based on demand signals, weather, and promotions.  

---

##  Project Structure
```
LINEAR_REGRESSION_MODEL/
├── summative/
│   ├── API/
│   │   ├── __pycache__/                  # Compiled Python bytecode
│   │   ├── prediction.py                 # FastAPI app: serves predictions
│   │   ├── preprocessor.joblib           # Saved preprocessing pipeline
│   │   ├── best_model.joblib             # Trained RandomForestRegressor model
│   │   └── requirements.txt              # Python dependencies for the API
│
│   ├── linear_regression/
│   │   ├── retail_store_inventory.csv    # Dataset used for training
│   │   └── retail_store_inventory.ipynb  # Notebook for EDA and model training
│
├── FlutterApp/
│   ├── lib/
│   │   └── main.dart                     # Flutter frontend app: user input & result UI
│   ├── android/                          # Android platform-specific code
│   ├── ios/                              # iOS platform-specific code
│   ├── linux/                            # Linux build support
│   ├── macos/                            # macOS build support
│   ├── web/                              # Web build support
│   ├── windows/                          # Windows build support
│   ├── pubspec.yaml                      # Flutter project configuration
│   ├── pubspec.lock                      # Locked package versions
│   ├── analysis_options.yaml             # Dart analysis config
│   ├── .metadata                         # Flutter metadata
│   ├── .gitignore                        # Git ignore rules
│   └── .flutter-plugins-dependencies     # Auto-managed Flutter dependencies
│
├── README.md                             # Project overview and setup instructions


```

---

##  API

### Predict Price

**Endpoint**  
```

POST [https://retail-store-model.onrender.com/predict\_price](https://retail-store-model.onrender.com/predict_price)

````

**cURL Example**  
```bash
curl -X 'POST' \
  'https://retail-store-model.onrender.com/predict_price' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "Date": "2025-07-30",
    "Category": "Electronics",
    "Region": "North",
    "Inventory_Level": 120,
    "Units_Sold": 45,
    "Units_Ordered": 50,
    "Demand_Forecast": 48,
    "Discount": 10,
    "Weather_Condition": "Rainy",
    "Holiday_Promotion": 1,
    "Seasonality": "High",
    "Competitor_Pricing": 15.5
}'
````

**Request Body Fields**

* `Date` (string, yyyy‑mm‑dd)
* `Category` (string)
* `Region` (string)
* `Inventory_Level` (number)
* `Units_Sold` (number)
* `Units_Ordered` (number)
* `Demand_Forecast` (number)
* `Discount` (number)
* `Weather_Condition` (string)
* `Holiday_Promotion` (0 or 1)
* `Seasonality` (string)
* `Competitor_Pricing` (number)

**Sample Response**

```json
{
  "predicted_price": 20.46
}
```

**Interactive Swagger UI**
[Try it live »](https://retail-store-model.onrender.com/docs#/default/predict_price_predict_price_post)

---

## ⚙ Installation & Setup

### Prerequisites

* **Flutter SDK** 3.0+
* **Android Studio** (or Xcode) + emulator *or* USB‑debuggable device
* **Python 3.8+** & `pip`

---

### 1. Clone the Repository

```bash
git clone https://github.com/your‑username/LINEAR_REGRESSION_MODEL.git
cd LINEAR_REGRESSION_MODEL/summative
```

---

### 2. Run the API Locally

1. **Create & activate** a virtual environment:

   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```
2. **Install** dependencies:

   ```bash
   pip install -r API/requirements.txt
   ```
3. **Start** the server:

   ```bash
   uvicorn API.prediction:app --host 0.0.0.0 --port 8000
   ```
4. **Browse** Swagger UI at:

   ```
   http://localhost:8000/docs
   ```

---

### 3. Launch the Flutter App

```bash
cd FlutterApp
flutter pub get
flutter run
# To build release bundles:
flutter build apk   # Android
flutter build ios   # iOS
```

In the app, enter your feature values and tap **Predict** to see real‑time results.

---

##  Retraining & EDA

All data exploration, feature engineering, and model training live in:

```
summative/retail_store_inventory.ipynb
```

Re‑run this notebook to:

1. Inspect new data
2. Engineer additional features
3. Train a fresh model and export updated `preprocessor.joblib` & `best_model.joblib`

