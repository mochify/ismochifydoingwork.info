# ismochifydoingwork.info

The source powering the domain ismochifydoingwork.info

## Goals

This project aims to be an easy-to-use and fully automated productivity tracker for software development teams built on
totally-not-bullshit metrics such as github commit counts over time.

## Maturity

The team is still working on implementing additional metrics and information sources, but the core application should be
solid.  We encourage everyone to customize the app and incorporate it into the management workflows for their product
teams.

## Building and running

The app is built on a rails stack with a bunch of fancy js, but all the dependencies should be there via the usual
`bundle install`, and is ready to be deployed on heroku.  Currently it depends on a few environment variables to run:

* `MOCHIFYDOINGWORK_OAUTH` - OAUTH token for the github user that has access to organization repo information
* `MOCHIFYDOINGWORK_ORGNAME` - github organization name to poll for information

## Continuous Integration Status

[![Continuous Integration status](https://secure.travis-ci.org/mochify/ismochifydoingwork.info.png)](http://travis-ci.org/mochify/ismochifydoingwork.info)

## Licensing

Copyright (C) 2014 William Lee, Alex Kuang, and The Mochify Team.

Licensed under [GPL v3 Affero](http://www.gnu.org/licenses/agpl-3.0.html).
