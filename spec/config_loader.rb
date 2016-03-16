require 'yaml'

module ConfigLoader
  CONFIG_PROJECT_PATH = 'spec/config.yml'.freeze

  def self.init
    config_path = Dir.pwd.to_s + '/' + CONFIG_PROJECT_PATH
    raise "#{CONFIG_PROJECT_PATH} not found." unless File.exist?(config_path)
    YAML.load_file(config_path)
  end
end
