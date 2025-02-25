                          FRONTEND



app/
├── javascript/
│   ├── componentes/              # Todos los componentes reutilizables
│   │   ├── compartidos/          # Componentes base compartidos
│   │   │   ├── ModalBase.js      # Componente modal base
│   │   │   ├── Boton.js          # Botones con estilos de CONEXIÓN
│   │   │   ├── CampoTexto.js     # Campos de entrada estandarizados
│   │   │   ├── Selector.js       # Selectores estandarizados
│   │   │   └── Tarjeta.js        # Tarjeta base para tablero
│   │   │
│   │   ├── estructura/           # Componentes estructurales
│   │   │   ├── BarraSuperior.js  # Barra superior con controles
│   │   │   ├── BarraLateral.js   # Barra lateral con navegación
│   │   │   └── PiePagina.js      # Pie de página (si es necesario)
│   │   │
│   │   ├── autenticacion/        # Componentes de autenticación
│   │   │   ├── ModalInicioSesion.js    # Modal de inicio de sesión
│   │   │   └── ModalRegistro.js  # Modal de registro
│   │   │
│   │   ├── tablero/              # Componentes específicos del tablero
│   │   │   ├── TarjetaSaldo.js   # Tarjeta para mostrar saldos
│   │   │   ├── TarjetaFacturacion.js # Tarjeta para mostrar facturación
│   │   │   ├── TarjetaArea.js    # Tarjeta para mostrar áreas que más facturan
│   │   │   ├── TarjetaClientes.js # Tarjeta para mejores clientes
│   │   │   └── TarjetaRentabilidad.js # Tarjeta para rentabilidad
│   │   │
│   │   └── operaciones/          # Componentes para operaciones financieras
│   │       ├── TarjetaIngresos.js    # Tarjeta para ingresos
│   │       ├── TarjetaGastos.js   # Tarjeta para gastos
│   │       ├── TarjetaRetiro.js # Tarjeta para retiros
│   │       ├── TarjetaDistribucion.js # Tarjeta para distribución
│   │       ├── ModalIngresos.js   # Modal para registrar ingresos
│   │       ├── ModalGastos.js  # Modal para registrar gastos
│   │       ├── ModalRetiro.js # Modal para retiros
│   │       └── ModalDistribucion.js # Modal para distribución
│   │
│   ├── servicios/                # Servicios para conectar con la API
│   │   ├── api.js                # Configuración base de la API
│   │   ├── servicioAutenticacion.js # Servicio de autenticación
│   │   ├── servicioFinanzas.js    # Servicio de operaciones financieras
│   │   └── servicioCambio.js   # Servicio para tipo de cambio
│   │
│   ├── utilidades/               # Funciones útiles reutilizables
│   │   ├── formateadores.js      # Formateo de moneda, fechas, etc.
│   │   ├── validadores.js        # Validaciones comunes
│   │   └── constantes.js         # Constantes de la aplicación
│   │
│   ├── paginas/                  # Páginas completas
│   │   ├── PaginaBienvenida.js   # Página de bienvenida con login
│   │   └── PaginaTablero.js      # Página principal del tablero
│   │
│   └── packs/                   # Puntos de entrada para webpacker
│       ├── aplicacion.js        # Pack principal
│       ├── bienvenida.js        # Pack para la página de bienvenida
│       └── tablero.js           # Pack para el tablero
│
├── assets/
│   ├── images/                  # Imágenes estáticas
│   │   ├── logo.png             # Logo completo de CONEXIÓN
│   │   └── logo_icono.png       # Icono (solo la X)
│   │
│   └── stylesheets/
│       └── tailwind.config.js   # Configuración de Tailwind con colores de CONEXIÓN
│
└── views/                       # Vistas de Rails que cargarán los packs de JavaScript
    ├── layouts/
    │   └── application.html.erb # Layout principal
    │
    └── paginas/
        ├── bienvenida.html.erb  # Vista para la página de bienvenida
        └── tablero.html.erb     # Vista para el tablero




# Flujo de Desarrollo Paso a Paso (Español)

## 1. Configuración Inicial

### Configuración de Tailwind con los colores de CONEXIÓN
Primero, configura Tailwind con los colores institucionales de CONEXIÓN para asegurar consistencia visual en toda la aplicación.

En `tailwind.config.js`:
```javascript
module.exports = {
  theme: {
    extend: {
      colors: {
        'conexion-azul': '#4a89dc',       // Azul de CONEXIÓN
        'conexion-azuloscuro': '#1e2a4a',   // Azul marino de CONEXIÓN
      }
    }
  }
}
```

### Crear plantillas HTML básicas
Necesitarás dos plantillas principales:
- `bienvenida.html.erb` - Página de bienvenida con login/registro
- `tablero.html.erb` - Tablero principal (dashboard)

## 2. Desarrollo de Componentes Base

Comienza por los componentes más básicos que serán reutilizados en toda la aplicación:

1. **Botones** (`Boton.js`)
   - Crea variantes para acciones primarias, secundarias, etc.
   - Todos con los colores de CONEXIÓN

2. **Modal Base** (`ModalBase.js`)
   - Estructura común para todos los modales
   - Incluye cabecera con logo, contenido, y botones de acción

3. **Campos** (`CampoTexto.js`, `Selector.js`)
   - Campos de formulario estandarizados
   - Incluye manejo de validación y errores

4. **Tarjeta Base** (`Tarjeta.js`)
   - Estructura para todas las tarjetas del tablero

## 3. Implementación de la Página de Bienvenida

1. Crea la página con logo central y mensaje de bienvenida
2. Implementa los modales de inicio de sesión y registro
   - **ModalInicioSesion.js**: Para usuarios existentes con campos para email y contraseña
   - **ModalRegistro.js**: Para nuevos usuarios con campos para email, contraseña y confirmación
3. Conecta con los servicios de autenticación

## 4. Estructura del Tablero

