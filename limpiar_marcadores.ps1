# Cargar librerías para la interfaz gráfica
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Crear ventana principal
$form = New-Object System.Windows.Forms.Form
$form.Text = "Limpieza de Marcadores by mikesosa26@gmail.com"  # Nombre de la ventana actualizado
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen"

# Buscar el icono en la misma carpeta que el script
$scriptPath = [System.IO.Path]::GetDirectoryName($MyInvocation.MyCommand.Path)
$iconPath = [System.IO.Path]::Combine($scriptPath, "icono.ico")

# Verificar si el icono existe y asignarlo
if (Test-Path $iconPath) {
    $form.Icon = New-Object System.Drawing.Icon($iconPath)
} else {
    Write-Warning "El archivo del icono no se encuentra en la carpeta del script."
}

# Barra de progreso
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 200)
$progressBar.Size = New-Object System.Drawing.Size(350, 30)
$progressBar.Style = "Blocks"
$form.Controls.Add($progressBar)

# Etiqueta para mostrar porcentaje
$lblProgress = New-Object System.Windows.Forms.Label
$lblProgress.Location = New-Object System.Drawing.Point(20, 240)
$lblProgress.Size = New-Object System.Drawing.Size(350, 30)
$lblProgress.Text = "0% Completado"
$form.Controls.Add($lblProgress)

# Función para redondear bordes de los botones
function Round-Button($button) {
    $button.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $button.BackColor = [System.Drawing.Color]::LightSkyBlue
    $button.ForeColor = [System.Drawing.Color]::Black
    $button.FlatAppearance.BorderSize = 0  # Sin borde visible
    $button.FlatAppearance.MouseOverBackColor = [System.Drawing.Color]::DodgerBlue
    $button.FlatAppearance.MouseDownBackColor = [System.Drawing.Color]::RoyalBlue

    # Definir bordes redondeados usando GraphicsPath
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc(0, 0, 20, 20, 180, 90)
    $path.AddArc($button.Width - 20, 0, 20, 20, 270, 90)
    $path.AddArc($button.Width - 20, $button.Height - 20, 20, 20, 0, 90)
    $path.AddArc(0, $button.Height - 20, 20, 20, 90, 90)
    $path.CloseFigure()
    $button.Region = New-Object System.Drawing.Region($path)
}

# Botón para seleccionar archivo de entrada
$btnSelectFile = New-Object System.Windows.Forms.Button
$btnSelectFile.Text = "Seleccionar Archivo HTML"
$btnSelectFile.Location = New-Object System.Drawing.Point(20, 20)
$btnSelectFile.Size = New-Object System.Drawing.Size(350, 30)
Round-Button $btnSelectFile
$form.Controls.Add($btnSelectFile)

# Botón para seleccionar ubicación de guardado
$btnSaveFile = New-Object System.Windows.Forms.Button
$btnSaveFile.Text = "Guardar Como..."
$btnSaveFile.Location = New-Object System.Drawing.Point(20, 60)
$btnSaveFile.Size = New-Object System.Drawing.Size(350, 30)
Round-Button $btnSaveFile
$form.Controls.Add($btnSaveFile)

# Botón para iniciar el proceso
$btnStart = New-Object System.Windows.Forms.Button
$btnStart.Text = "Iniciar Limpieza"
$btnStart.Location = New-Object System.Drawing.Point(20, 100)
$btnStart.Size = New-Object System.Drawing.Size(350, 30)
$btnStart.Enabled = $false
Round-Button $btnStart
$form.Controls.Add($btnStart)

# Botón de salir
$btnExit = New-Object System.Windows.Forms.Button
$btnExit.Text = "Salir"
$btnExit.Location = New-Object System.Drawing.Point(20, 140)
$btnExit.Size = New-Object System.Drawing.Size(350, 30)
$btnExit.Visible = $true
$btnExit.Add_Click({
    $thankYouMessage = "Gracias por usar esta herramienta, se que muchos pasan por este problema y las extensiones de los navegadores no cumplen.`nUn saludo desde Costa Rica.`n`nSi modificas el programa, asegurate de darle credito al creador del codigo base, respeta mi trabajo.`nMike Sosa"
    [System.Windows.Forms.MessageBox]::Show($thankYouMessage, "Agradecimiento", "OK", "Information")
    $form.Close()
})
Round-Button $btnExit
$form.Controls.Add($btnExit)

# Variables globales para archivos
$global:inputFile = $null
$global:outputFile = $null

# Evento para seleccionar archivo de entrada
$btnSelectFile.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Archivos HTML (*.html)|*.html"
    if ($openFileDialog.ShowDialog() -eq "OK") {
        $global:inputFile = $openFileDialog.FileName
        if ($global:inputFile -and $global:outputFile) { $btnStart.Enabled = $true }
    }
})

# Evento para seleccionar archivo de salida
$btnSaveFile.Add_Click({
    $saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = "Archivos HTML (*.html)|*.html"
    if ($saveFileDialog.ShowDialog() -eq "OK") {
        $global:outputFile = $saveFileDialog.FileName
        if ($global:inputFile -and $global:outputFile) { $btnStart.Enabled = $true }
    }
})

# Evento para iniciar el proceso de limpieza
$btnStart.Add_Click({
    if (-Not $global:inputFile -or -Not $global:outputFile) {
        [System.Windows.Forms.MessageBox]::Show("Debes seleccionar un archivo de entrada y salida.", "Error", "OK", "Error")
        return
    }

    try {
        # Leer el archivo de marcadores
        $bookmarks = Get-Content $global:inputFile -Raw

        # Expresión regular para encontrar enlaces <A HREF>
        $linkPattern = '<A HREF="(.*?)".*?ADD_DATE="(\d+)".*?>(.*?)</A>'
        $matches = [regex]::Matches($bookmarks, $linkPattern)

        # Función para normalizar la URL
        function Normalize-Url {
            param ([string]$url)
            $url = $url -replace '\?.*$', ''  # Quitar parámetros de la URL
            $url = $url -replace '#.*$', ''   # Quitar anclajes
            return $url.ToLower()
        }

        # Diccionario para almacenar enlaces únicos
        $linkDict = @{ }
        $totalMatches = $matches.Count
        $progressBar.Value = 0
        $progressBar.Maximum = $totalMatches
        $lblProgress.Text = "0% Completado"

        $counter = 0
        foreach ($match in $matches) {
            $url = $match.Groups[1].Value
            $date = [int]$match.Groups[2].Value
            $htmlTag = $match.Value
            $normalizedUrl = Normalize-Url $url

            if (-Not $linkDict.ContainsKey($normalizedUrl) -or $date -gt $linkDict[$normalizedUrl]) {
                $linkDict[$normalizedUrl] = $date
            }

            # Actualizar la barra de progreso y el porcentaje
            $counter++
            $progressBar.Value = $counter
            $percentage = [math]::Round(($counter / $totalMatches) * 100)
            $lblProgress.Text = "$percentage% Completado"
            $form.Refresh()  # Forzar actualización del formulario para mostrar el progreso
        }

        # Escribir el archivo de salida limpio
        $cleanBookmarks = $bookmarks
        foreach ($url in $linkDict.Keys) {
            $cleanBookmarks = $cleanBookmarks -replace "(<A HREF=""$url"".*?</A>)", ""
        }

        Set-Content $global:outputFile -Value $cleanBookmarks
        [System.Windows.Forms.MessageBox]::Show("Limpieza completada.", "Éxito", "OK", "Information")
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Hubo un error durante el proceso.", "Error", "OK", "Error")
    }
})

# Mostrar el formulario
$form.ShowDialog()
