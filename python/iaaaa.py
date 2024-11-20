import tkinter as tk
from tkinter import filedialog, messagebox
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.applications import MobileNet
from tensorflow.keras import layers, models, optimizers
import tensorflow as tf
import os

class EntrenamientoMobileNetApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Entrenamiento de MobileNet")
        self.root.geometry("400x400")

        self.directorio_datos = ""
        self.epochs = tk.IntVar(value=10)
        self.batch_size = tk.IntVar(value=32)
        self.tamano_img = tk.IntVar(value=224)

        # Crear widgets
        tk.Label(root, text="Entrenamiento de MobileNet", font=("Arial", 16)).pack(pady=10)

        tk.Button(root, text="Seleccionar directorio de datos", command=self.seleccionar_directorio).pack(pady=5)
        tk.Label(root, text="Épocas:").pack(pady=5)
        tk.Entry(root, textvariable=self.epochs).pack()

        tk.Label(root, text="Tamaño del batch:").pack(pady=5)
        tk.Entry(root, textvariable=self.batch_size).pack()

        tk.Label(root, text="Tamaño de imagen:").pack(pady=5)
        tk.Entry(root, textvariable=self.tamano_img).pack()

        tk.Button(root, text="Iniciar Entrenamiento", command=self.iniciar_entrenamiento).pack(pady=20)

    def seleccionar_directorio(self):
        self.directorio_datos = filedialog.askdirectory()
        if self.directorio_datos:
            messagebox.showinfo("Directorio seleccionado", f"Directorio seleccionado: {self.directorio_datos}")

    def iniciar_entrenamiento(self):
        if not self.directorio_datos:
            messagebox.showwarning("Advertencia", "Por favor, selecciona un directorio de datos.")
            return

        try:
            img_size = self.tamano_img.get()
            batch_size = self.batch_size.get()
            epochs = self.epochs.get()

            # Configurar el generador de datos
            datagen = ImageDataGenerator(validation_split=0.2, rescale=1./255)
            train_data = datagen.flow_from_directory(
                self.directorio_datos,
                target_size=(img_size, img_size),
                batch_size=batch_size,
                subset='training',
                class_mode='categorical'
            )
            val_data = datagen.flow_from_directory(
                self.directorio_datos,
                target_size=(img_size, img_size),
                batch_size=batch_size,
                subset='validation',
                class_mode='categorical'
            )

            # Cargar MobileNet con pesos preentrenados en ImageNet
            base_model = MobileNet(weights='imagenet', include_top=False, input_shape=(img_size, img_size, 3))
            base_model.trainable = False

            # Construir modelo
            model = models.Sequential([
                base_model,
                layers.GlobalAveragePooling2D(),
                layers.Dense(128, activation='relu'),
                layers.Dense(train_data.num_classes, activation='softmax')
            ])

            # Compilar modelo
            model.compile(optimizer=optimizers.Adam(), loss='categorical_crossentropy', metrics=['accuracy'])

            # Entrenar modelo
            history = model.fit(train_data, epochs=epochs, validation_data=val_data)

            # Guardar el modelo como TFLite
            self.guardar_modelo_tflite(model)
            messagebox.showinfo("Éxito", "Entrenamiento completado y modelo guardado en formato TFLite.")

        except Exception as e:
            messagebox.showerror("Error", str(e))

    def guardar_modelo_tflite(self, model):
        # Convertir el modelo a TFLite
        converter = tf.lite.TFLiteConverter.from_keras_model(model)
        tflite_model = converter.convert()

        # Guardar el archivo TFLite
        with open("modelo_mobilenet.tflite", "wb") as f:
            f.write(tflite_model)

if __name__ == "__main__":
    root = tk.Tk()
    app = EntrenamientoMobileNetApp(root)
    root.mainloop()