1. Desarrolla la Barra Superior (BarraSuperior.js) con:
   - Fecha/hora
   - Selector de moneda (Pesos/Dólares)
   - Filtro de fechas
   - Perfil de usuario
   - Botón de cerrar sesión

2. Desarrolla la Barra Lateral (BarraLateral.js) con:
   - Logo de CONEXIÓN
   - Navegación
   - Opciones avanzadas (chat con IA)

3. Estructura principal con áreas para:
   - Tarjetas de información
   - Tarjetas de operaciones

## 5. Componentes del Tablero

1. Tarjetas de información:
   - Saldos (Mercedes, Montevideo, Consolidado)
   - Facturación por área (Mercedes, Montevideo, Consolidado)
   - Áreas que más facturan (jurídica, notarial, contable, recuperación, etc.)
   - Top clientes
   - Rentabilidad (margen neto en porcentaje)

2. Tarjetas de operaciones:
   - Ingresos
   - Gastos
   - Retiro de utilidades
   - Distribución de utilidades

## 6. Modales de Operaciones

Para cada operación, desarrolla su modal específico extendiendo el ModalBase:

1. **Modal de Ingresos** (ModalIngresos.js)
   - Campos: fecha, tipo de cambio, concepto, monto, moneda, área, cliente, localidad
   - Funcionalidad de vista previa y confirmación

2. **Modal de Gastos** (ModalGastos.js)
   - Similar a ingresos, pero con proveedores en lugar de clientes
   - Áreas incluye gastos generales en vez de otros

3. **Modal de Retiro de Utilidades** (ModalRetiro.js)
   - Campos: fecha, tipo de cambio, montos en pesos y dólares, localidad

4. **Modal de Distribución de Utilidades** (ModalDistribucion.js)
   - Fecha, tipo de cambio
   - Lista de los cinco socios (Agustina, Viviana, Gonzalo, Pancho y Bruno)
   - Campos para montos en pesos y dólares para cada socio

## 7. Integración de Servicios

1. Conecta con la API para obtener y enviar datos
2. Implementa el servicio de tipo de cambio
3. Integra la funcionalidad de chat con IA

## 8. Pruebas y Refinamiento

1. Realiza pruebas de usabilidad
2. Optimiza el rendimiento
3. Mejora la experiencia de usuario


# Integración de Componentes (en Español)

## Principios DRY aplicados al Frontend

El principio "Don't Repeat Yourself" (No te repitas) es fundamental tanto en Rails como en el desarrollo frontend moderno. Aquí te muestro cómo implementarlo efectivamente:

### 1. Componentes Base Reutilizables

Cada componente base debe:
- Aceptar props configurables
- Ser lo suficientemente genérico para reutilizarse
- Mantener estilos consistentes

Por ejemplo, el `ModalBase.js` servirá como fundamento para todos los modales, evitando duplicar código para estructuras comunes como:
- Cabecera del modal con logo
- Botones de acción (guardar, cancelar)
- Animaciones de apertura/cierre

### 2. Composición vs. Herencia

En lugar de crear modales completamente nuevos para cada propósito, los modales específicos importarán y extenderán el ModalBase:

```javascript
// Ejemplo conceptual de ModalIngresos.js
import ModalBase from '../compartidos/ModalBase';

function ModalIngresos({ estaAbierto, alCerrar }) {
  return (
    <ModalBase 
      estaAbierto={estaAbierto} 
      alCerrar={alCerrar}
      titulo="Registro de Ingresos"
      logo="/assets/logo.png"
    >
      {/* Contenido específico del modal de ingresos */}
    </ModalBase>
  );
}
```

### 3. Composición de Páginas

Las páginas principales como PaginaTablero.js se construyen importando y componiendo múltiples componentes:

```javascript
// Ejemplo conceptual de PaginaTablero.js
import BarraSuperior from '../estructura/BarraSuperior';
import BarraLateral from '../estructura/BarraLateral';
import TarjetaSaldo from '../tablero/TarjetaSaldo';
// más importaciones...

function PaginaTablero() {
  return (
    <div className="flex h-screen">
      <BarraLateral />
      <div className="flex-1 flex flex-col">
        <BarraSuperior />
        <main className="flex-1 p-6 overflow-y-auto">
          {/* Tarjetas del tablero */}
        </main>
      </div>
    </div>
  );
}
```

## Cómo "Encastran" los Componentes

La clave para que los componentes se ajusten perfectamente es utilizar Flexbox y Grid a través de las clases de Tailwind:

### Layout Principal del Tablero

```html
<!-- Estructura principal (contenedor flexbox) -->
<div class="flex h-screen">
  <!-- Barra lateral: ancho fijo -->
  <div class="w-64 bg-conexion-azuloscuro text-white">
    <!-- Contenido de la BarraLateral -->
  </div>
  
  <!-- Contenedor principal: ocupa el resto del espacio horizontalmente -->
  <div class="flex-1 flex flex-col">
    <!-- Barra superior: altura fija -->
    <header class="h-16 bg-white shadow">
      <!-- Contenido de la BarraSuperior -->
    </header>
    
    <!-- Área de contenido: ocupa el resto del espacio vertical -->
    <main class="flex-1 p-6 overflow-y-auto bg-gray-100">
      <!-- Área de tarjetas informativas (grid de 3 columnas) -->
      <div class="grid grid-cols-3 gap-6 mb-8">
        <!-- Tarjetas de saldo, facturación, área, etc. -->
      </div>
      
      <!-- Área de tarjetas de operaciones (grid de 2x2) -->
      <div class="grid grid-cols-2 gap-6">
        <!-- Tarjetas de operaciones -->
      </div>
    </main>
  </div>
</div>
```

### Medidas y Espaciado

- **Barra lateral**: Ancho fijo (`w-64` = 256px)
- **Barra superior**: Altura fija (`h-16` = 64px)
- **Área de contenido**: Expansible para ocupar el espacio restante (`flex-1`)
- **Espaciado**: Consistente en toda la aplicación (`p-6`, `gap-6`)

