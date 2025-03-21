# Limpieza de Marcadores

## Descripción

**Limpieza de Marcadores** es una herramienta de escritorio desarrollada en PowerShell que permite limpiar marcadores (favoritos) de navegadores en formato HTML. Utiliza una interfaz gráfica sencilla para permitir al usuario seleccionar un archivo HTML de marcadores, eliminar duplicados basándose en la URL y guardar el archivo limpio de manera fácil.

La aplicación es útil para usuarios que almacenan muchos marcadores en sus navegadores y desean limpiar los duplicados de forma rápida sin tener que hacerlo manualmente.

## Funcionalidades

- **Selección de archivo de entrada:** Permite seleccionar un archivo HTML que contenga los marcadores que se desean limpiar.
- **Eliminación de duplicados:** La herramienta analiza los marcadores en el archivo y elimina los duplicados, considerando la URL.
- **Barra de progreso:** Mientras el proceso de limpieza se realiza, la aplicación muestra una barra de progreso que indica el avance de la tarea.
- **Interfaz gráfica de usuario (GUI):** Se proporciona una interfaz simple y amigable para que el usuario pueda interactuar sin necesidad de conocimientos técnicos.
- **Generación del archivo limpio:** Después de eliminar los duplicados, se puede guardar el archivo limpio en la ubicación seleccionada por el usuario.
- **Botón de salida:** Al finalizar el proceso, el usuario puede cerrar la aplicación mediante el botón "Salir". Un mensaje de agradecimiento se mostrará antes de salir.

## Limitaciones

- **Solo archivos HTML:** La aplicación solo puede procesar archivos HTML que contengan marcadores. No es compatible con otros formatos de archivo o navegadores que no guarden sus marcadores en formato HTML.
- **No compatible con todos los navegadores:** Aunque la mayoría de los navegadores populares como Chrome y Firefox utilizan un formato HTML estándar para guardar marcadores, no todos los navegadores son compatibles con esta herramienta. Si el archivo HTML contiene un formato no estándar o tiene una estructura diferente, los resultados pueden no ser óptimos.
- **Falta de características avanzadas:** Esta herramienta está enfocada únicamente en la limpieza de marcadores y no ofrece características avanzadas como la organización de los marcadores o la exportación a otros formatos.

## Instalación

1. **Descargar la carpeta entera de la aplicación:** Obtén el archivo `limpiar_marcadores.ps1` y el archivo `limpiar_marcadores.bat` y `icono.ico`de este repositorio.
2. **Ejecutar la aplicación:**
   - Haz doble clic en el archivo `limpiar_marcadores.bat` para ejecutar el programa.
   - Se abrirá la ventana de PowerShell y se lanzará la interfaz gráfica de la aplicación.
3. **Sigue las instrucciones en pantalla:** La interfaz de usuario te guiará a través del proceso de selección del archivo HTML de marcadores y de la ubicación para guardar el archivo limpio.

## Uso

1. **Seleccionar archivo HTML:** Haz clic en el botón "Seleccionar Archivo HTML" para elegir el archivo que contiene los marcadores a limpiar.
2. **Seleccionar ubicación de salida:** Haz clic en el botón "Guardar Como..." para elegir dónde guardar el archivo limpio.
3. **Iniciar limpieza:** Haz clic en el botón "Iniciar Limpieza" para comenzar el proceso de eliminación de duplicados.
4. **Salir:** Después de que el proceso termine, puedes hacer clic en el botón "Salir". Un mensaje de agradecimiento aparecerá antes de cerrar la aplicación.

## Agradecimientos

Gracias por usar esta herramienta. Sabemos que muchas veces las extensiones de los navegadores no cumplen con lo esperado, por lo que hemos creado esta solución. Si modificas el programa, asegúrate de darle crédito al creador del código base.

Un saludo desde Costa Rica.  
Mike Sosa

## Contribuciones

Este proyecto es de código abierto, y puedes contribuir modificando el código, mejorando la funcionalidad o reportando problemas. Si deseas colaborar, por favor crea un fork y envía un pull request con tus mejoras.
