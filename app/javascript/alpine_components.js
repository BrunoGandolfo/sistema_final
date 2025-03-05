// Alpine.js components for modals
document.addEventListener('DOMContentLoaded', () => {
  console.log('Inicializando componentes Alpine')
  
  // Registrar stores globales para los modales
  Alpine.store('modalIngreso', {
    open: false,
    openModal() {
      console.log('Abriendo modal de ingreso desde store')
      this.open = true
    },
    closeModal() {
      console.log('Cerrando modal de ingreso desde store')
      this.open = false
    }
  })
  
  Alpine.store('modalGasto', {
    open: false,
    openModal() {
      console.log('Abriendo modal de gasto desde store')
      this.open = true
    },
    closeModal() {
      console.log('Cerrando modal de gasto desde store')
      this.open = false
    }
  })
  
  // Detectar y configurar los botones de modal después de que la página carga
  setTimeout(() => {
    console.log('Configurando botones modales tradicionales')
    document.querySelectorAll('.modal-button').forEach(button => {
      console.log('Botón modal tradicional encontrado:', button.id)
    })
  }, 1000)
});

// Componente Alpine para el modal de ingresos
window.modalIngreso = function() {
  console.log('Inicializando componente modalIngreso')
  return {
    isSubmitting: false,
    errors: {},
    formData: {
      fecha: new Date().toISOString().split('T')[0],
      concepto: '',
      monto: '',
      moneda: 'UYU',
      tipo_cambio_id: '',
      area: '',
      cliente_id: '',
      sucursal: '',
      usuario_id: document.getElementById('ingreso-form')?.querySelector('[name="ingreso[usuario_id]"]')?.value || ''
    },
    // Alpine.js lifecycle hook - cuando el componente se inicializa
    init() {
      console.log('Componente modalIngreso inicializado')
    },
    // Método para abrir el modal
    openModal() {
      console.log('Abriendo modal de ingreso desde el componente')
      this.$store.modalIngreso.open = true
    },
    // Método para cerrar el modal
    closeModal() {
      console.log('Cerrando modal de ingreso')
      this.$store.modalIngreso.open = false
      this.resetForm()
    },
    resetForm() {
      this.formData = {
        fecha: new Date().toISOString().split('T')[0],
        concepto: '',
        monto: '',
        moneda: 'UYU',
        tipo_cambio_id: '',
        area: '',
        cliente_id: '',
        sucursal: '',
        usuario_id: document.getElementById('ingreso-form')?.querySelector('[name="ingreso[usuario_id]"]')?.value || ''
      };
      this.errors = {};
    },
    validate() {
      this.errors = {};
      let isValid = true;
      
      if (!this.formData.fecha) {
        this.errors.fecha = 'La fecha es obligatoria';
        isValid = false;
      }
      
      if (!this.formData.cliente_id) {
        this.errors.cliente_id = 'El cliente es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.concepto) {
        this.errors.concepto = 'El concepto es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.monto) {
        this.errors.monto = 'El monto es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.moneda) {
        this.errors.moneda = 'La moneda es obligatoria';
        isValid = false;
      }
      
      if (!this.formData.tipo_cambio_id) {
        this.errors.tipo_cambio_id = 'El tipo de cambio es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.area) {
        this.errors.area = 'El área es obligatoria';
        isValid = false;
      }
      
      if (!this.formData.sucursal) {
        this.errors.sucursal = 'La sucursal es obligatoria';
        isValid = false;
      }
      
      return isValid;
    },
    submitForm(event) {
      if (!this.validate()) {
        return;
      }
      
      this.isSubmitting = true;
      
      // Preparar los datos del formulario
      const formData = new FormData(event.target);
      
      // Enviar formulario
      fetch(event.target.action, {
        method: event.target.method,
        body: formData,
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        this.isSubmitting = false;
        
        if (data.status === 'success') {
          alert(data.message || 'Ingreso registrado correctamente');
          this.closeModal();
          window.location.reload();
        } else {
          alert(data.message || 'Error al registrar el ingreso');
        }
      })
      .catch(error => {
        this.isSubmitting = false;
        console.error('Error:', error);
        alert('Ocurrió un error al procesar la solicitud');
      });
    }
  };
};

// Componente Alpine para el modal de gastos
window.modalGasto = function() {
  console.log('Inicializando componente modalGasto')
  return {
    isSubmitting: false,
    errors: {},
    formData: {
      fecha: new Date().toISOString().split('T')[0],
      concepto: '',
      monto: '',
      moneda: 'UYU',
      tipo_cambio_id: '',
      area: '',
      proveedor_id: '',
      sucursal: '',
      usuario_id: document.getElementById('gasto-form')?.querySelector('[name="gasto[usuario_id]"]')?.value || ''
    },
    // Alpine.js lifecycle hook - cuando el componente se inicializa
    init() {
      console.log('Componente modalGasto inicializado')
    },
    // Método para abrir el modal
    openModal() {
      console.log('Abriendo modal de gasto desde el componente')
      this.$store.modalGasto.open = true
    },
    // Método para cerrar el modal
    closeModal() {
      console.log('Cerrando modal de gasto')
      this.$store.modalGasto.open = false
      this.resetForm()
    },
    resetForm() {
      this.formData = {
        fecha: new Date().toISOString().split('T')[0],
        concepto: '',
        monto: '',
        moneda: 'UYU',
        tipo_cambio_id: '',
        area: '',
        proveedor_id: '',
        sucursal: '',
        usuario_id: document.getElementById('gasto-form')?.querySelector('[name="gasto[usuario_id]"]')?.value || ''
      };
      this.errors = {};
    },
    validate() {
      this.errors = {};
      let isValid = true;
      
      if (!this.formData.fecha) {
        this.errors.fecha = 'La fecha es obligatoria';
        isValid = false;
      }
      
      if (!this.formData.concepto) {
        this.errors.concepto = 'El concepto es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.monto) {
        this.errors.monto = 'El monto es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.moneda) {
        this.errors.moneda = 'La moneda es obligatoria';
        isValid = false;
      }
      
      if (!this.formData.tipo_cambio_id) {
        this.errors.tipo_cambio_id = 'El tipo de cambio es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.area) {
        this.errors.area = 'El área es obligatoria';
        isValid = false;
      }
      
      if (!this.formData.proveedor_id) {
        this.errors.proveedor_id = 'El proveedor es obligatorio';
        isValid = false;
      }
      
      if (!this.formData.sucursal) {
        this.errors.sucursal = 'La sucursal es obligatoria';
        isValid = false;
      }
      
      return isValid;
    },
    submitForm(event) {
      if (!this.validate()) {
        return;
      }
      
      this.isSubmitting = true;
      
      // Preparar los datos del formulario
      const formData = new FormData(event.target);
      
      // Enviar formulario
      fetch(event.target.action, {
        method: event.target.method,
        body: formData,
        headers: {
          'Accept': 'application/json'
        }
      })
      .then(response => response.json())
      .then(data => {
        this.isSubmitting = false;
        
        if (data.status === 'success') {
          alert(data.message || 'Gasto registrado correctamente');
          this.closeModal();
          window.location.reload();
        } else {
          alert(data.message || 'Error al registrar el gasto');
        }
      })
      .catch(error => {
        this.isSubmitting = false;
        console.error('Error:', error);
        alert('Ocurrió un error al procesar la solicitud');
      });
    }
  };
}; 