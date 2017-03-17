require 'fluent/output'

module Fluent
  require 'rest-client'
  require 'json'
  
  class MoogAIOpsOutput < BufferedOutput
    # First, register the plugin. NAME is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_output('moogaiops', self)

    config_param :uri, :string, :default => 'http://localhost:8888'
    config_param :auth, :string, :default => 'graze:graze', secret: true
    config_param :source, :string, :default => '{TAG}'
    config_param :sourcetype, :string, :default => 'fluentd'
    config_param :location, :string, :default => 'local'
    config_param :severity, :integer, :default => 1

    # This method is called before starting.
    # 'conf' is a Hash that includes configuration parameters.
    # If the configuration is invalid, raise Fluent::ConfigError.
    def configure(conf)
      super

      require 'socket'
      @hostname = Socket.gethostname

      # You can also refer raw parameter via conf[name].
      @uri = conf['uri']
      $log.debug "Config URI #{@uri}"
      @manager = conf['sourcetype']

      case @source
      when '{TAG}'
        @source_formatter = lambda { |tag| tag }
      else
        @source_formatter = lambda { |tag| @source.sub('{TAG}', tag) }
      end

      @formatter = lambda { |record|
          record.to_json
      }

    end

    # This method is called when starting.
    # Open sockets or files here.
    def start
      super
      $log.debug "initialized for moogaiops"
    end

    # This method is called when shutting down.
    # Shutdown the thread and close sockets or files here.
    def shutdown
      super
      $log.debug "shutdown from moogaiops"
    end

    # This method is called when an event reaches to Fluentd.
    # Convert the event to a raw string.
    def format(tag, time, record)
      newrecord = {}

      begin
        if record['severity']
          newrecord['severity'] = Integer(record['severity'])
        else
          newrecord['severity'] = @severity
        end
      rescue
        newrecord['severity'] = @severity
      end

      newrecord['type'] = tag.to_s
      newrecord['agent_time'] = time.to_s
      newrecord['manager'] = @manager
      newrecord['class'] = @source
      newrecord['source'] = @hostname
      newrecord['description'] = record['message']
      newrecord['custom_info'] = record

      newrecord.to_msgpack
    end

    def chunk_to_buffers(chunk)
      buffers = []
      buffer = {}
      events = []
    	chunk.msgpack_each do |event|
        $log.debug "Buffering event = #{event}"
    	  events << event
    	end
      buffer['events'] = events
      $log.debug "Return buffer #{buffer}"
      buffers << buffer
      return buffers
    end

    # This method is called every flush interval. Write the buffer chunk
    # to files or databases here.
    # 'chunk' is a buffer chunk that includes multiple formatted
    # events. You can use 'data = chunk.read' to get all events and
    # 'chunk.open {|io| ... }' to get IO objects.
    #
    # NOTE! This method is called by internal thread, not Fluentd's main thread. So IO wait doesn't affect other plugins.
    def write(chunk)
      #data = chunk.read
      #print data
      #$log.debug "Data #{data}"

      username, password = @auth.split(':')
      $log.debug "#{username} : #{password}"

      chunk_to_buffers(chunk).each do |buffer|

        bufj = buffer.to_json
        $log.debug "Buffer #{bufj}"

        re = RestClient::Resource.new(@uri, {:user => username, :password => password,:verify_ssl => 0})

        response = re.post bufj, :content_type => 'application/json'
        $log.debug "POST #{@uri}"
        jr = JSON.parse(response.body)
        $log.debug "=> #{response.code} (#{response.body})"
        if response.code == 200
          if jr['success']
            # success
            log.info "200 Ok!"
            break
          else
            $log.error "Error 200 returned with message #{response.body}"
          end
        elsif response.code.match(/^40/)
          # user error
          $log.error "#{uri}: #{response.code} \n#{response.body}"
          break
        else
          # other errors. fluentd will retry processing on exception
          # FIXME: this may duplicate logs when using multiple buffers
          raise "#{uri}: #{response.body}"
        end
      end
    end

    ## Optionally, you can use chunk.msgpack_each to deserialize objects.
    #def write(chunk)
    #  chunk.msgpack_each {|(tag,time,record)|
    #  }
    #end

  end
end
