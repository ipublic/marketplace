import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import 'bootstrap-material-design';
import './alerts';
import '../src/application.scss';
import '../images/does.png';

Rails.start()
Turbolinks.start()

document.addEventListener("turbolinks:load", function() {
  $('body').bootstrapMaterialDesign();
})
