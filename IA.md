# Implementación de Asistente Financiero Inteligente con LLM
## Guía paso a paso para Conexión Consultora

## Índice
1. [Arquitectura general](#1-arquitectura-general)
2. [Extracción y preparación de datos](#2-extracción-y-preparación-de-datos)
3. [Integración del modelo LLM](#3-integración-del-modelo-llm)
4. [Construcción de prompts efectivos](#4-construcción-de-prompts-efectivos)
5. [Validación y confiabilidad](#5-validación-y-confiabilidad)
6. [Generación de informes profesionales](#6-generación-de-informes-profesionales)
7. [Implementación técnica detallada](#7-implementación-técnica-detallada)
8. [Consideraciones de seguridad](#8-consideraciones-de-seguridad)
9. [Pruebas y evaluación](#9-pruebas-y-evaluación)
10. [Estrategias de respaldo y contingencia](#10-estrategias-de-respaldo-y-contingencia)

## 1. Arquitectura general

### 1.1 Componentes principales

```
[Base de Datos] ←→ [Capa de Servicios] ←→ [Controlador IA] ←→ [API LLM] ←→ [Frontend]
```

El flujo completo funciona así:

1. **Usuario:** Realiza una consulta en lenguaje natural como "¿Cuál fue la rentabilidad en Mercedes durante el primer trimestre?"
2. **Frontend:** Captura la consulta y la envía al controlador de IA
3. **Controlador IA:** Coordina el proceso completo
4. **Analizador de consultas:** Interpreta qué se está pidiendo
5. **Servicios de datos:** Extraen los datos financieros relevantes
6. **Generador de prompts:** Construye el mensaje para el LLM
7. **API LLM:** Procesa el prompt y genera una respuesta
8. **Validador:** Verifica que la respuesta sea precisa y coherente
9. **Frontend:** Muestra la respuesta al usuario

### 1.2 Componentes en detalle (nombres en español)

```ruby
# app/
# ├── controladores/
# │   └── consultas_ia_controlador.rb
# ├── servicios/
# │   ├── ia/
# │   │   ├── analizador_consultas_servicio.rb
# │   │   ├── generador_prompts_servicio.rb
# │   │   ├── cliente_llm_servicio.rb
# │   │   └── validador_respuestas_servicio.rb
# │   ├── datos/
# │   │   ├── metricas_financieras_servicio.rb
# │   │   ├── rentabilidad_servicio.rb
# │   │   └── analisis_clientes_servicio.rb
# │   └── informes/
# │       └── generador_pdf_servicio.rb
# └── modelos/
#     ├── ingreso.rb
#     ├── gasto.rb
#     ├── retiro_utilidad.rb
#     └── distribucion_utilidad.rb
```

## 2. Extracción y preparación de datos

### 2.1 ¿Quién realiza los cálculos?

Los cálculos financieros los realiza **TU APLICACIÓN**, no el LLM. Este es un punto crítico para garantizar la precisión:

1. **Servicios especializados** en tu aplicación extraen y calculan:
   - Saldos netos
   - Rentabilidad
   - Facturación por área
   - Comparativas temporales

2. **El LLM NO realiza cálculos financieros**, solo:
   - Interpreta la pregunta
   - Formula una respuesta en lenguaje natural
   - Organiza la información calculada previamente

### 2.2 Extracción de datos para consultas específicas

```ruby
# app/servicios/datos/metricas_financieras_servicio.rb
class MetricasFinancierasServicio
  def initialize(parametros = {})
    @fecha_inicio = parametros[:fecha_inicio] || Date.today.beginning_of_month
    @fecha_fin = parametros[:fecha_fin] || Date.today
    @sucursal = parametros[:sucursal] # 'Montevideo', 'Mercedes' o nil para todas
    @moneda = parametros[:moneda] || 'UYU'
    @area = parametros[:area] # 'Jurídica', 'Notarial', etc.
  end
  
  def saldo_neto
    ingresos_total = calcular_ingresos
    gastos_total = calcular_gastos
    
    {
      ingresos: ingresos_total,
      gastos: gastos_total,
      saldo: ingresos_total - gastos_total,
      moneda: @moneda
    }
  end
  
  def rentabilidad
    datos = saldo_neto
    rentabilidad_valor = datos[:ingresos] > 0 ? (datos[:saldo] / datos[:ingresos] * 100).round(2) : 0
    
    {
      rentabilidad_porcentaje: rentabilidad_valor,
      periodo: "#{@fecha_inicio.strftime('%d/%m/%Y')} - #{@fecha_fin.strftime('%d/%m/%Y')}",
      sucursal: @sucursal || 'Todas',
      moneda: @moneda
    }
  end
  
  def facturacion_por_area
    # Consulta a la base de datos agrupando por área
    areas = Ingreso.where(fecha: @fecha_inicio..@fecha_fin)
                   .where(sucursal: @sucursal) if @sucursal
                   .group(:area)
                   .sum(:monto)
                   
    # Convertir moneda si es necesario
    if @moneda == 'USD'
      areas.transform_values! { |valor| convertir_a_dolares(valor) }
    end
    
    # Ordenar de mayor a menor
    areas.sort_by { |_, valor| -valor }.to_h
  end
  
  def top_clientes(limite = 3)
    # Consulta para obtener los clientes con mayor facturación
    Ingreso.where(fecha: @fecha_inicio..@fecha_fin)
           .where(sucursal: @sucursal) if @sucursal
           .joins(:cliente)
           .group('clientes.nombre')
           .select('clientes.nombre, SUM(ingresos.monto) as total')
           .order('total DESC')
           .limit(limite)
           .map do |resultado|
             monto = @moneda == 'USD' ? convertir_a_dolares(resultado.total) : resultado.total
             {
               nombre: resultado.nombre,
               monto: monto,
               moneda: @moneda
             }
           end
  end
  
  private
  
  def calcular_ingresos
    # Implementación de la consulta a la base de datos
  end
  
  def calcular_gastos
    # Implementación de la consulta a la base de datos
  end
  
  def convertir_a_dolares(monto_pesos)
    tipo_cambio = TipoCambioServicio.obtener_actual
    monto_pesos / tipo_cambio
  end
end
```

## 3. Integración del modelo LLM

### 3.1 Cliente para API del LLM

```ruby
# app/servicios/ia/cliente_llm_servicio.rb
class ClienteLlmServicio
  API_URL = ENV['LLM_API_URL']
  API_KEY = ENV['LLM_API_KEY']
  
  def self.generar_respuesta(prompt)
    # Configurar la solicitud
    cuerpo_solicitud = {
      model: ENV['LLM_MODEL_ID'], # "gpt-4" o "claude-3-opus-20240229"
      messages: [
        { role: "system", content: configurar_instrucciones_sistema },
        { role: "user", content: prompt }
      ],
      max_tokens: 1500,
      temperature: 0.3 # Valor bajo para respuestas más consistentes
    }
    
    # Enviar solicitud a la API
    respuesta = HTTParty.post(
      API_URL,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{API_KEY}"
      },
      body: cuerpo_solicitud.to_json
    )
    
    # Manejar la respuesta
    if respuesta.success?
      JSON.parse(respuesta.body)['choices'][0]['message']['content']
    else
      # Manejar errores y realizar reintentos si es necesario
      Rails.logger.error("Error en API LLM: #{respuesta.body}")
      sistema_respaldo(prompt)
    end
  rescue => e
    # Capturar cualquier error de conexión
    Rails.logger.error("Excepción en API LLM: #{e.message}")
    sistema_respaldo(prompt)
  end
  
  private
  
  def self.configurar_instrucciones_sistema
    <<~INSTRUCCIONES
      Eres el asistente financiero especializado de Conexión Consultora, una empresa 
      uruguaya de servicios profesionales con oficinas en Montevideo y Mercedes.
      
      Responde preguntas financieras basándote ÚNICAMENTE en los datos proporcionados 
      en cada consulta. No inventes cifras ni hagas estimaciones que no estén respaldadas 
      por los datos proporcionados.
      
      Utiliza un tono profesional y conciso. Cuando sea apropiado, menciona tendencias 
      o comparativas que se evidencien en los datos.
      
      IMPORTANTE: No realices cálculos por tu cuenta. Usa exactamente los valores 
      numéricos proporcionados en la consulta.
    INSTRUCCIONES
  end
  
  def self.sistema_respaldo(prompt)
    # Implementación de respaldo si la API falla
    # Podría ser una respuesta predefinida o un sistema alternativo
    "Lo siento, no puedo procesar tu consulta en este momento. Por favor, intenta más tarde."
  end
end
```

### 3.2 Fallback entre proveedores de LLM

Para mayor disponibilidad, puedes implementar un sistema de respaldo entre distintos proveedores (OpenAI, Anthropic, etc.):

```ruby
# app/servicios/ia/cliente_llm_servicio.rb (ampliado)
def self.generar_respuesta(prompt)
  # Intentar con proveedor primario
  respuesta = llamar_api_primaria(prompt)
  return respuesta if respuesta
  
  # Si falla, intentar con proveedor secundario
  respuesta = llamar_api_secundaria(prompt)
  return respuesta if respuesta
  
  # Si todo falla, usar respuesta de respaldo
  sistema_respaldo(prompt)
end

def self.llamar_api_primaria(prompt)
  # Implementación para OpenAI
  # ...
rescue => e
  Rails.logger.error("Error en API primaria: #{e.message}")
  nil
end

def self.llamar_api_secundaria(prompt)
  # Implementación para Anthropic/Claude
  # ...
rescue => e
  Rails.logger.error("Error en API secundaria: #{e.message}")
  nil
end
```

## 4. Construcción de prompts efectivos

### 4.1 Estructura básica del prompt

```ruby
# app/servicios/ia/generador_prompts_servicio.rb
class GeneradorPromptsServicio
  def self.crear_para_consulta(consulta_usuario, datos_financieros)
    <<~PROMPT
      # CONSULTA DEL USUARIO
      #{consulta_usuario}
      
      # DATOS FINANCIEROS PRECISOS
      #{formatear_datos(datos_financieros)}
      
      # INSTRUCCIONES
      Responde a la consulta del usuario utilizando EXCLUSIVAMENTE los datos financieros proporcionados.
      Sé claro, preciso y profesional. No agregues información que no esté en los datos.
      Si hay alguna ambigüedad o faltan datos, indícalo claramente.
    PROMPT
  end
  
  def self.crear_para_informe(parametros_informe, datos_financieros)
    <<~PROMPT
      # SOLICITUD DE INFORME
      Tipo de informe: #{parametros_informe[:tipo]}
      Período: #{parametros_informe[:periodo]}
      Enfoque: #{parametros_informe[:enfoque]}
      
      # DATOS FINANCIEROS PRECISOS
      #{formatear_datos(datos_financieros)}
      
      # INSTRUCCIONES
      Genera un informe financiero profesional que incluya:
      1. Un título descriptivo
      2. Un resumen ejecutivo (máximo 3 párrafos)
      3. Secciones relevantes según el tipo de informe
      4. Conclusiones basadas estrictamente en los datos proporcionados
      5. Recomendaciones si son pertinentes
      
      Usa un tono profesional. No inventes datos ni hagas suposiciones más allá de lo proporcionado.
    PROMPT
  end
  
  private
  
  def self.formatear_datos(datos)
    # Convierte el hash de datos en un formato legible
    # Este método es clave para presentar los datos de manera estructurada al LLM
    resultado = ""
    
    if datos[:saldo_neto].present?
      resultado += "## Saldo Neto\n"
      resultado += "- Ingresos: #{formatear_moneda(datos[:saldo_neto][:ingresos], datos[:saldo_neto][:moneda])}\n"
      resultado += "- Gastos: #{formatear_moneda(datos[:saldo_neto][:gastos], datos[:saldo_neto][:moneda])}\n"
      resultado += "- Saldo: #{formatear_moneda(datos[:saldo_neto][:saldo], datos[:saldo_neto][:moneda])}\n\n"
    end
    
    if datos[:rentabilidad].present?
      resultado += "## Rentabilidad\n"
      resultado += "- Porcentaje: #{datos[:rentabilidad][:rentabilidad_porcentaje]}%\n"
      resultado += "- Período: #{datos[:rentabilidad][:periodo]}\n"
      resultado += "- Sucursal: #{datos[:rentabilidad][:sucursal]}\n\n"
    end
    
    if datos[:facturacion_areas].present?
      resultado += "## Facturación por Área\n"
      datos[:facturacion_areas].each do |area, monto|
        resultado += "- #{area}: #{formatear_moneda(monto, datos[:moneda])}\n"
      end
      resultado += "\n"
    end
    
    if datos[:top_clientes].present?
      resultado += "## Top Clientes\n"
      datos[:top_clientes].each_with_index do |cliente, index|
        resultado += "#{index + 1}. #{cliente[:nombre]}: #{formatear_moneda(cliente[:monto], cliente[:moneda])}\n"
      end
    end
    
    resultado
  end
  
  def self.formatear_moneda(monto, moneda)
    if moneda == 'USD'
      "USD #{monto.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1.')}"
    else
      "$U #{monto.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1.')}"
    end
  end
end
```

### 4.2 Ejemplos de prompts específicos

Para una consulta sobre rentabilidad:

```
# CONSULTA DEL USUARIO
¿Cuál fue la rentabilidad de la sucursal Mercedes en el primer trimestre de 2023?

# DATOS FINANCIEROS PRECISOS
## Rentabilidad
- Porcentaje: 27.5%
- Período: 01/01/2023 - 31/03/2023
- Sucursal: Mercedes

## Saldo Neto
- Ingresos: $U 3.854.600
- Gastos: $U 2.794.085
- Saldo: $U 1.060.515

## Comparativa
- Rentabilidad Montevideo mismo período: 38.7%
- Rentabilidad Mercedes trimestre anterior: 25.3%

# INSTRUCCIONES
Responde a la consulta del usuario utilizando EXCLUSIVAMENTE los datos financieros proporcionados.
Sé claro, preciso y profesional. No agregues información que no esté en los datos.
Si hay alguna ambigüedad o faltan datos, indícalo claramente.
```

## 5. Validación y confiabilidad

### 5.1 Validador de respuestas

```ruby
# app/servicios/ia/validador_respuestas_servicio.rb
class ValidadorRespuestasServicio
  def self.validar(respuesta, datos_originales)
    # Verificar que la respuesta no contenga información inventada
    validar_cifras(respuesta, datos_originales)
  end
  
  def self.validar_cifras(respuesta, datos_originales)
    # Extraer cifras numéricas de la respuesta
    cifras_en_respuesta = extraer_cifras(respuesta)
    
    # Obtener todas las cifras de los datos originales
    cifras_originales = extraer_todas_cifras(datos_originales)
    
    # Si hay cifras en la respuesta que no están en los datos originales
    # (con cierto margen de error para redondeos)
    cifras_invalidas = cifras_en_respuesta.reject do |cifra|
      cifras_originales.any? do |original|
        (cifra - original).abs < 0.01 * original # 1% de margen de error
      end
    end
    
    if cifras_invalidas.any?
      # Hay cifras sospechosas en la respuesta
      {
        valido: false,
        motivo: "La respuesta contiene cifras que no coinciden con los datos proporcionados",
        cifras_problematicas: cifras_invalidas
      }
    else
      { valido: true }
    end
  end
  
  private
  
  def self.extraer_cifras(texto)
    # Extraer números de la respuesta
    # Implementación usando expresiones regulares
    texto.scan(/[0-9]+[.,][0-9]+/).map(&:to_f)
  end
  
  def self.extraer_todas_cifras(datos)
    # Método para extraer todas las cifras numéricas del hash de datos
    # Implementación recorriendo recursivamente el hash
    cifras = []
    
    # Método recursivo para extraer valores numéricos de hash/arrays anidados
    extract = ->(obj) {
      case obj
      when Numeric
        cifras << obj
      when Hash
        obj.values.each { |v| extract.call(v) }
      when Array
        obj.each { |v| extract.call(v) }
      end
    }
    
    extract.call(datos)
    cifras
  end
end
```

### 5.2 Estrategias de confiabilidad adicionales

1. **Regeneración de respuestas:**
   Si una respuesta no pasa la validación, se puede solicitar una nueva al LLM con instrucciones más precisas.

2. **Marcado de fuente de datos:**
   Asegurar que cada respuesta indique de dónde provienen los datos que menciona.

3. **Restricción de respuestas:**
   Configurar el LLM para que responda "No tengo suficiente información" cuando la consulta requiera datos no proporcionados.

## 6. Generación de informes profesionales

### 6.1 Controlador para gestionar informes

```ruby
# app/controladores/informes_controlador.rb
class InformesControlador < ApplicationController
  before_action :autenticar_usuario
  
  def nuevo
    # Renderiza el formulario para solicitar un informe
  end
  
  def crear
    # Parámetros para el informe
    parametros = {
      tipo: params[:tipo_informe],      # "rentabilidad", "facturacion", etc.
      periodo: {
        inicio: Date.parse(params[:fecha_inicio]),
        fin: Date.parse(params[:fecha_fin])
      },
      sucursal: params[:sucursal],      # "Montevideo", "Mercedes" o nil para consolidado
      moneda: params[:moneda],          # "UYU" o "USD"
      enfoque: params[:enfoque]         # "áreas", "clientes", "evolución temporal", etc.
    }
    
    # Recopilar los datos necesarios
    datos_financieros = recopilar_datos(parametros)
    
    # Generar el informe con LLM
    contenido_informe = generar_contenido_informe(parametros, datos_financieros)
    
    # Generar PDF corporativo
    pdf = GeneradorPdfServicio.crear_informe(contenido_informe, parametros)
    
    # Enviar el archivo al usuario
    send_data pdf, 
              filename: "informe_#{parametros[:tipo]}_#{Date.today.strftime('%Y%m%d')}.pdf", 
              type: "application/pdf", 
              disposition: "attachment"
  end
  
  private
  
  def recopilar_datos(parametros)
    # Crear instancia del servicio de métricas con los parámetros
    servicio = MetricasFinancierasServicio.new(
      fecha_inicio: parametros[:periodo][:inicio],
      fecha_fin: parametros[:periodo][:fin],
      sucursal: parametros[:sucursal],
      moneda: parametros[:moneda]
    )
    
    # Recopilar todos los datos relevantes según el tipo de informe
    case parametros[:tipo]
    when "rentabilidad"
      {
        saldo_neto: servicio.saldo_neto,
        rentabilidad: servicio.rentabilidad,
        comparativa_periodo_anterior: servicio.comparar_con_periodo_anterior,
        desglose_mensual: servicio.rentabilidad_mensual
      }
    when "facturacion"
      {
        facturacion_total: servicio.facturacion_total,
        facturacion_areas: servicio.facturacion_por_area,
        top_clientes: servicio.top_clientes(5),
        evolucion_mensual: servicio.facturacion_mensual
      }
    when "completo"
      {
        saldo_neto: servicio.saldo_neto,
        rentabilidad: servicio.rentabilidad,
        facturacion_areas: servicio.facturacion_por_area,
        top_clientes: servicio.top_clientes,
        gastos_principales: servicio.principales_gastos,
        proyeccion_proximo_mes: servicio.proyectar_proximo_mes
      }
    else
      # Informe básico por defecto
      {
        saldo_neto: servicio.saldo_neto,
        rentabilidad: servicio.rentabilidad
      }
    end
  end
  
  def generar_contenido_informe(parametros, datos_financieros)
    # Crear prompt especializado para informes
    prompt = GeneradorPromptsServicio.crear_para_informe(parametros, datos_financieros)
    
    # Solicitar al LLM que genere el contenido del informe
    contenido = ClienteLlmServicio.generar_respuesta(prompt)
    
    # Validar el contenido generado
    resultado_validacion = ValidadorRespuestasServicio.validar(contenido, datos_financieros)
    
    if resultado_validacion[:valido]
      return contenido
    else
      # Si el contenido no es válido, regenerar con advertencias adicionales
      prompt_revisado = prompt + "\n\nADVERTENCIA: La respuesta anterior contenía información incorrecta. Asegúrate de usar EXACTAMENTE los datos proporcionados."
      ClienteLlmServicio.generar_respuesta(prompt_revisado)
    end
  end
end
```

### 6.2 Servicio de generación de PDF

```ruby
# app/servicios/informes/generador_pdf_servicio.rb
class GeneradorPdfServicio
  require 'prawn'
  
  def self.crear_informe(contenido, parametros)
    # Parsear el contenido generado por el LLM
    # Asumimos que viene estructurado con títulos y secciones
    secciones = parsear_contenido(contenido)
    
    # Generar el PDF
    Prawn::Document.new do |pdf|
      # Configurar el documento
      configurar_documento(pdf)
      
      # Agregar encabezado corporativo
      agregar_encabezado(pdf, parametros)
      
      # Agregar el título del informe
      pdf.text secciones[:titulo], size: 18, style: :bold, align: :center
      pdf.move_down 20
      
      # Agregar resumen ejecutivo
      pdf.text "Resumen Ejecutivo", size: 14, style: :bold
      pdf.move_down 10
      pdf.text secciones[:resumen], align: :justify
      pdf.move_down 20
      
      # Agregar cada sección del informe
      secciones[:cuerpo].each do |seccion|
        pdf.text seccion[:titulo], size: 14, style: :bold
        pdf.move_down 10
        pdf.text seccion[:contenido], align: :justify
        
        # Si la sección tiene tablas o gráficos, agregarlos
        if seccion[:tabla].present?
          agregar_tabla(pdf, seccion[:tabla])
        end
        
        pdf.move_down 20
      end
      
      # Agregar conclusiones
      if secciones[:conclusiones].present?
        pdf.text "Conclusiones", size: 14, style: :bold
        pdf.move_down 10
        pdf.text secciones[:conclusiones], align: :justify
        pdf.move_down 20
      end
      
      # Agregar pie de página
      agregar_pie_pagina(pdf, parametros)
    end.render
  end
  
  private
  
  def self.configurar_documento(pdf)
    # Configurar fuentes, márgenes, etc.
    pdf.font_families.update(
      "Montserrat" => {
        normal: "#{Rails.root}/app/assets/fonts/Montserrat-Regular.ttf",
        bold: "#{Rails.root}/app/assets/fonts/Montserrat-Bold.ttf",
        italic: "#{Rails.root}/app/assets/fonts/Montserrat-Italic.ttf"
      }
    )
    pdf.font "Montserrat"
    pdf.default_leading 5
  end
  
  def self.agregar_encabezado(pdf, parametros)
    # Insertar logo de la empresa
    logo_path = "#{Rails.root}/app/assets/images/logo_conexion_consultora.png"
    pdf.image logo_path, width: 150, position: :center
    pdf.move_down 10
    
    # Agregar información del informe
    pdf.text "Informe Financiero", size: 16, style: :bold, align: :center
    pdf.text "Período: #{parametros[:periodo][:inicio].strftime('%d/%m/%Y')} - #{parametros[:periodo][:fin].strftime('%d/%m/%Y')}", align: :center
    if parametros[:sucursal].present?
      pdf.text "Sucursal: #{parametros[:sucursal]}", align: :center
    else
      pdf.text "Consolidado (Todas las sucursales)", align: :center
    end
    pdf.text "Fecha de generación: #{Date.today.strftime('%d/%m/%Y')}", align: :center
    pdf.move_down 30
  end
  
  def self.agregar_tabla(pdf, datos_tabla)
    # Implementación para agregar una tabla al PDF
    # Usando Prawn::Table
    pdf.table datos_tabla[:filas], header: true, position: :center do
      row(0).font_style = :bold
      row(0).background_color = "DDDDDD"
      self.cell_style = { size: 10 }
      self.width = 500
    end
    pdf.move_down 10
  end
  
  def self.agregar_pie_pagina(pdf, parametros)
    # Agregar numeración de páginas y confidencialidad
    pdf.number_pages "Página <page> de <total>", at: [pdf.bounds.right - 150, 0]
    pdf.text "CONFIDENCIAL - Conexión Consultora", size: 8, align: :center, style: :italic
    pdf.text "Generado automáticamente - #{Date.today.strftime('%d/%m/%Y')}", size: 8, align: :center
  end
  
  def self.parsear_contenido(contenido)
    # Método para estructurar el texto generado por el LLM en secciones
    # Esto dependerá del formato que hayamos definido en nuestras instrucciones al LLM
    
    lineas = contenido.split("\n")
    
    # Extraer título
    titulo = lineas.first.gsub(/^#\s*/, '')
    
    # Buscar el resumen ejecutivo
    inicio_resumen = lineas.find_index { |l| l =~ /resumen ejecutivo/i }
    fin_resumen = lineas[inicio_resumen+1..-1].find_index { |l| l =~ /^#/ } + inicio_resumen if inicio_resumen
    
    resumen = ""
    if inicio_resumen && fin_resumen
      resumen = lineas[inicio_resumen+1...fin_resumen].join("\n")
    end
    
    # Extraer secciones del cuerpo
    secciones = []
    seccion_actual = nil
    
    lineas.each_with_index do |linea, i|
      # Saltar hasta después del resumen
      next if fin_resumen && i <= fin_resumen
      
      # Detectar un título de sección (comienza con ## pero no con ###)
      if linea =~ /^##\s+/ && linea !~ /^###/
        # Si ya tenemos una sección, guardarla antes de empezar la nueva
        secciones << seccion_actual if seccion_actual
        
        # Iniciar nueva sección
        seccion_actual = {
          titulo: linea.gsub(/^##\s*/, ''),
          contenido: "",
          tabla: nil
        }
      elsif seccion_actual && linea =~ /^###/
        # Subsección - por ahora lo agregamos al contenido
        seccion_actual[:contenido] += "\n" + linea.gsub(/^###\s*/, '')
      elsif seccion_actual
        # Agregar línea al contenido de la sección actual
        seccion_actual[:contenido] += "\n" + linea
      end
    end
    
    # Agregar la última sección si existe
    secciones << seccion_actual if seccion_actual
    
    # Extraer conclusiones (sección final)
    conclusiones = ""
    if secciones.last && secciones.last[:titulo] =~ /conclusiones/i
      conclusiones = secciones.last[:contenido]
      secciones.pop
    end
    
    {
      titulo: titulo,
      resumen: resumen,
      cuerpo: secciones,
      conclusiones: conclusiones
    }
  end
end
```

## 7. Implementación técnica detallada

### 7.1 Controlador principal para consultas IA

```ruby
# app/controladores/consultas_ia_controlador.rb
class ConsultasIaControlador < ApplicationController
  before_action :autenticar_usuario
  
  def index
    # Mostrar la interfaz del chat
    @consultas_recientes = current_user.consultas_ia.order(created_at: :desc).limit(5)
  end
  
  def crear
    @consulta = params[:consulta]
    
    # Analizar la consulta para determinar qué datos necesitamos
    analisis = AnalizadorConsultasServicio.analizar(@consulta)
    
    # Extraer los datos financieros relevantes según el análisis
    datos_financieros = extraer_datos_relevantes(analisis)
    
    # Generar el prompt para el LLM
    prompt = GeneradorPromptsServicio.crear_para_consulta(@consulta, datos_financieros)
    
    # Obtener respuesta del LLM
    respuesta = ClienteLlmServicio.generar_respuesta(prompt)
    
    # Validar la respuesta
    validacion = ValidadorRespuestasServicio.validar(respuesta, datos_financieros)
    
    if validacion[:valido]
      # Guardar la consulta y respuesta en la base de datos
      ConsultaIa.create(
        usuario: current_user,
        consulta: @consulta,
        respuesta: respuesta,
        datos_utilizados: datos_financieros.to_json
      )
      
      render json: { respuesta: respuesta }
    else
      # Si la respuesta no es válida, regenerar con advertencias adicionales
      prompt_revisado = prompt + "\nADVERTENCIA: La respuesta anterior contenía información incorrecta. Usa EXACTAMENTE los datos proporcionados."
      respuesta_corregida = ClienteLlmServicio.generar_respuesta(prompt_revisado)
      
      # Guardar con la nota de que requirió corrección
      ConsultaIa.create(
        usuario: current_user,
        consulta: @consulta,
        respuesta: respuesta_corregida,
        datos_utilizados: datos_financieros.to_json,
        requirio_correccion: true
      )
      
      render json: { respuesta: respuesta_corregida }
    end
  end
  
  private
  
  def extraer_datos_relevantes(analisis)
    # Crear servicio de métricas con los parámetros extraídos del análisis
    servicio = MetricasFinancierasServicio.new(
      fecha_inicio: analisis[:fecha_inicio],
      fecha_fin: analisis[:fecha_fin],
      sucursal: analisis[:sucursal],
      moneda: analisis[:moneda],
      area: analisis[:area]
    )
    
    # Extraer los datos según los conceptos identificados en el análisis
    datos = {}
    
    if analisis[:conceptos].include?('rentabilidad')
      datos[:rentabilidad] = servicio.rentabilidad
    end
    
    if analisis[:conceptos].include?('saldo')
      datos[:saldo_neto] = servicio.saldo_neto
    end
    
    if analisis[:conceptos].include?('facturacion')
      datos[:facturacion_total] = servicio.facturacion_total
    end
    
    if analisis[:conceptos].include?('areas')
      datos[:facturacion_areas] = servicio.facturacion_por_area
    end
    
    if analisis[:conceptos].include?('clientes')
      datos[:top_clientes] = servicio.top_clientes
    end
    
    if analisis[:conceptos].include?('comparativa')
      if analisis[:periodo_comparacion]
        datos[:comparativa] = servicio.comparar_periodos(
          analisis[:periodo_comparacion][:inicio],
          analisis[:periodo_comparacion][:fin]
        )
      else
        datos[:comparativa] = servicio.comparar_con_periodo_anterior
      end
    end
    
    # Agregar contexto global para dar más información al LLM
    datos[:contexto] = {
      moneda_principal: analisis[:moneda] || 'UYU',
      sucursales_disponibles: ['Montevideo', 'Mercedes'],
      areas_negocio: ['Jurídica', 'Notarial', 'Contable', 'Recuperación de Activos', 'Otro']
    }
    
    datos
  end
end
```

### 7.2 Analizador de consultas

```ruby
# app/servicios/ia/analizador_consultas_servicio.rb
class AnalizadorConsultasServicio
  # Patrones para detectar conceptos
  PATRONES_RENTABILIDAD = /(rentabilidad|ganancia|beneficio|margen)/i
  PATRONES_FACTURACION = /(facturación|ingresos|ventas|facturado)/i
  PATRONES_AREAS = /(áreas?|servicios|departamentos)/i
  PATRONES_CLIENTES = /(clientes|empresas|compradores)/i
  PATRONES_MESES = {
    'enero' => 1, 'febrero' => 2, 'marzo' => 3, 'abril' => 4,
    'mayo' => 5, 'junio' => 6, 'julio' => 7, 'agosto' => 8,
    'septiembre' => 9, 'octubre' => 10, 'noviembre' => 11, 'diciembre' => 12
  }
  PATRONES_TRIMESTRES = {
    'primer trimestre' => [1, 3],
    'segundo trimestre' => [4, 6],
    'tercer trimestre' => [7, 9],
    'cuarto trimestre' => [10, 12],
    '1er trimestre' => [1, 3],
    '2do trimestre' => [4, 6],
    '3er trimestre' => [7, 9],
    '4to trimestre' => [10, 12]
  }
  
  def self.analizar(consulta)
    resultado = {
      conceptos: [],
      fecha_inicio: nil,
      fecha_fin: nil,
      sucursal: nil,
      moneda: nil,
      area: nil,
      periodo_comparacion: nil
    }
    
    # Detectar conceptos financieros
    resultado[:conceptos] << 'rentabilidad' if consulta =~ PATRONES_RENTABILIDAD
    resultado[:conceptos] << 'facturacion' if consulta =~ PATRONES_FACTURACION
    resultado[:conceptos] << 'areas' if consulta =~ PATRONES_AREAS
    resultado[:conceptos] << 'clientes' if consulta =~ PATRONES_CLIENTES
    resultado[:conceptos] << 'saldo' if consulta =~ /(saldo|balance|estado)/i
    resultado[:conceptos] << 'comparativa' if consulta =~ /(compar|versus|vs|diferencia)/i
    
    # Si no se detecta ningún concepto específico, agregar conceptos básicos
    if resultado[:conceptos].empty?
      resultado[:conceptos] = ['saldo', 'rentabilidad']
    end
    
    # Detectar período de tiempo
    periodo = detectar_periodo(consulta)
    resultado[:fecha_inicio] = periodo[:inicio]
    resultado[:fecha_fin] = periodo[:fin]
    
    # Detectar sucursal
    if consulta =~ /montevideo/i
      resultado[:sucursal] = 'Montevideo'
    elsif consulta =~ /mercedes/i
      resultado[:sucursal] = 'Mercedes'
    end
    
    # Detectar moneda
    if consulta =~ /(dólares|dolares|usd|\$)/i
      resultado[:moneda] = 'USD'
    else
      resultado[:moneda] = 'UYU'  # Moneda por defecto
    end
    
    # Detectar área de negocio
    if consulta =~ /jurídic[ao]/i
      resultado[:area] = 'Jurídica'
    elsif consulta =~ /notarial/i
      resultado[:area] = 'Notarial'
    elsif consulta =~ /contable/i
      resultado[:area] = 'Contable'
    elsif consulta =~ /recuperaci[óo]n/i
      resultado[:area] = 'Recuperación de Activos'
    end
    
    # Detectar si es una comparativa con otro período
    if resultado[:conceptos].include?('comparativa')
      resultado[:periodo_comparacion] = detectar_periodo_comparacion(consulta)
    end
    
    resultado
  end
  
  private
  
  def self.detectar_periodo(consulta)
    año_actual = Date.today.year
    mes_actual = Date.today.month
    resultado = {}
    
    # Por defecto, el mes actual
    resultado[:inicio] = Date.new(año_actual, mes_actual, 1)
    resultado[:fin] = Date.today
    
    # Detectar año específico
    años = consulta.scan(/\b(20\d{2})\b/).flatten
    año = años.first.to_i if años.any?
    
    # Detectar trimestre
    PATRONES_TRIMESTRES.each do |patron, meses|
      if consulta.include?(patron)
        año = año || (patron.include?('tercer') || patron.include?('cuarto') ? año_actual - 1 : año_actual)
        resultado[:inicio] = Date.new(año, meses[0], 1)
        resultado[:fin] = Date.new(año, meses[1], -1)  # Último día del mes final
        return resultado
      end
    end
    
    # Detectar mes específico
    PATRONES_MESES.each do |nombre_mes, numero_mes|
      if consulta.include?(nombre_mes)
        año = año || (numero_mes > mes_actual ? año_actual - 1 : año_actual)
        resultado[:inicio] = Date.new(año, numero_mes, 1)
        resultado[:fin] = Date.new(año, numero_mes, -1)  # Último día del mes
        return resultado
      end
    end
    
    # Detectar "año pasado"
    if consulta =~ /(año pasado|año anterior)/i
      resultado[:inicio] = Date.new(año_actual - 1, 1, 1)
      resultado[:fin] = Date.new(año_actual - 1, 12, 31)
    end
    
    # Detectar "este año"
    if consulta =~ /(este año|año actual)/i
      resultado[:inicio] = Date.new(año_actual, 1, 1)
      resultado[:fin] = Date.today
    end
    
    # Detectar "mes pasado"
    if consulta =~ /(mes pasado|mes anterior)/i
      mes_pasado = mes_actual - 1
      año = año_actual
      if mes_pasado < 1
        mes_pasado = 12
        año = año_actual - 1
      end
      resultado[:inicio] = Date.new(año, mes_pasado, 1)
      resultado[:fin] = Date.new(año, mes_pasado, -1)  # Último día del mes
    end
    
    resultado
  end
  
  def self.detectar_periodo_comparacion(consulta)
    # Lógica similar a detectar_periodo pero para el período de comparación
    # Este método extraería frases como "comparado con el año anterior"
    # o "versus el primer trimestre"
    
    # Implementación simplificada
    if consulta =~ /compar.*año anterior/i
      {
        inicio: Date.new(Date.today.year - 1, 1, 1),
        fin: Date.new(Date.today.year - 1, 12, 31)
      }
    elsif consulta =~ /compar.*mes anterior/i
      mes_anterior = Date.today.month - 1
      año = Date.today.year
      if mes_anterior < 1
        mes_anterior = 12
        año -= 1
      end
      {
        inicio: Date.new(año, mes_anterior, 1),
        fin: Date.new(año, mes_anterior, -1)
      }
    else
      nil
    end
  end
end
```

## 8. Consideraciones de seguridad

### 8.1 Protección de datos financieros

1. **Nunca enviar datos completos:**
   - Enviar solo los datos necesarios para responder cada consulta específica
   - No incluir información de identificación personal innecesaria

2. **Encriptación:**
   - Encriptar datos sensibles en la base de datos
   - Usar HTTPS para todas las comunicaciones

3. **Auditoría:**
   - Registrar todas las consultas y sus respuestas
   - Implementar sistema de alertas para consultas inusuales

### 8.2 Manejo de errores y excepciones

```ruby
# app/servicios/ia/manejo_errores_servicio.rb
class ManejoErroresServicio
  def self.capturar_y_manejar
    begin
      yield
    rescue APIError => e
      # Errores específicos de la API del LLM
      Rails.logger.error("Error de API: #{e.message}")
      { error: "No pudimos procesar tu consulta en este momento", codigo: "api_error" }
    rescue AutenticacionError => e
      # Errores de autenticación con el proveedor
      Rails.logger.error("Error de autenticación: #{e.message}")
      { error: "Problema de autenticación con el servicio", codigo: "auth_error" }
    rescue DatosError => e
      # Errores relacionados con datos faltantes o incorrectos
      Rails.logger.error("Error de datos: #{e.message}")
      { error: "No tenemos suficientes datos para responder", codigo: "data_error" }
    rescue StandardError => e
      # Cualquier otro error inesperado
      Rails.logger.error("Error inesperado: #{e.message}")
      Rails.logger.error(e.backtrace.join("\n"))
      { error: "Ha ocurrido un error inesperado", codigo: "unknown_error" }
    end
  end
end
```

## 9. Pruebas y evaluación

### 9.1 Pruebas automatizadas

```ruby
# spec/servicios/analizador_consultas_servicio_spec.rb
require 'rails_helper'

RSpec.describe AnalizadorConsultasServicio do
  describe '.analizar' do
    it 'identifica correctamente una consulta sobre rentabilidad' do
      consulta = '¿Cuál fue la rentabilidad de la sucursal Montevideo en marzo?'
      resultado = AnalizadorConsultasServicio.analizar(consulta)
      
      expect(resultado[:conceptos]).to include('rentabilidad')
      expect(resultado[:sucursal]).to eq('Montevideo')
      expect(resultado[:fecha_inicio].month).to eq(3)
    end
    
    it 'identifica correctamente una comparativa entre períodos' do
      consulta = '¿Cómo se compara la facturación de este año con el año pasado?'
      resultado = AnalizadorConsultasServicio.analizar(consulta)
      
      expect(resultado[:conceptos]).to include('comparativa')
      expect(resultado[:conceptos]).to include('facturacion')
      expect(resultado[:periodo_comparacion]).not_to be_nil
    end
    
    # Más casos de prueba...
  end
end

# spec/servicios/validador_respuestas_servicio_spec.rb
require 'rails_helper'

RSpec.describe ValidadorRespuestasServicio do
  describe '.validar' do
    it 'considera válida una respuesta que solo usa cifras proporcionadas' do
      datos = { rentabilidad: { rentabilidad_porcentaje: 27.5 } }
      respuesta = "La rentabilidad fue del 27.5% en el período analizado."
      
      resultado = ValidadorRespuestasServicio.validar(respuesta, datos)
      expect(resultado[:valido]).to be true
    end
    
    it 'detecta cifras inventadas en las respuestas' do
      datos = { rentabilidad: { rentabilidad_porcentaje: 27.5 } }
      respuesta = "La rentabilidad fue del 32.7% en el período analizado."
      
      resultado = ValidadorRespuestasServicio.validar(respuesta, datos)
      expect(resultado[:valido]).to be false
    end
    
    # Más casos de prueba...
  end
end
```

### 9.2 Evaluación de calidad de respuestas

Implementar un sistema de feedback donde los usuarios puedan calificar las respuestas:

```ruby
# app/controladores/feedback_ia_controlador.rb
class FeedbackIaControlador < ApplicationController
  before_action :autenticar_usuario
  
  def crear
    @consulta_ia = ConsultaIa.find(params[:consulta_ia_id])
    
    feedback = FeedbackIa.new(
      usuario: current_user,
      consulta_ia: @consulta_ia,
      puntuacion: params[:puntuacion],
      comentario: params[:comentario]
    )
    
    if feedback.save
      # Si la puntuación es baja, notificar al equipo de desarrollo
      NotificacionesServicio.alerta_feedback_negativo(feedback) if feedback.puntuacion <= 2
      
      redirect_to consultas_ia_path, notice: "Gracias por tu feedback"
    else
      redirect_to consultas_ia_path, alert: "No pudimos guardar tu feedback"
    end
  end
end
```

## 10. Estrategias de respaldo y contingencia

### 10.1 Respuestas predefinidas

Para cuando la IA no esté disponible o no pueda generar una respuesta adecuada:

```ruby
# app/servicios/ia/respuestas_respaldo_servicio.rb
class RespuestasRespaldoServicio
  def self.obtener_para(tipo_consulta, datos)
    case tipo_consulta
    when 'rentabilidad'
      generar_respuesta_rentabilidad(datos)
    when 'facturacion'
      generar_respuesta_facturacion(datos)
    when 'clientes'
      generar_respuesta_clientes(datos)
    else
      respuesta_generica(datos)
    end
  end
  
  private
  
  def self.generar_respuesta_rentabilidad(datos)
    rentabilidad = datos[:rentabilidad][:rentabilidad_porcentaje]
    periodo = datos[:rentabilidad][:periodo]
    sucursal = datos[:rentabilidad][:sucursal]
    
    "La rentabilidad #{sucursal == 'Todas' ? 'global' : "de la sucursal #{sucursal}"} " +
    "para el período #{periodo} fue de #{rentabilidad}%."
  end
  
  def self.generar_respuesta_facturacion(datos)
    # Implementación similar para facturación
  end
  
  def self.generar_respuesta_clientes(datos)
    # Implementación similar para clientes
  end
  
  def self.respuesta_generica(datos)
    "Los datos financieros para el período solicitado están disponibles. " +
    "Por favor, especifica qué información necesitas (rentabilidad, facturación, etc.)."
  end
end
```

### 10.2 Monitoreo y alertas

```ruby
# app/servicios/monitoreo/alerta_llm_servicio.rb
class AlertaLlmServicio
  def self.verificar_estado
    # Verificar estado del servicio LLM
    estado = verificar_api_llm
    
    if !estado[:disponible]
      # Enviar alerta al equipo técnico
      EnviarNotificacionServicio.alerta_tecnica(
        titulo: "Problema con API LLM",
        mensaje: "El servicio LLM no está respondiendo: #{estado[:error]}",
        nivel: "crítico"
      )
      
      # Activar modo alternativo
      ConfiguracionGlobal.set('usar_respuestas_respaldo', true)
    elsif ConfiguracionGlobal.get('usar_respuestas_respaldo')
      # Restaurar modo normal si estaba en respaldo
      ConfiguracionGlobal.set('usar_respuestas_respaldo', false)
      
      EnviarNotificacionServicio.alerta_tecnica(
        titulo: "Servicio LLM restaurado",
        mensaje: "El servicio LLM está operativo nuevamente",
        nivel: "informativo"
      )
    end
    
    estado
  end
  
  private
  
  def self.verificar_api_llm
    # Implementación para hacer una solicitud de prueba a la API
    begin
      respuesta = ClienteLlmServicio.generar_respuesta("Prueba de conexión. Responde solo 'OK'.")
      
      if respuesta.include?("OK")
        { disponible: true }
      else
        { disponible: false, error: "Respuesta inesperada: #{respuesta}" }
      end
    rescue => e
      { disponible: false, error: e.message }
    end
  end
end
```

---

Esta guía detallada proporciona un plan completo para implementar un asistente financiero inteligente en tu sistema. Adapta los componentes según tus necesidades específicas y la estructura actual de tu aplicación.

La clave del éxito está en la precisión de los datos y en la claridad de las instrucciones al LLM. Con el diseño propuesto, tu sistema podrá proporcionar análisis financieros precisos y confiables en un formato conversacional natural.