## Sistema de Modales

Los modales se gestionan a nivel de página, manteniéndolos fuera del flujo normal del documento:

```javascript
// En PaginaTablero.js
function PaginaTablero() {
  const [modalActivo, setModalActivo] = useState(null);
  
  // Función para mostrar un modal específico
  const mostrarModal = (tipoModal) => {
    setModalActivo(tipoModal);
  };
  
  // Función para cerrar cualquier modal
  const cerrarModal = () => {
    setModalActivo(null);
  };
  
  return (
    <>
      {/* Layout principal */}
      <div className="flex h-screen">
        {/* ... contenido del tablero ... */}
        
        {/* Tarjetas de operaciones que abren modales */}
        <TarjetaIngresos onClick={() => mostrarModal('ingresos')} />
      </div>
      
      {/* Modales */}
      {modalActivo === 'ingresos' && (
        <ModalIngresos alCerrar={cerrarModal} />
      )}
      {modalActivo === 'gastos' && (
        <ModalGastos alCerrar={cerrarModal} />
      )}
      {/* ... más modales ... */}
    </>
  );
}
```

Esta estructura permite mantener el código organizado y seguir el principio DRY al máximo.



# Sistema de Diseño con Colores de CONEXIÓN (en Español)

## Identidad Visual

Basado en el logo de CONEXIÓN que has compartido, podemos identificar dos colores principales:

1. **Azul CONEXIÓN**: `#4a89dc` (color azul claro del logo)
2. **Azul Marino CONEXIÓN**: `#1e2a4a` (color azul oscuro/índigo del logo)

## Configuración de Tailwind

Para mantener la consistencia y aplicar DRY a los estilos, configuraremos estos colores en Tailwind:

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        'conexion': {
          'azul': '#4a89dc',       // Azul CONEXIÓN
          'azuloscuro': '#1e2a4a', // Azul Marino CONEXIÓN
          'claro': '#f8fafc',      // Fondo claro
          'gris': '#f1f5f9'        // Gris para áreas secundarias
        }
      }
    }
  }
}
```

## Aplicación Consistente

### Barra Lateral
- Fondo: `bg-conexion-azuloscuro`
- Texto: `text-white`
- Elemento activo: `bg-conexion-azul bg-opacity-20`

### Barra Superior
- Fondo: `bg-white`
- Bordes y divisores: `border-conexion-gris`
- Iconos y elementos interactivos: `text-conexion-azul`

### Botones
- Primario: `bg-conexion-azul text-white hover:bg-conexion-azul-600`
- Secundario: `bg-white text-conexion-azuloscuro border border-conexion-azuloscuro hover:bg-conexion-azuloscuro hover:text-white`
- Peligro/Cancelar: `bg-white text-red-600 border border-red-600 hover:bg-red-600 hover:text-white`

### Tarjetas
- Fondo: `bg-white`
- Borde: `border border-gray-200`
- Sombra: `shadow-md`
- Cabecera de tarjeta: `border-b border-gray-200 pb-3`

### Modales
- Overlay: `bg-black bg-opacity-50`
- Fondo del modal: `bg-white`
- Cabecera del modal: `bg-conexion-claro border-b border-gray-200`
- Logo en esquina superior derecha

## Componentes Visuales

### Ejemplo de Botón Base
```html
<button class="px-4 py-2 rounded-md bg-conexion-azul text-white hover:bg-opacity-90 focus:outline-none focus:ring-2 focus:ring-conexion-azul focus:ring-opacity-50 transition-colors">
  Botón Primario
</button>
```

### Ejemplo de Tarjeta
```html
<div class="bg-white border border-gray-200 rounded-lg shadow-md overflow-hidden">
  <div class="px-4 py-3 border-b border-gray-200 bg-conexion-claro">
    <h3 class="font-semibold text-conexion-azuloscuro">Título de la Tarjeta</h3>
  </div>
  <div class="p-4">
    <!-- Contenido de la tarjeta -->
  </div>
</div>
```

### Ejemplo de Modal
```html
<div class="fixed inset-0 z-50 flex items-center justify-center">
  <div class="absolute inset-0 bg-black bg-opacity-50"></div>
  <div class="relative bg-white rounded-lg shadow-xl w-full max-w-md mx-4">
    <div class="flex items-center justify-between px-4 py-3 border-b border-gray-200">
      <h3 class="font-semibold text-conexion-azuloscuro">Título del Modal</h3>
      <img src="/assets/logo_icono.png" alt="CONEXIÓN" class="h-8 w-auto" />
    </div>
    <div class="p-4">
      <!-- Contenido del modal -->
    </div>
    <div class="px-4 py-3 bg-conexion-claro border-t border-gray-200 flex justify-end space-x-3">
      <button class="px-4 py-2 rounded-md bg-white text-gray-600 border border-gray-300 hover:bg-gray-50">
        Cancelar
      </button>
      <button class="px-4 py-2 rounded-md bg-conexion-azul text-white hover:bg-opacity-90">
        Confirmar
      </button>
    </div>
  </div>
</div>
```

## Beneficios de este Enfoque

1. **Consistencia visual** en toda la aplicación
2. **Fácil mantenimiento**: cambiar un color en la configuración lo actualiza en todas partes
3. **Menor cantidad de código**: no es necesario definir los mismos colores repetidamente
4. **Identidad de marca**: la aplicación refleja fielmente la identidad visual de CONEXIÓN



# Estructura de Páginas y Navegación (en Español)

## Páginas Principales

El sistema constará de dos páginas principales:

### 1. Página de Bienvenida (`PaginaBienvenida.js`)

Esta página será la primera que vean los usuarios y contendrá:

- Logo de CONEXIÓN centrado
- Mensaje de bienvenida ("Bienvenidos al Sistema de Gestión Financiera Integral")
- Botones de "Registrarse" e "Iniciar Sesión" en la esquina superior derecha
- Copyright de Bruno Gandolfo en la esquina inferior izquierda
- Modales de registro e inicio de sesión (activados desde los botones)

#### Estructura del archivo:

```javascript
// PaginaBienvenida.js (simplificado conceptualmente)
import React, { useState } from 'react';
import ModalInicioSesion from '../componentes/autenticacion/ModalInicioSesion';
import ModalRegistro from '../componentes/autenticacion/ModalRegistro';

