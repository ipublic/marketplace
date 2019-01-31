import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import 'bootstrap-material-design';
import 'datatables/media/css/jquery.dataTables.css';
import './jquery.steps.min';
import './jquery.validate.min';
import './steps';
import '../src/application.scss';
import '../images/does.png';
import '@fortawesome/fontawesome-free';
import '@fortawesome/fontawesome-free/scss/solid.scss';
import '@fortawesome/fontawesome-free/scss/fontawesome.scss';
import swal from 'sweetalert';

Rails.start()
Turbolinks.start()

document.addEventListener("turbolinks:load", function() {
  $('body').bootstrapMaterialDesign();
})

const application = Application.start()
const context = require.context("controllers", true, /.js$/)
application.load(definitionsFromContext(context))
