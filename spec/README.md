# Specs

Every file in this directory that ends in `_spec.rb` will automatically be run when you execute `rspec` in the command-line (from this project's root directory).

Organize the folders/files here exactly how they're organized in your app. E.g. if you have **models/** and **services/** that you want to test, create **models/** and **services/** folders into **spec/**, and place the tests for those types of files in their respective folder.

Add `require`/`require_relative` to **spec_helper.rb** so that RSpec is aware of the files you're trying to test.