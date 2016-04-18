module FixtureLoader
  def self.init(json_name)
    fixture_path = Dir.pwd.to_s + '/spec/fixtures/' + json_name
    raise "#{fixture_path} not found." unless File.exist?(fixture_path)
    file = File.read(fixture_path)
    Oj.load(file)
  end
end
