# frozen_string_literal: true

require 'spec_helper'
require 'yaml'

describe 'ruby version' do
  ruby_version_file = '.ruby-version'
  repo_ruby_version = File.read(ruby_version_file).strip

  ci_config_file = '.github/workflows/test.yml'
  ci_config = YAML.load_file(ci_config_file)
  setup_ruby_step = ci_config['jobs']['test']['steps'].find { |s| s['name'] == 'Set up Ruby' }
  ci_ruby_version = setup_ruby_step&.dig('with', 'ruby-version').to_s

  context "in #{ci_config_file} and #{ruby_version_file}" do
    it 'match' do
      msg = "#{ci_ruby_version} != #{repo_ruby_version}; update #{ci_config_file} to match #{ruby_version_file}"
      expect(ci_ruby_version).to eql(repo_ruby_version), msg
    end
  end

  rubocop_config_file = '.rubocop.yml'
  rubocop_config = YAML.load_file(rubocop_config_file)
  rubocop_ruby_version = rubocop_config['AllCops']['TargetRubyVersion'].to_s
  repo_ruby_version_minor = repo_ruby_version.match('^(\d+)\.(\d+)')[0]

  context "in #{rubocop_config_file} and #{ruby_version_file} minor version" do
    it 'match' do
      msg = "#{rubocop_ruby_version} != #{repo_ruby_version_minor}; update #{rubocop_config_file} to match #{ruby_version_file}"
      expect(rubocop_ruby_version).to eql(repo_ruby_version_minor), msg
    end
  end
end
