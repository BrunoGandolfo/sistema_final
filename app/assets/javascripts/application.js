// This file is automatically compiled by the asset pipeline
// Ensure all modal functionality works across the application

document.addEventListener('turbo:load', function() {
  console.log('Turbo:load event fired');
  setupModals();
});

// También configurar en DOMContentLoaded para asegurar que funcione en cualquier caso
document.addEventListener('DOMContentLoaded', function() {
  console.log('DOMContentLoaded event fired');
  setupModals();
});

function setupModals() {
  console.log('Configurando modales...');
  
  // Botones que abren modales
  document.querySelectorAll('.button[data-toggle="modal"]').forEach(button => {
    console.log('Botón modal encontrado:', button.id);
    button.addEventListener('click', openModal);
  });
  
  // Botones de cierre de modales
  document.querySelectorAll('.close').forEach(closeBtn => {
    closeBtn.addEventListener('click', closeModal);
  });
  
  // Cierre al hacer clic fuera del modal
  window.addEventListener('click', function(event) {
    if (event.target.classList.contains('modal')) {
      event.target.style.display = 'none';
    }
  });
}

function openModal(event) {
  event.preventDefault();
  const targetId = this.getAttribute('data-target');
  const modal = document.querySelector(targetId);
  if (modal) {
    console.log('Abriendo modal:', targetId);
    modal.style.display = 'block';
  } else {
    console.error('Modal no encontrado:', targetId);
  }
}

function closeModal() {
  this.closest('.modal').style.display = 'none';
}

// Delegación de eventos para botones dinámicos
document.addEventListener('click', function(event) {
  if (event.target.matches('.button[data-toggle="modal"]') || 
      event.target.closest('.button[data-toggle="modal"]')) {
    const button = event.target.matches('.button[data-toggle="modal"]') ? 
                 event.target : 
                 event.target.closest('.button[data-toggle="modal"]');
    const targetId = button.getAttribute('data-target');
    const modal = document.querySelector(targetId);
    if (modal) {
      modal.style.display = 'block';
    }
  }
}); 