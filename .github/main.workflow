workflow "CI" {
  on = "push"
  resolves = [
    "CI - Rake"
  ]
}

action "CI - Rake" {
  uses = "docker://ruby"
  runs = "bash"
  args = ["-c", "gem install bundler && bundle && bundle exec rake test"]
}
