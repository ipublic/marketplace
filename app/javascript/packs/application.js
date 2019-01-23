import 'bootstrap-material-design';
import './alerts';
import '../src/application.scss';
import '../images/does.png';


document.addEventListener("turbolinks:load", function() {
  $('body').bootstrapMaterialDesign();
})
