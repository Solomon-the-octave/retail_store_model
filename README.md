https://www.kaggle.com/datasets/anirudhchauhan/retail-store-inventory-forecasting-dataset
# Retail Store Inventory Forecasting App

## 🎯 Mission
Enable data driven retail operations by forecasting daily product demand and optimizing inventory across multiple stores. This helps retailers to:
- Minimize stockouts and overstock  
- Adapt ordering to weather and promotion cycles  
- Improve profitability through precise demand signals  

---

## 🎥 Demo Video
[vide demo](https://youtu.be/bqFQ0xkSgFs)

---

## 📊 Dataset Description

**Source**  
Kaggle – [Retail Store Inventory Forecasting Dataset](https://www.kaggle.com/datasets/anirudhchauhan/retail-store-inventory-forecasting-dataset)

This synthetic dataset contains over 73 000 daily records across multiple stores and products, with attributes that allow you to explore demand forecasting, inventory optimization, and dynamic pricing.

### Key Data Features
| Feature                | Type         | Description                                           |
|------------------------|--------------|-------------------------------------------------------|
| **Date**               | Date         | Daily timestamp                                       |
| **Store ID**           | Categorical  | Unique store identifier                               |
| **Product ID**         | Categorical  | Unique product identifier                             |
| **Category**           | Categorical  | Product category (Electronics, Clothing, Groceries)   |
| **Region**             | Categorical  | Geographic region                                     |
| **Inventory Level**    | Numerical    | Opening‑of‑day stock level                            |
| **Units Sold**         | Numerical    | **Target**: units sold per day                        |
| **Weather Condition**  | Categorical  | e.g. “Sunny”, “Rainy”                                 |
| **Holiday/Promotion**  | Binary       | 1 if holiday or promotion, else 0                    |

---

## 🧐 Analysis Objectives
1. **Demand Forecasting**: Predict next‑day units sold for each (store, product) pair.  
2. **Inventory Optimization**: Recommend restock levels to minimize stockouts and overstock.  
3. **Dynamic Pricing**: Explore pricing strategies based on demand signals, weather, and promotions.  

---

## 🚀 API

- **Predict Demand** (POST)  
