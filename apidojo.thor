# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:default)

Dotenv.load

loader = Zeitwerk::Loader.new
loader.push_dir('lib')
loader.setup

class Apidojo < Thor
  desc 'start', 'starting the Apidojo CLI app'
  def start
    puts Paint['Launching Apidojo dev CLI', :green, :bright]
    repl = ApidojoConsole.new
    repl.launch
  end

  desc 'sync', 'syncing the Apidojo CLI'
  def sync
    puts Paint['Syncing Apidojo dev CLI', :green, :bright]

    spinner = TTY::Spinner.new('[:spinner] Loading platform data')
    spinner.auto_spin

    engine = ApidojoEngine.new

    engine.sync!
    engine.refresh_etc_hosts!
    system('dscacheutil -flushcache')

    spinner.stop
    puts Paint['Done', :green, :bright]
  end
end
