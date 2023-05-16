# frozen_string_literal: true

class ApidojoEngine
  def initialize
    @client = Apidojo::Client.new
    @client.configure!
  end

  def ping_platform
    @client.ping_platform.response
  end

  %i[get post put patch delete].each do |verb|
    define_method("relay_#{verb}") do |rack_request|
      relay(verb, rack_request)
    end
  end

  def relay(verb, rack_request)
    @client
      .query(
        verb:,
        rack_request:
      )
      .response
  end

  def sync!
    res = @client.sync.response

    return unless res.status == 200

    File.open('data/platform/sandboxes.yml', 'w+') do |out|
      YAML.dump(res.body['data']['sandboxes'], out)
    end

    File.open('data/platform/providers.yml', 'w+') do |out|
      YAML.dump(res.body['data']['providers'], out)
    end
  end

  def refresh_etc_hosts!
    hosts = Hosts::File.read('/etc/hosts')

    File.open('data/platform/providers.yml', 'r') do |providers_data|
      providers = YAML.load(providers_data)

      providers.each do |provider|
        next if hosts.elements.select do |host_entry|
                  host_entry.is_a?(Hosts::Entry)
                end.detect { |host_entry| host_entry.name == provider['dev_host'] }

        hosts.elements << Hosts::Entry.new('127.0.0.1', provider['dev_host'])
        hosts.write
      end
    end
  end

  def squeak!
    "Qeak Queak sqeaks <##{object_id}>"
  end
end