function PaginaBienvenida() {
  const [modalActivo, setModalActivo] = useState(null);
  
  return (
    <div className="min-h-screen flex flex-col bg-conexion-claro">
      {/* Botones de autenticación */}
      <div className="absolute top-4 right-4 space-x-4">
        <button onClick={() => setModalActivo('registro')} className="px-4 py-2 rounded-md bg-conexion-azul text-white">
          Registrarse
        </button>
        <button onClick={() => setModalActivo('inicioSesion')} className="px-4 py-2 rounded-md bg-white border border-conexion-azul text-conexion-azul">
          Iniciar Sesión
        </button>
      </div>
      
      {/* Logo central y mensaje */}
      <div className="flex-1 flex flex-col items-center justify-center">
        <img src="/assets/logo.png" alt="CONEXIÓN" className="h-32 mb-6" />
        <h1 className="text-2xl text-conexion-azuloscuro text-center">
          Bienvenidos al Sistema de Gestión Financiera Integral
        </h1>
      </div>
      
      {/* Copyright */}
      <div className="absolute bottom-4 left-4">
        <p className="text-sm text-gray-600">
          &copy; Bruno Gandolfo
        </p>
      </div>
      
      {/* Modales */}
      {modalActivo === 'inicioSesion' && (
        <ModalInicioSesion alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'registro' && (
        <ModalRegistro alCerrar={() => setModalActivo(null)} />
      )}
    </div>
  );
}
```

### 2. Tablero Principal (`PaginaTablero.js`)

Esta página contendrá todas las funcionalidades principales:

- Barra Superior con fecha/hora, selector de moneda, filtro de fechas, perfil y botón de cerrar sesión
- Barra Lateral con logo y navegación
- Área principal con tarjetas informativas
- Sección de operaciones con tarjetas para ingresos, gastos, etc.
- Modales para diferentes operaciones

#### Estructura del archivo:

```javascript
// PaginaTablero.js (simplificado conceptualmente)
import React, { useState, useEffect } from 'react';
import BarraSuperior from '../componentes/estructura/BarraSuperior';
import BarraLateral from '../componentes/estructura/BarraLateral';
// Más importaciones...

function PaginaTablero() {
  const [modalActivo, setModalActivo] = useState(null);
  const [monedaSeleccionada, setMonedaSeleccionada] = useState('USD');
  const [rangoFecha, setRangoFecha] = useState('mes-actual');
  
  // Más estados y efectos...
  
  return (
    <div className="flex h-screen bg-conexion-claro">
      {/* Barra Lateral */}
      <BarraLateral />
      
      {/* Área principal */}
      <div className="flex-1 flex flex-col">
        {/* Barra Superior */}
        <BarraSuperior 
          moneda={monedaSeleccionada}
          alCambiarMoneda={setMonedaSeleccionada}
          rangoFecha={rangoFecha}
          alCambiarRangoFecha={setRangoFecha}
          alCerrarSesion={() => handleCerrarSesion()}
        />
        
        {/* Contenido principal */}
        <main className="flex-1 p-6 overflow-y-auto">
          {/* Sección de tarjetas informativas */}
          <section className="mb-8">
            <h2 className="text-xl font-semibold text-conexion-azuloscuro mb-4">
              Resumen Financiero
            </h2>
            <div className="grid grid-cols-3 gap-6">
              {/* Tarjetas de saldo */}
              <TarjetaSaldo localidad="Mercedes" monto={45678} />
              <TarjetaSaldo localidad="Montevideo" monto={32456} />
              <TarjetaSaldo localidad="Consolidado" monto={78134} />
              
              {/* Tarjetas de facturación */}
              <TarjetaFacturacion localidad="Mercedes" monto={85432} />
              <TarjetaFacturacion localidad="Montevideo" monto={92765} />
              <TarjetaFacturacion localidad="Consolidado" monto={178197} />
              
              {/* Tarjetas de áreas */}
              <TarjetaArea nombre="Jurídica" monto={52365} />
              <TarjetaArea nombre="Notarial" monto={48210} />
              <TarjetaArea nombre="Contable" monto={77622} />
              
              {/* Otras tarjetas informativas */}
              <TarjetaClientes />
              <TarjetaRentabilidad porcentaje={24.5} />
            </div>
          </section>
          
          {/* Sección de operaciones */}
          <section>
            <h2 className="text-xl font-semibold text-conexion-azuloscuro mb-4">
              Operaciones
            </h2>
            <div className="grid grid-cols-2 gap-6">
              {/* Tarjetas de operaciones */}
              <TarjetaIngresos onClick={() => setModalActivo('ingresos')} />
              <TarjetaGastos onClick={() => setModalActivo('gastos')} />
              <TarjetaRetiro onClick={() => setModalActivo('retiro')} />
              <TarjetaDistribucion onClick={() => setModalActivo('distribucion')} />
            </div>
          </section>
        </main>
      </div>
      
      {/* Modales */}
      {modalActivo === 'ingresos' && (
        <ModalIngresos alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'gastos' && (
        <ModalGastos alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'retiro' && (
        <ModalRetiro alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'distribucion' && (
        <ModalDistribucion alCerrar={() => setModalActivo(null)} />
      )}
    </div>
  );
}
```

## Flujo de Navegación

### Usuario No Autenticado

# Estructura de Páginas y Navegación (en Español)

## Páginas Principales

El sistema constará de dos páginas principales:

### 1. Página de Bienvenida (`PaginaBienvenida.js`)

Esta página será la primera que vean los usuarios y contendrá:

- Logo de CONEXIÓN centrado
- Mensaje de bienvenida ("Bienvenidos al Sistema de Gestión Financiera Integral")
- Botones de "Registrarse" e "Iniciar Sesión" en la esquina superior derecha
- Copyright de Bruno Gandolfo en la esquina inferior izquierda
- Modales de registro e inicio de sesión (activados desde los botones)

#### Estructura del archivo:

```javascript
// PaginaBienvenida.js (simplificado conceptualmente)
import React, { useState } from 'react';
import ModalInicioSesion from '../componentes/autenticacion/ModalInicioSesion';
import ModalRegistro from '../componentes/autenticacion/ModalRegistro';

function PaginaBienvenida() {
  const [modalActivo, setModalActivo] = useState(null);
  
  return (
    <div className="min-h-screen flex flex-col bg-conexion-claro">
      {/* Botones de autenticación */}
      <div className="absolute top-4 right-4 space-x-4">
        <button onClick={() => setModalActivo('registro')} className="px-4 py-2 rounded-md bg-conexion-azul text-white">
          Registrarse
        </button>
        <button onClick={() => setModalActivo('inicioSesion')} className="px-4 py-2 rounded-md bg-white border border-conexion-azul text-conexion-azul">
          Iniciar Sesión
        </button>
      </div>
      
      {/* Logo central y mensaje */}
      <div className="flex-1 flex flex-col items-center justify-center">
        <img src="/assets/logo.png" alt="CONEXIÓN" className="h-32 mb-6" />
        <h1 className="text-2xl text-conexion-azuloscuro text-center">
          Bienvenidos al Sistema de Gestión Financiera Integral
        </h1>
      </div>
      
      {/* Copyright */}
      <div className="absolute bottom-4 left-4">
        <p className="text-sm text-gray-600">
          &copy; Bruno Gandolfo
        </p>
      </div>
      
      {/* Modales */}
      {modalActivo === 'inicioSesion' && (
        <ModalInicioSesion alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'registro' && (
        <ModalRegistro alCerrar={() => setModalActivo(null)} />
      )}
    </div>
  );
}
```

### 2. Tablero Principal (`PaginaTablero.js`)

Esta página contendrá todas las funcionalidades principales:

- Barra Superior con fecha/hora, selector de moneda, filtro de fechas, perfil y botón de cerrar sesión
- Barra Lateral con logo y navegación
- Área principal con tarjetas informativas
- Sección de operaciones con tarjetas para ingresos, gastos, etc.
- Modales para diferentes operaciones

#### Estructura del archivo:

```javascript
// PaginaTablero.js (simplificado conceptualmente)
import React, { useState, useEffect } from 'react';
import BarraSuperior from '../componentes/estructura/BarraSuperior';
import BarraLateral from '../componentes/estructura/BarraLateral';
// Más importaciones...

function PaginaTablero() {
  const [modalActivo, setModalActivo] = useState(null);
  const [monedaSeleccionada, setMonedaSeleccionada] = useState('USD');
  const [rangoFecha, setRangoFecha] = useState('mes-actual');
  
  // Más estados y efectos...
  
  return (
    <div className="flex h-screen bg-conexion-claro">
      {/* Barra Lateral */}
      <BarraLateral />
      
      {/* Área principal */}
      <div className="flex-1 flex flex-col">
        {/* Barra Superior */}
        <BarraSuperior 
          moneda={monedaSeleccionada}
          alCambiarMoneda={setMonedaSeleccionada}
          rangoFecha={rangoFecha}
          alCambiarRangoFecha={setRangoFecha}
          alCerrarSesion={() => handleCerrarSesion()}
        />
        
        {/* Contenido principal */}
        <main className="flex-1 p-6 overflow-y-auto">
          {/* Sección de tarjetas informativas */}
          <section className="mb-8">
            <h2 className="text-xl font-semibold text-conexion-azuloscuro mb-4">
              Resumen Financiero
            </h2>
            <div className="grid grid-cols-3 gap-6">
              {/* Tarjetas de saldo */}
              <TarjetaSaldo localidad="Mercedes" monto={45678} />
              <TarjetaSaldo localidad="Montevideo" monto={32456} />
              <TarjetaSaldo localidad="Consolidado" monto={78134} />
              
              {/* Tarjetas de facturación */}
              <TarjetaFacturacion localidad="Mercedes" monto={85432} />
              <TarjetaFacturacion localidad="Montevideo" monto={92765} />
              <TarjetaFacturacion localidad="Consolidado" monto={178197} />
              
              {/* Tarjetas de áreas */}
              <TarjetaArea nombre="Jurídica" monto={52365} />
              <TarjetaArea nombre="Notarial" monto={48210} />
              <TarjetaArea nombre="Contable" monto={77622} />
              
              {/* Otras tarjetas informativas */}
              <TarjetaClientes />
              <TarjetaRentabilidad porcentaje={24.5} />
            </div>
          </section>
          
          {/* Sección de operaciones */}
          <section>
            <h2 className="text-xl font-semibold text-conexion-azuloscuro mb-4">
              Operaciones
            </h2>
            <div className="grid grid-cols-2 gap-6">
              {/* Tarjetas de operaciones */}
              <TarjetaIngresos onClick={() => setModalActivo('ingresos')} />
              <TarjetaGastos onClick={() => setModalActivo('gastos')} />
              <TarjetaRetiro onClick={() => setModalActivo('retiro')} />
              <TarjetaDistribucion onClick={() => setModalActivo('distribucion')} />
            </div>
          </section>
        </main>
      </div>
      
      {/* Modales */}
      {modalActivo === 'ingresos' && (
        <ModalIngresos alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'gastos' && (
        <ModalGastos alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'retiro' && (
        <ModalRetiro alCerrar={() => setModalActivo(null)} />
      )}
      {modalActivo === 'distribucion' && (
        <ModalDistribucion alCerrar={() => setModalActivo(null)} />
      )}
    </div>
  );
}
```

## Flujo de Navegación

### Usuario No Autenticado

1. El usuario llega a la **Página de Bienvenida**
2. Tiene dos opciones:
   - Hacer clic en "Iniciar Sesión" → Se abre el modal de inicio de sesión
   - Hacer clic en "Registrarse" → Se abre el modal de registro
3. Tras autenticarse correctamente → Redirección al **Tablero**

### Usuario Autenticado

1. El usuario navega por el **Tablero**
2. Puede:
   - Ver información financiera en las tarjetas del tablero
   - Filtrar por moneda o fecha desde la barra superior
   - Registrar nuevas operaciones haciendo clic en las tarjetas correspondientes
   - Cerrar sesión desde el botón en la barra superior

### Flujo de Operaciones Financieras

Para registrar una operación (ejemplo: ingreso):

1. El usuario hace clic en la **Tarjeta de Ingresos**
2. Se abre el **Modal de Ingresos** con la fecha actual y el tipo de cambio del día
3. El usuario completa los campos requeridos
4. Al hacer clic en "Continuar", se muestra la vista previa de la operación
5. El usuario puede:
   - Confirmar → Guarda el registro y cierra el modal
   - Editar → Vuelve al formulario para modificar datos

## Integraciones Clave

### Tipo de Cambio

- El tipo de cambio se carga automáticamente en todos los modales
- Se obtiene desde una API externa mediante `servicioCambio.js`
- Se almacena en un contexto global para evitar llamadas repetidas

### Chat con IA

- Accesible desde la opción "Opciones avanzadas" en la Barra Lateral
- Integrado con la API de ChatGPT/Claude
- Permite exportar informes a PDF o Excel


# Guía para Utilizar Componentes de Tailwind UI

Al haber contratado Tailwind UI, tienes acceso a una amplia biblioteca de componentes prediseñados que te ayudarán a desarrollar más rápido tu Sistema de Gestión Financiera Integral. Esta guía te explicará cómo integrar estos componentes en la estructura que hemos diseñado.

## Pasos para Integrar Componentes de Tailwind UI

### 1. Identificar los Componentes Necesarios

Para el sistema que estás construyendo, estos son los componentes clave de Tailwind UI que deberías utilizar:

#### Para la Página de Bienvenida:
- **Authentication**: Para los modales de inicio de sesión y registro
- **Marketing Hero Sections**: Para la sección central con el logo y mensaje

#### Para el Tablero:
- **Application UI > Layout**: Para la estructura general (barra lateral, barra superior)
- **Application UI > Data Display**: Para las tarjetas de información
- **Application UI > Overlays > Modals**: Para todos los modales de operaciones
- **Application UI > Forms**: Para los formularios dentro de los modales
- **Application UI > Navigation**: Para la navegación en la barra lateral

### 2. Proceso de Integración

1. **Navega a la categoría correspondiente** en Tailwind UI
2. **Copia el código HTML/JSX** del componente seleccionado
3. **Pégalo en un nuevo archivo** dentro de la estructura de carpetas que te he proporcionado
4. **Personaliza el componente** con los colores de CONEXIÓN y adapta los nombres de clases si es necesario

### 3. Adaptación de Componentes

Para cada componente de Tailwind UI que utilices:

1. **Reemplaza los colores genéricos** por tus colores personalizados:
   - Cambia `bg-blue-600` por `bg-conexion-azul`
   - Cambia `text-gray-900` por `text-conexion-azuloscuro` cuando sea apropiado

2. **Adapta las props y eventos**:
   - Renombra eventos como `onClick` a `alHacerClic` para mantener el español
   - Añade las props necesarias para la funcionalidad específica

3. **Integra los íconos de Lucide** en lugar de los que vienen por defecto

## Ejemplos Prácticos

### Ejemplo 1: Modal Base adaptado de Tailwind UI

```javascript
// componentes/compartidos/ModalBase.js
import React from 'react';
import { X } from 'lucide-react';

function ModalBase({ estaAbierto, alCerrar, titulo, logo, children, acciones }) {
  if (!estaAbierto) return null;
  
  return (
    <div className="fixed inset-0 z-50 overflow-y-auto">
      <div className="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
        <div className="relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg">
          {/* Cabecera del modal */}
          <div className="flex items-center justify-between px-4 py-3 bg-conexion-claro border-b border-gray-200">
            <h3 className="text-lg font-semibold text-conexion-azuloscuro">{titulo}</h3>
            {logo && <img src={logo} alt="CONEXIÓN" className="h-8 w-auto" />}
            <button
              type="button"
              className="rounded-md bg-white text-gray-400 hover:text-gray-500"
              onClick={alCerrar}
            >
              <span className="sr-only">Cerrar</span>
              <X className="h-6 w-6" />
            </button>
          </div>
          
          {/* Contenido del modal */}
          <div className="p-4 bg-white">
            {children}
          </div>
          
          {/* Acciones del modal */}
          {acciones && (
            <div className="px-4 py-3 bg-conexion-claro border-t border-gray-200 flex justify-end space-x-3">
              {acciones}
            </div>
          )}
        </div>
      </div>
    </div>
  );
}

export default ModalBase;
```

### Ejemplo 2: Adaptación de Tarjeta de Tailwind UI

```javascript
// componentes/tablero/TarjetaSaldo.js
import React from 'react';
import { TrendingUp, TrendingDown } from 'lucide-react';

function TarjetaSaldo({ localidad, monto, cambio = 0 }) {
  const formatearMonto = (valor) => {
    return new Intl.NumberFormat('es-UY', {
      style: 'currency',
      currency: 'USD'
    }).format(valor);
  };
  
  return (
    <div className="bg-white overflow-hidden rounded-lg border border-gray-200 shadow-md">
      <div className="p-5">
        <div className="flex items-center">
          <div className="flex-shrink-0 bg-conexion-azul bg-opacity-10 rounded-md p-3">
            <svg className="h-6 w-6 text-conexion-azul" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div className="ml-5 w-0 flex-1">
            <dl>
              <dt className="text-sm font-medium text-gray-500 truncate">
                Saldo {localidad}
              </dt>
              <dd>
                <div className="text-lg font-medium text-conexion-azuloscuro">
                  {formatearMonto(monto)}
                </div>
              </dd>
            </dl>
          </div>
        </div>
        
        {cambio !== 0 && (
          <div className="mt-4">
            <div className={`flex items-center text-sm ${cambio > 0 ? 'text-green-600' : 'text-red-600'}`}>
              {cambio > 0 ? (
                <TrendingUp className="h-4 w-4 mr-1" />
              ) : (
                <TrendingDown className="h-4 w-4 mr-1" />
              )}
              <span className="font-medium">{Math.abs(cambio)}% vs mes anterior</span>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

export default TarjetaSaldo;
```

## Componentes Específicos que Necesitarás

### Para Modales de Autenticación

Utiliza los componentes de Tailwind UI en la sección "Authentication":

1. **ModalInicioSesion.js**
   - Adapta el componente "Sign In Form" de Tailwind UI
   - Añade el logo de CONEXIÓN en la esquina superior derecha
   - Asegúrate de que los campos sean correo electrónico y contraseña

2. **ModalRegistro.js**
   - Adapta el componente "Sign Up Form" de Tailwind UI
   - Asegúrate de incluir la confirmación de contraseña

### Para los Modales de Operaciones

Para todos los modales de operaciones (ingresos, gastos, retiros, distribución), comienza con:

1. El componente base "Modal" de Tailwind UI
2. Añade formularios personalizados dentro de cada modal
3. Implementa la navegación entre el formulario y la vista previa

## Beneficios de Usar Tailwind UI

- **Aceleración del desarrollo**: No necesitas crear componentes desde cero
- **Diseño profesional**: Los componentes ya tienen un diseño pulido y probado
- **Consistencia**: Mantiene una apariencia uniforme en toda la aplicación
- **Adaptabilidad**: Fácil de personalizar con los colores de CONEXIÓN

Recuerda que los componentes de Tailwind UI son solo el punto de partida. Debes adaptarlos a tus necesidades específicas y asegurarte de que se integren correctamente con la estructura y lógica de tu aplicación.

# Flujo de Trabajo para Modales

Este documento describe en detalle cómo implementar los diferentes modales que necesita tu Sistema de Gestión Financiera Integral, enfocándose en la estructura de archivos y el flujo de interacción.

## Modales de Autenticación

### 1. Modal de Inicio de Sesión (`ModalInicioSesion.js`)

**Ubicación**: `app/javascript/componentes/autenticacion/ModalInicioSesion.js`

**Elementos principales**:
- Logo de CONEXIÓN en esquina superior derecha
- Campo para correo electrónico
- Campo para contraseña
- Botón de inicio de sesión
- Enlace para recuperar contraseña (opcional)

**Flujo**:
1. Usuario hace clic en "Iniciar Sesión" en la página de bienvenida
2. Se abre el modal
3. Usuario completa los campos y envía el formulario
4. Al validar correctamente, redirige al tablero

### 2. Modal de Registro (`ModalRegistro.js`)

**Ubicación**: `app/javascript/componentes/autenticacion/ModalRegistro.js`

**Elementos principales**:
- Logo de CONEXIÓN en esquina superior derecha
- Campo para correo electrónico
- Campo para contraseña
- Campo para confirmar contraseña
- Botón de registro

**Flujo**:
1. Usuario hace clic en "Registrarse" en la página de bienvenida
2. Se abre el modal
3. Usuario completa los campos y envía el formulario
4. Al validar correctamente, redirige al tablero

## Modales de Operaciones

Todos los modales de operaciones siguen una estructura similar y un flujo de dos pasos: formulario → vista previa → confirmación.

### 1. Modal de Ingresos (`ModalIngresos.js`)

**Ubicación**: `app/javascript/componentes/operaciones/ModalIngresos.js`

**Elementos del formulario**:
- Logo de CONEXIÓN en esquina superior derecha
- Fecha (por defecto la del día, editable)
- Tipo de cambio (obtenido de la API externa)
- Concepto del ingreso
- Monto
- Selector de moneda (Pesos/Dólares)
- Selector de área (jurídica, notarial, contable, recuperación de activos, otro)
- Cliente
- Selector de localidad (Mercedes/Montevideo)
- Botón "Continuar" para ir a vista previa

**Flujo**:
1. Usuario hace clic en la tarjeta de Ingresos
2. Se abre el modal con el formulario
3. Al hacer clic en "Continuar", se muestra la vista previa
4. En la vista previa, puede "Guardar registro" o "Editar"

### 2. Modal de Gastos (`ModalGastos.js`)

**Ubicación**: `app/javascript/componentes/operaciones/ModalGastos.js`

**Elementos del formulario**:
- Similar al modal de Ingresos, pero:
  - En lugar de "Cliente" tiene "Proveedor"
  - En áreas, en lugar de "Otro" tiene "Gastos generales"

**Flujo**: Igual que el modal de Ingresos

### 3. Modal de Retiro de Utilidades (`ModalRetiro.js`)

**Ubicación**: `app/javascript/componentes/operaciones/ModalRetiro.js`

**Elementos del formulario**:
- Logo de CONEXIÓN en esquina superior derecha
- Fecha (por defecto la del día, editable)
- Tipo de cambio (obtenido de la API externa)
- Monto en dólares
- Monto en pesos
- Selector de localidad (Mercedes/Montevideo)
- Botón "Continuar" para ir a vista previa

**Flujo**: Similar a los anteriores (formulario → vista previa → confirmación)

### 4. Modal de Distribución de Utilidades (`ModalDistribucion.js`)

**Ubicación**: `app/javascript/componentes/operaciones/ModalDistribucion.js`

**Elementos del formulario**:
- Logo de CONEXIÓN en esquina superior derecha
- Fecha (por defecto la del día, editable)
- Tipo de cambio (obtenido de la API externa)
- Lista de los cinco socios:
  - Agustina (campos para monto en dólares y pesos)
  - Viviana (campos para monto en dólares y pesos)
  - Gonzalo (campos para monto en dólares y pesos)
  - Pancho (campos para monto en dólares y pesos)
  - Bruno (campos para monto en dólares y pesos)
- Botón "Continuar" para ir a vista previa

**Flujo**: Similar a los anteriores (formulario → vista previa → confirmación)

## Estructura Interna de los Modales

Cada modal de operación debe estar estructurado para manejar dos vistas (formulario y vista previa) y comunicarse con los servicios correspondientes.

### Ejemplo para Modal de Ingresos:

```javascript
// ModalIngresos.js (estructura conceptual)
import React, { useState, useEffect } from 'react';
import ModalBase from '../compartidos/ModalBase';
import servicioCambio from '../../servicios/servicioCambio';
import servicioFinanzas from '../../servicios/servicioFinanzas';

function ModalIngresos({ estaAbierto, alCerrar }) {
  // Estados para los campos del formulario
  const [fecha, setFecha] = useState(new Date());
  const [tipoCambio, setTipoCambio] = useState(0);
  const [concepto, setConcepto] = useState('');
  const [monto, setMonto] = useState('');
  const [moneda, setMoneda] = useState('USD');
  const [area, setArea] = useState('');
  const [cliente, setCliente] = useState('');
  const [localidad, setLocalidad] = useState('Mercedes');
  
  // Estado para controlar la vista (formulario o vista previa)
  const [vistaPrevia, setVistaPrevia] = useState(false);
  
  // Cargar tipo de cambio al abrir el modal
  useEffect(() => {
    if (estaAbierto) {
      servicioCambio.obtenerTipoCambio().then(tc => setTipoCambio(tc));
    }
  }, [estaAbierto]);
  
  // Función para continuar a vista previa
  const continuar = () => {
    // Validar campos antes de continuar
    if (!concepto || !monto || !area || !cliente) {
      alert('Por favor complete todos los campos obligatorios');
      return;
    }
    
    setVistaPrevia(true);
  };
  
  // Función para volver al formulario
  const editar = () => {
    setVistaPrevia(false);
  };
  
  // Función para guardar el registro
  const guardar = () => {
    const nuevoIngreso = {
      fecha,
      tipoCambio,
      concepto,
      monto: parseFloat(monto),
      moneda,
      area,
      cliente,
      localidad
    };
    
    servicioFinanzas.registrarIngreso(nuevoIngreso)
      .then(() => {
        alert('Ingreso registrado con éxito');
        alCerrar();
      })
      .catch(error => {
        alert('Error al registrar el ingreso: ' + error.message);
      });
  };
  
  // Renderizar el contenido según la vista actual
  const contenido = vistaPrevia ? (
    // Contenido de vista previa
    <div>
      <h3 className="font-medium text-gray-900 mb-4">Vista previa del registro</h3>
      <div className="space-y-3">
        <p><span className="font-medium">Fecha:</span> {fecha.toLocaleDateString()}</p>
        <p><span className="font-medium">Tipo de cambio:</span> {tipoCambio}</p>
        <p><span className="font-medium">Concepto:</span> {concepto}</p>
        <p><span className="font-medium">Monto:</span> {monto} {moneda}</p>
        <p><span className="font-medium">Área:</span> {area}</p>
        <p><span className="font-medium">Cliente:</span> {cliente}</p>
        <p><span className="font-medium">Localidad:</span> {localidad}</p>
      </div>
    </div>
  ) : (
    // Contenido del formulario
    <div className="space-y-4">
      {/* Campos del formulario */}
      <div>
        <label className="block text-sm font-medium text-gray-700">Fecha</label>
        <input
          type="date"
          value={fecha.toISOString().split('T')[0]}
          onChange={e => setFecha(new Date(e.target.value))}
          className="mt-1 block w-full rounded-md border-gray-300 shadow-sm focus:border-conexion-azul focus:ring-conexion-azul"
        />
      </div>
      
      <div>
        <label className="block text-sm font-medium text-gray-700">Tipo de cambio</label>
        <input
          type="number"
          value={tipoCambio}
          readOnly
          className="mt-1 block w-full rounded-md border-gray-300 bg-gray-100 shadow-sm"
        />
      </div>
      
      {/* Más campos del formulario... */}
    </div>
  );
  
  // Botones para cada vista
  const acciones = vistaPrevia ? (
    <>
      <button
        type="button"
        onClick={editar}
        className="px-4 py-2 rounded-md bg-white text-gray-600 border border-gray-300 hover:bg-gray-50"
      >
        Editar
      </button>
      <button
        type="button"
        onClick={guardar}
        className="px-4 py-2 rounded-md bg-conexion-azul text-white hover:bg-opacity-90"
      >
        Guardar registro
      </button>
    </>
  ) : (
    <button
      type="button"
      onClick={continuar}
      className="px-4 py-2 rounded-md bg-conexion-azul text-white hover:bg-opacity-90"
    >
      Continuar
    </button>
  );
  
  return (
    <ModalBase
      estaAbierto={estaAbierto}
      alCerrar={alCerrar}
      titulo={vistaPrevia ? "Confirmar Ingreso" : "Registro de Ingreso"}
      logo="/assets/logo_icono.png"
      acciones={acciones}
    >
      {contenido}
    </ModalBase>
  );
}

export default ModalIngresos;
```

Los demás modales de operaciones seguirán una estructura similar, adaptada a sus campos específicos.



