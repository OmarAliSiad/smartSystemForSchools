import os
import tempfile
import uvicorn
from fastapi import FastAPI, File, UploadFile
from fastapi.middleware.cors import CORSMiddleware
from food_recognition_model import FoodRecognitionModel
from pydantic import BaseModel
from typing import List, Dict, Any

app = FastAPI(title="Food AI Service", description="API for food recognition and allergen detection")

# Add CORS middleware to allow requests from Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Initialize the model
model = FoodRecognitionModel()

class FoodAnalysisResponse(BaseModel):
    foodType: str
    allergens: List[str]
    nutritionalInfo: Dict[str, float]
    confidenceScore: float

@app.get("/")
async def root():
    return {"message": "Food AI Service is running"}

@app.post("/analyze-food", response_model=FoodAnalysisResponse)
async def analyze_food(file: UploadFile = File(...)):
    # Save the uploaded file temporarily
    with tempfile.NamedTemporaryFile(delete=False) as temp_file:
        temp_file.write(await file.read())
        temp_file_path = temp_file.name
    
    try:
        # Analyze the food image
        result = model.predict(temp_file_path)
        
        # Return the analysis result
        return FoodAnalysisResponse(
            foodType=result['foodType'],
            allergens=result['allergens'],
            nutritionalInfo=result['nutritionalInfo'],
            confidenceScore=result['confidenceScore']
        )
    finally:
        # Clean up the temporary file
        os.unlink(temp_file_path)

if __name__ == "__main__":
    # Run the FastAPI server
    uvicorn.run(app, host="0.0.0.0", port=8000)