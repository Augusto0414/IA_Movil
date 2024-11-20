import flet as ft
import tensorflow as tf
import numpy as np
from PIL import Image
import os

CLASES = {
    0: 'Acacia', 1: 'Balsamo', 2: 'Camajon', 3: 'Carreto', 4: 'Cedro',
    5: 'Ceiba', 6: 'Corazón fino', 7: 'Ebano', 8: 'Guayacan', 9: 'Melina',
    10: 'Roble', 11: 'Tananeo', 12: 'Teca'
}

class ReconocedorMaderas:
    def __init__(self):
        self.interpreter = None
        self.cargar_modelo()

    def cargar_modelo(self):
        modelo_path = os.path.join(os.path.dirname(__file__), 'modelo_entrenado.h5')
        if os.path.exists(modelo_path):
            try:
                converter = tf.lite.TFLiteConverter.from_keras_model(tf.keras.models.load_model(modelo_path))
                tflite_model = converter.convert()
                tflite_model_path = os.path.join(os.path.dirname(__file__), 'modelo_entrenado.tflite')
                with open(tflite_model_path, 'wb') as f:
                    f.write(tflite_model)
                self.interpreter = tf.lite.Interpreter(model_path=tflite_model_path)
                self.interpreter.allocate_tensors()
                print("Modelo cargado exitosamente")
            except Exception as e:
                print(f"Error al cargar o convertir el modelo: {e}")
                self.interpreter = None
        else:
            print(f"No se encontró el archivo del modelo en {modelo_path}")

    def predecir(self, imagen):
        if self.interpreter is None:
            return "Modelo no cargado"
        try:
            imagen = imagen.resize((64, 64))
            imagen_array = np.array(imagen) / 255.0
            imagen_array = np.expand_dims(imagen_array, axis=0).astype(np.float32)
            input_details = self.interpreter.get_input_details()
            output_details = self.interpreter.get_output_details()
            self.interpreter.set_tensor(input_details[0]['index'], imagen_array)
            self.interpreter.invoke()
            prediccion = self.interpreter.get_tensor(output_details[0]['index'])
            clase_predicha = np.argmax(prediccion, axis=1)[0]
            return CLASES.get(clase_predicha, 'Clase desconocida')
        except Exception as e:
            return f"Error en la predicción: {e}"

def main(page: ft.Page):
    # Configuración de la página
    page.title = "Identificador de Especies Maderables"
    page.theme_mode = ft.ThemeMode.DARK
    page.padding = 0
    page.window_width = 400
    page.window_height = 800
    page.bgcolor = "#1a1a1a"

    reconocedor = ReconocedorMaderas()

    # Componentes de la UI
    resultado_texto = ft.Text(
        "Esperando imagen...",
        size=24,
        color=ft.colors.PRIMARY,
        text_align=ft.TextAlign.CENTER,
    )

    vista_imagen = ft.Image(
        width=300,
        height=300,
        fit=ft.ImageFit.CONTAIN,
        border_radius=ft.border_radius.all(15),
        src="/placeholder.png"  # Asegúrate de tener una imagen placeholder o quita esta línea
    )

    progress_ring = ft.ProgressRing(visible=False)

    # Función para procesar la imagen
    def procesar_imagen(e: ft.FilePickerResultEvent):
        if e.files:
            try:
                progress_ring.visible = True
                page.update()

                imagen = Image.open(e.files[0].path)
                resultado = reconocedor.predecir(imagen)
                resultado_texto.value = f"Especie: {resultado}"
                vista_imagen.src = e.files[0].path

                progress_ring.visible = False
                page.show_snack_bar(
                    ft.SnackBar(content=ft.Text("¡Imagen procesada con éxito!"))
                )
                page.update()
            except Exception as e:
                progress_ring.visible = False
                resultado_texto.value = f"Error: {str(e)}"
                page.update()

    # Selector de archivo
    selector_archivo = ft.FilePicker(on_result=procesar_imagen)
    page.overlay.append(selector_archivo)

    # Botones
    botones = ft.Row(
        [
            ft.ElevatedButton(
                "Cargar imagen",
                icon=ft.icons.UPLOAD_FILE,
                on_click=lambda _: selector_archivo.pick_files(
                    allow_multiple=False,
                    allowed_extensions=['png', 'jpg', 'jpeg']
                ),
                style=ft.ButtonStyle(
                    padding=20,
                    bgcolor=ft.colors.PRIMARY,
                ),
            ),
            ft.ElevatedButton(
                "Tomar foto",
                icon=ft.icons.CAMERA_ALT,
                on_click=lambda _: selector_archivo.take_photo(),
                style=ft.ButtonStyle(
                    padding=20,
                    bgcolor=ft.colors.SECONDARY,
                ),
            ),
        ],
        alignment=ft.MainAxisAlignment.CENTER,
        spacing=20,
    )

    # Contenedor principal
    contenedor_principal = ft.Container(
        content=ft.Column(
            [
                ft.Container(
                    content=ft.Text(
                        "Identificador de Especies Maderables",
                        size=24,
                        weight=ft.FontWeight.BOLD,
                        text_align=ft.TextAlign.CENTER,
                    ),
                    padding=20,
                ),
                ft.Container(
                    content=vista_imagen,
                    margin=20,
                    padding=10,
                    border_radius=ft.border_radius.all(15),
                    bgcolor=ft.colors.SURFACE_VARIANT,
                ),
                progress_ring,
                ft.Container(
                    content=resultado_texto,
                    margin=20,
                    padding=20,
                    border_radius=ft.border_radius.all(10),
                    bgcolor=ft.colors.SURFACE_VARIANT,
                ),
                ft.Container(
                    content=botones,
                    margin=20,
                ),
            ],
            horizontal_alignment=ft.CrossAxisAlignment.CENTER,
            scroll=ft.ScrollMode.AUTO,
        ),
        padding=20,
    )

    # Agregar el contenedor a la página
    page.add(contenedor_principal)

if __name__ == '__main__':
    ft.app(target=main)