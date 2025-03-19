import os
import numpy as np
import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Flatten, Dense, Dropout
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.applications.mobilenet_v2 import preprocess_input
from tensorflow.keras.preprocessing import image
import json

class FoodRecognitionModel:
    def __init__(self, model_path=None):
        self.model = None
        self.class_names = []
        self.allergen_mapping = {
            'peanuts': ['peanut', 'peanuts', 'arachis hypogaea'],
            'tree_nuts': ['almond', 'hazelnut', 'walnut', 'cashew', 'pecan', 'brazil nut', 'macadamia'],
            'milk': ['milk', 'dairy', 'lactose', 'whey', 'casein', 'butter', 'cheese', 'cream'],
            'eggs': ['egg', 'eggs', 'albumin', 'globulin', 'ovomucoid'],
            'wheat': ['wheat', 'flour', 'gluten', 'semolina', 'durum', 'spelt'],
            'soy': ['soy', 'soya', 'soybean', 'tofu', 'edamame'],
            'fish': ['fish', 'cod', 'salmon', 'tuna', 'tilapia', 'pollock'],
            'shellfish': ['shellfish', 'crab', 'lobster', 'shrimp', 'prawn', 'crayfish', 'clam', 'mussel', 'oyster'],
            'sesame': ['sesame', 'tahini'],
            'mustard': ['mustard'],
            'celery': ['celery'],
            'lupin': ['lupin', 'lupine'],
            'sulfites': ['sulfite', 'sulphite', 'sulfur dioxide']
        }
        
        if model_path and os.path.exists(model_path):
            self.load_model(model_path)
        else:
            self._create_model()
    
    def _create_model(self):
        """Create a transfer learning model based on MobileNetV2"""
        # Use MobileNetV2 as base model (pre-trained on ImageNet)
        base_model = MobileNetV2(weights='imagenet', include_top=False, input_shape=(224, 224, 3))
        
        # Freeze the base model layers
        base_model.trainable = False
        
        # Create new model on top
        self.model = Sequential([
            base_model,
            MaxPooling2D(pool_size=(2, 2)),
            Flatten(),
            Dense(1024, activation='relu'),
            Dropout(0.5),
            Dense(512, activation='relu'),
            Dropout(0.3),
            Dense(100, activation='softmax')  # 100 food categories to start with
        ])
        
        # Compile the model
        self.model.compile(
            optimizer='adam',
            loss='categorical_crossentropy',
            metrics=['accuracy']
        )
        
        # Generate placeholder class names
        self.class_names = [f'food_category_{i}' for i in range(100)]
    
    def load_model(self, model_path):
        """Load a pre-trained model"""
        try:
            self.model = tf.keras.models.load_model(model_path)
            
            # Load class names if available
            class_names_path = os.path.join(os.path.dirname(model_path), 'class_names.json')
            if os.path.exists(class_names_path):
                with open(class_names_path, 'r') as f:
                    self.class_names = json.load(f)
            print(f"Model loaded successfully from {model_path}")
        except Exception as e:
            print(f"Error loading model: {e}")
            self._create_model()
    
    def save_model(self, model_path):
        """Save the model to disk"""
        try:
            self.model.save(model_path)
            
            # Save class names
            class_names_path = os.path.join(os.path.dirname(model_path), 'class_names.json')
            with open(class_names_path, 'w') as f:
                json.dump(self.class_names, f)
            print(f"Model saved successfully to {model_path}")
        except Exception as e:
            print(f"Error saving model: {e}")
    
    def train(self, train_data_dir, validation_data_dir, epochs=10, batch_size=32):
        """Train the model on food images"""
        # Data augmentation for training
        train_datagen = ImageDataGenerator(
            preprocessing_function=preprocess_input,
            rotation_range=20,
            width_shift_range=0.2,
            height_shift_range=0.2,
            shear_range=0.2,
            zoom_range=0.2,
            horizontal_flip=True,
            fill_mode='nearest'
        )
        
        # Only rescaling for validation
        validation_datagen = ImageDataGenerator(
            preprocessing_function=preprocess_input
        )
        
        # Flow training images in batches
        train_generator = train_datagen.flow_from_directory(
            train_data_dir,
            target_size=(224, 224),
            batch_size=batch_size,
            class_mode='categorical'
        )
        
        # Flow validation images in batches
        validation_generator = validation_datagen.flow_from_directory(
            validation_data_dir,
            target_size=(224, 224),
            batch_size=batch_size,
            class_mode='categorical'
        )
        
        # Update class names from the generator
        self.class_names = list(train_generator.class_indices.keys())
        
        # Train the model
        self.model.fit(
            train_generator,
            steps_per_epoch=train_generator.samples // batch_size,
            epochs=epochs,
            validation_data=validation_generator,
            validation_steps=validation_generator.samples // batch_size
        )
    
    def predict(self, img_path):
        """Predict food category from an image"""
        try:
            # Load and preprocess the image
            img = image.load_img(img_path, target_size=(224, 224))
            img_array = image.img_to_array(img)
            img_array = np.expand_dims(img_array, axis=0)
            img_array = preprocess_input(img_array)
            
            # Make prediction
            predictions = self.model.predict(img_array)
            predicted_class_index = np.argmax(predictions[0])
            confidence_score = float(predictions[0][predicted_class_index])
            
            # Get the predicted class name
            if predicted_class_index < len(self.class_names):
                predicted_class = self.class_names[predicted_class_index]
            else:
                predicted_class = f"unknown_class_{predicted_class_index}"
            
            # Mock allergens detection (in a real system, this would be based on a database)
            allergens = self._detect_allergens(predicted_class)
            
            # Mock nutritional info (in a real system, this would be based on a database)
            nutritional_info = self._get_nutritional_info(predicted_class)
            
            return {
                'foodType': predicted_class,
                'allergens': allergens,
                'nutritionalInfo': nutritional_info,
                'confidenceScore': confidence_score
            }
        except Exception as e:
            print(f"Error during prediction: {e}")
            return {
                'foodType': 'unknown',
                'allergens': [],
                'nutritionalInfo': {
                    'calories': 0,
                    'protein': 0,
                    'carbs': 0,
                    'fat': 0
                },
                'confidenceScore': 0.0,
                'error': str(e)
            }
    
    def _detect_allergens(self, food_type):
        """Detect potential allergens based on food type"""
        # This is a simplified mock implementation
        # In a real system, this would query a database of food ingredients
        
        # Convert food type to lowercase for matching
        food_type_lower = food_type.lower()
        
        detected_allergens = []
        
        # Check if the food type contains any allergen keywords
        for allergen, keywords in self.allergen_mapping.items():
            for keyword in keywords:
                if keyword in food_type_lower:
                    detected_allergens.append(allergen.replace('_', ' ').title())
                    break
        
        # If no allergens detected, return some mock data based on food type
        if not detected_allergens:
            if 'nut' in food_type_lower or 'peanut' in food_type_lower:
                detected_allergens.append('Peanuts')
                detected_allergens.append('Tree Nuts')
            elif 'milk' in food_type_lower or 'cheese' in food_type_lower or 'dairy' in food_type_lower:
                detected_allergens.append('Milk')
            elif 'bread' in food_type_lower or 'pasta' in food_type_lower or 'cake' in food_type_lower:
                detected_allergens.append('Gluten')
                detected_allergens.append('Wheat')
            elif 'fish' in food_type_lower or 'tuna' in food_type_lower or 'salmon' in food_type_lower:
                detected_allergens.append('Fish')
            elif 'shrimp' in food_type_lower or 'crab' in food_type_lower or 'lobster' in food_type_lower:
                detected_allergens.append('Shellfish')
            elif 'soy' in food_type_lower or 'tofu' in food_type_lower:
                detected_allergens.append('Soy')
            elif 'egg' in food_type_lower or 'omelet' in food_type_lower:
                detected_allergens.append('Eggs')
        
        return detected_allergens
    
    def _get_nutritional_info(self, food_type):
        """Get nutritional information based on food type"""
        # This is a simplified mock implementation
        # In a real system, this would query a database of nutritional information
        
        # Default values
        calories = 250
        protein = 10
        carbs = 30
        fat = 8
        
        # Adjust based on food type
        food_type_lower = food_type.lower()
        
        if 'salad' in food_type_lower or 'vegetable' in food_type_lower:
            calories = 100
            protein = 5
            carbs = 15
            fat = 3
        elif 'meat' in food_type_lower or 'chicken' in food_type_lower or 'beef' in food_type_lower:
            calories = 350
            protein = 30
            carbs = 5
            fat = 20
        elif 'fish' in food_type_lower or 'seafood' in food_type_lower:
            calories = 200
            protein = 25
            carbs = 5
            fat = 10
        elif 'dessert' in food_type_lower or 'cake' in food_type_lower or 'ice cream' in food_type_lower:
            calories = 400
            protein = 5
            carbs = 60
            fat = 15
        elif 'fruit' in food_type_lower or 'apple' in food_type_lower or 'banana' in food_type_lower:
            calories = 120
            protein = 1
            carbs = 30
            fat = 0
        
        return {
            'calories': calories,
            'protein': protein,
            'carbs': carbs,
            'fat': fat
        }

# Example usage
if __name__ == "__main__":
    # Initialize the model
    model = FoodRecognitionModel()
    
    # If you have training data, you can train the model
    # model.train('path/to/train_data', 'path/to/validation_data')
    
    # Save the model
    # model.save_model('path/to/save/model')
    
    # Make a prediction
    # result = model.predict('path/to/food/image.jpg')
    # print(result)