module Present
  class Entity

    def self.represent(object, options = {})
      if object.respond_to?(:to_ary)
        objects = object
        objects.map { |o| represent(o, options) }
      else
        entity = new(object, options)
        entity.nil? ? nil : entity.serializable_hash
      end
    end

    def self.expose(*attributes)
      attributes.each do |attribute|
        define_method attribute do
          object.public_send(attribute)
        end
      end
    end

    def self.new(object, options = {})
      return nil if object.nil?

      instance = allocate
      instance.send(:initialize, object, options)
      instance
    end

    def initialize(object, options = {})
      @object = object
      @options = options
    end

    def serializable_hash(options = {})
      attr_pairs = attribute_names.map { |name| [name, read_attribute(name)] }
      Hash[ attr_pairs ]
    end
    alias_method :to_h, :serializable_hash
    alias_method :as_json, :serializable_hash
    alias_method :attributes, :serializable_hash

    protected

    attr_reader :object, :options

    def include? property
      options.include? property
    end

    private

    def read_attribute(name)
      if respond_to? name
        public_send(name)
      elsif object.respond_to?(name)
        object.public_send(name)
      end
    end

    def attribute_names
      self.class.attribute_names
    end

    def self.attribute_names
      if superclass != Entity
        [*public_instance_methods(false), *superclass.send(:attribute_names)].uniq
      else
        public_instance_methods(false)
      end
    end

  end
end