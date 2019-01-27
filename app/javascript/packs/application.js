import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"
import 'bootstrap-material-design';
import './alerts';
import '../src/application.scss';
import '../images/does.png';

Rails.start()
Turbolinks.start()

document.addEventListener("turbolinks:load", function() {
  $('body').bootstrapMaterialDesign();
})

const application = Application.start()
const context = require.context("controllers", true, /.js$/)
application.load(definitionsFromContext(context))
