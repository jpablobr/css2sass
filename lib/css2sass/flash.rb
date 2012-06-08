module Rack
  class Flash
    # Raised when the session passed to FlashHash initialize is nil. This
    # is usually an indicator that session middleware is not in use.
    class SessionUnavailable < StandardError; end

    # Implements bracket accessors for storing and retrieving flash entries.
    class FlashHash
      attr_reader :flagged

      def initialize(store, opts={})
        raise Rack::Flash::SessionUnavailable \
          .new('Rack::Flash depends on session middleware.') unless store

        @opts = opts
        @store = store

        if accessors = @opts[:accessorize]
          accessors.each { |opt| def_accessor(opt) }
        end
      end

      # Remove an entry from the session and return its value. Cache result in
      # the instance cache.
      def [](key)
        key = key.to_sym
        cache[key] ||= values.delete(key)
      end

      # Store the entry in the session, updating the instance cache as well.
      def []=(key,val)
        key = key.to_sym
        cache[key] = values[key] = val
      end

      # Store a flash entry for only the current request, swept regardless of
      # whether or not it was actually accessed. Useful for AJAX requests, where
      # you want a flash message, even though you're response isn't redirecting.
      def now
        cache
      end

      # Checks for the presence of a flash entry without retrieving or removing
      # it from the cache or store.
      def has?(key)
        [cache, values].any? { |store| store.keys.include?(key.to_sym) }
      end
      alias_method :include?, :has?

      # Mark existing entries to allow for sweeping.
      def flag!
        @flagged = values.keys
      end

      # Remove flagged entries from flash session, clear flagged list.
      def sweep!
        Array(flagged).each { |key| values.delete(key) }
        flagged.clear
      end

      # Hide the underlying :__FLASH__ session key and only expose values stored
      # in the flash.
      def inspect
        '#<FlashHash @values=%s @cache=%s>' % [values.inspect, cache.inspect]
      end

      # Human readable for logging.
      def to_s
        values.inspect
      end

      private

      # Maintain an instance-level cache of retrieved flash entries. These
      # entries will have been removed from the session, but are still available
      # through the cache.
      def cache
        @cache ||= {}
      end

      # Helper to access flash entries from :__FLASH__ session value. This key
      # is used to prevent collisions with other user-defined session values.
      def values
        @store[:__FLASH__] ||= {}
      end

      # Generate accessor methods for the given entry key if :accessorize is true.
      def def_accessor(key)
        raise ArgumentError.new('Invalid entry type: %s' % key) if respond_to?(key)

        class << self; self end.class_eval do
          define_method(key) { |*args| val = args.first; val ? (self[key]=val) : self[key] }
          define_method("#{key}=") { |val| self[key] = val }
          define_method("#{key}!") { |val| cache[key] = val }
        end
      end
    end

    # -------------------------------------------------------------------------
    # - Rack Middleware implementation

    def initialize(app, opts={})
      if klass = app_class(app, opts)
        klass.class_eval do
          def flash; env['x-rack.flash'] end
        end
      end

      @app, @opts = app, opts
    end

    def call(env)
      env['x-rack.flash'] ||= Rack::Flash::FlashHash.new(env['rack.session'], @opts)

      if @opts[:sweep]
        env['x-rack.flash'].flag!
      end

      res = @app.call(env)

      if @opts[:sweep]
        env['x-rack.flash'].sweep!
      end

      res
    end

    private

    def app_class(app, opts)
      return nil if opts.has_key?(:helper) and not opts[:helper]
      opts[:flash_app_class] ||
        defined?(Sinatra::Base) && Sinatra::Base ||
        self.class.rack_builder.leaf_app.class
    end
  end
end
