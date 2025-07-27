from fastapi import FastAPI, HTTPException, Body
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware
import joblib
import pandas as pd
import uvicorn

app = FastAPI(
    title="Retail Price Predictor API",
    description="Paste your JSON input to predict retail yield.",
    version="1.0.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load model and preprocessor
model = joblib.load("best_model.joblib")
preprocessor = joblib.load("preprocessor.joblib")


# Request model with embedded example for Swagger
class PriceRetail(BaseModel):
    Date: str
    Category: str
    Region: str
    Inventory_Level: int
    Units_Sold: int
    Units_Ordered: int
    Demand_Forecast: float
    Discount: float
    Weather_Condition: str
    Holiday_Promotion: int
    Seasonality: str
    Competitor_Pricing: float  # Add this field



# Prediction endpoint
@app.post("/predict_price", summary="Predict Retail Price")
async def predict_price(input_data: PriceRetail = Body(...)):
    """
    Predict the expected retail price based on sales and market input.
    """
    try:
        df_input = pd.DataFrame([input_data.dict()])

        # Rename keys to match the preprocessor expected columns (replace underscores with spaces)
        df_input.rename(columns={
        'Date': 'Date',
        'Category': 'Category',
        'Region': 'Region',
        'Inventory_Level': 'Inventory Level',
        'Units_Sold': 'Units Sold',
        'Units_Ordered': 'Units Ordered',
        'Demand_Forecast': 'Demand Forecast',
        'Discount': 'Discount',
        'Weather_Condition': 'Weather Condition',
        'Holiday_Promotion': 'Holiday/Promotion',
        'Seasonality': 'Seasonality',
        'Competitor_Pricing': 'Competitor Pricing'
        }, inplace=True)

        processed_input = preprocessor.transform(df_input)

        prediction = model.predict(processed_input)
        return {"predicted_price": round(float(prediction[0]), 2)}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Prediction failed: {str(e)}")

# Run the application
if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)