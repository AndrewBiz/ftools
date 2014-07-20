# A sample Guardfile
# More info at https://github.com/guard/guard#readme

# notification :terminal_notifier, app_name: "ftools"
notification :tmux, display_message: true

guard 'cucumber' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$}) { 'features' }
  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/{m[1]}.feature")][0] || 'features' }
end

guard :rspec, cli: '--color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^bin/(.+)$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end
