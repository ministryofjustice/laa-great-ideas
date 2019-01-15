# Great Ideas
[![CircleCI](https://circleci.com/gh/ministryofjustice/laa-great-ideas.svg?style=svg)](https://circleci.com/gh/ministryofjustice/laa-great-ideas)

Great Ideas allows LAA staff to submit their ideas for consideration to the Continuous Improvement team.

## Setting up a development environment

### Dependencies
Install [PostgreSQL](https://www.postgresql.org) 10.5

### Setup

```
bundle install

npm install

rake db:setup
rake db:migrate
```

### Setup dummy data
`rake db:seed`

### Reset database and seed data
`rake db:reset`

### Run the application server

`rails server`

## Testing

To execute Rspec tests and coverage

`rake`

## Running in Docker

Install (Docker Compose)[https://docs.docker.com/compose/]

```
docker-compose build

docker-compose up
```
In new terminal window:

`docker-compose run app bundle exec rake db:reset`

## Contributing

Bug reports and pull requests are welcome.

1. Fork the project (https://github.com/ministryofjustice/laa-great-ideas/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit until you are happy with your contribution (`git commit -am 'Add some feature'`)
4. Push the branch (`git push origin my-new-feature`)
5. Make sure your changes are covered by tests, so that we don't break it unintentionally in the future.
6. Create a new pull request.

## License

Released under the [MIT License](http://www.opensource.org/licenses/MIT). Copyright (c) 2015-2016 Ministry of Justice.