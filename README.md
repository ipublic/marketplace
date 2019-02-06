# MartketPlace

Marketplace is a coordinated Unemployment Insurace and Paid Family Leave public Website (portal) that enables District of Columbia Employers and TPA representatives to register their organizations, determine liability/eligibility, file Wage Reports, pay taxes, and perform other necessary functions on a self-service basis.

The IdeaCrew Team produced this initial design based on:

# Requirements specified in DOES Unemployment Insurance Tax System and Paid Family Leave Tax System Requests for Proposals
# IdeaCrew's vision of a built-to-purpose, unified technology solution for Unemployment Insurance (UI) and and Paid Family Leave (PFL)

Developing and operating unified UI & PFL techology offers compelling business benefits and cost savings for DOES and its Employer, Employee, TPA and associated stakeholders.  This project's objective is to demonstrate to DOES the IdeaCrew Team's competency and cability to rapidly implement a superior core mission technology solution.  

The Marketplace application is notable in the following ways:

* Designed: data models, domain logic and interfaces that apply DOES-specified business rules
* Instrumented: uses IdeaCrew's development workbench framework for high productibity development, deployment and monitoring
* Cloud-based: uses Amazon Web Service (AWS) cloud infrastructure 

The Marketplace application component was presented to DOES UITS RFP Selection Committee February 5, 2019.  The user interface is Unemployment Insurance-centric due to that presentation's focus on fulfilling DOES UI needs.  The system design is much richer however, supporting common and independent requirements for both UI and PFL.

The Archimate data model diagram below reflects the Market application component design.

![models](https://raw.githubusercontent.com/ipublic/marketplace/7f66e5e333ddc913046d609d4feb7e94cc987785/models.png)

## Technology

The system is developed using Ruby on Rails v5 with MongoDB database.  The User interface uses Bootstrap 4 and a Material Design style presentation that meets ADA Section 508 accessibility statndards.  RSpec is used to perform regression tests.


## Local Build Setup

* Install [Yarn](https://yarnpkg.com/en/) or run `brew install yarn` if using a mac (this will also install Node if you dont have it already)

* Install node modules dependencies run `yarn install`

* Install gem dependencies run `bundle install`

* Create local DB run `rake db:create`

* In terminal start rails server run `rails s`

* In a separate terminal window start webpack dev server run `bin/webpack-dev-server`

## Front End UI Components

* The frontend is built with [Bootstrap 4 Material Design](https://fezvrasta.github.io/bootstrap-material-design/docs/4.0/getting-started/introduction/) which provides built in support for responsive design, section 508 compliance, and supports the [web components](https://en.wikipedia.org/wiki/Web_Components) architecture.

### License

The software is available as open source under the terms of the MIT License (MIT)

Developed and managed by IdeaCrew, Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above attribution notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
