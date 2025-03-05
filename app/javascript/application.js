// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "alpine"
import "alpine_components"

// Inicializar Alpine después de cargar el DOM
document.addEventListener('DOMContentLoaded', () => {
  console.log('Alpine initialized in application.js');
});
