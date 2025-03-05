# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "alpine", to: "https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"
pin "alpine_components", to: "alpine_components.js"
