# frozen_string_literal: true

require 'English'

class ApidojoConsole
  def initialize
    @prompted = false
    @selecting_sandbox = false

    @last_command = ''
    @engine = ApidojoEngine.new
    @pastel = Pastel.new
    @cmd = TTY::Command.new

    @providers = []
    @sandboxes = []
  end

  def launch
    loop do
      # catch and swallow bubbling SIGINT (CTRL+C) when running the dev server
      Signal.trap('INT') {}

      break unless all_settings_clear?

      unless @prompted
        puts "\Type h|H|help|HELP to see available commands"
        @prompted = true
      end

      print Paint['apidojo |> ', :blue, :bright]

      user_command = $stdin.gets&.chomp

      if user_command.nil? || user_command =~ /^q$/i # Ctrl+D
        puts 'Exiting Apidojo, see you next session!'
        break
      end

      answer_to(user_command)
    end
  end

  private

  def all_settings_clear?
    if File.exist?('data/platform/providers.yml')
      File.open('data/platform/providers.yml', 'r') do |providers_data|
        @providers = begin
          YAML.load(providers_data)
        rescue StandardError
          []
        end

        if @providers.empty?
          puts Paint['Ensure you have API providers set in the platform then run `rvmsudo thor apidojo:sync` (See README for instructions)',
                     :red, :bright]

          return false
        end
      end
    else
      puts Paint['Ensure you have API providers set in the platform then run `rvmsudo thor apidojo:sync` (See README for instructions)',
                 :red, :bright]

      return false
    end

    if File.exist?('data/platform/sandboxes.yml')
      File.open('data/platform/sandboxes.yml', 'r') do |sandboxes_data|
        @sandboxes = begin
          YAML.load(sandboxes_data)
        rescue StandardError
          []
        end

        if @sandboxes.empty?
          puts Paint['Ensure you have sandboxes defined in the platform then run `rvmsudo thor apidojo:sync` (See README for instructions)',
                     :red, :bright]

          return false
        end
      end
    else
      puts Paint['Ensure you have sandboxes defined in the platform then run `rvmsudo thor apidojo:sync` (See README for instructions)',
                 :red, :bright]

      return false
    end

    if File.exist?('.env') && ENV['APIDOJO_USER_TOKEN']
      ping_status = begin
        ApidojoEngine.new.ping_platform.status
      rescue StandardError
        500
      end

      case ping_status
      when 204
        puts Paint['Please properly set your user token in the .env file (See README for instructions)', :red, :bright]

        return false
      when 401
        puts Paint['Invalid user token, please check in the platform', :red, :bright]

        return false
      when 200
        true
      else
        puts Paint['Preflight checks error, please check your connection or contact support in the platform', :red,
                   :bright]

        return false
      end
    else
      puts Paint['Please properly set your user token in the .env file (See README for instructions)', :red, :bright]

      return false
    end

    true
  end

  def answer_to(user_command)
    @last_command = user_command

    case user_command.strip
    when /^h|help$/i
      @selecting_sandbox = false

      puts "1. `h` displays this help\n2. `sandbox` or `sandboxes` or `sbx` -> lists available sandboxes and allows you to select one\n3. `sandbox p:PORT_VALUE` -> runs local sandbox on a given port (IMPORTANT: the port must match a sandbox port configuration on the platform in order to establish the connection)\n4. `q` or CTRL+D -> exits this apidojo prompt"
    when /^sandbox|sandboxes|sbx$/i
      @selecting_sandbox = true

      puts Paint['  Select the sandbox number:', :white, :bright]

      @sandboxes.each_with_index do |sandbox, index|
        puts Paint["    #{index + 1}/ Project: #{sandbox['project']} -> Sandbox: #{sandbox['sandbox']} -> PORT #{sandbox['port']}", :white, :bright]
      end
    when /(\d+)/
      if @selecting_sandbox && @sandboxes[$LAST_MATCH_INFO[1].to_i - 1]
        @selecting_sandbox = false

        sandbox = @sandboxes[$LAST_MATCH_INFO[1].to_i - 1]

        puts Paint["Starting '#{sandbox['sandbox']}' API sandbox at port #{sandbox['port']}", :green, :bright]

        run_server(port: sandbox['port'])
      else
        puts 'Unknowh command (type h|H|help|HELP to see available commands)'
      end
    when /^sandbox\s+p:(\d+)$/
      @selecting_sandbox = false

      puts Paint["Starting API sandbox at port #{$LAST_MATCH_INFO[1]}", :green, :bright]

      run_server(port: $LAST_MATCH_INFO[1])
    else
      @selecting_sandbox = false

      puts 'Unknowh command (type h|H|help|HELP to see available commands)'
    end
  end

  def run_server(port: -1)
    if port == -1
      puts Paint['Please specify the port, eg `sandbox p:4000`', :red, :bright]

      return
    end

    @cmd.run("ruby apidojo.rb -p #{port}")
  end
end
