module ActiveHash
  extend ActiveSupport::Concern
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations
  include ActiveModel::Serialization

  included do
    def initialize(attributes = {})
      self.assign_attributes(attributes)
    end    
  end

  class_methods do
    def has_hash_attributes(args)
      @@key   = args[:key]
      @@value = args[:value]

      self.class_eval do
        validates key, unique_key: true
        validates key, presence: true
      end
    end

    def key
      @@key
    end

    def value
      @@value
    end

    def find(lookup_key)
      redis_record = Redis.current.get("#{self.to_s.downcase}:#{lookup_key}")

      if !redis_record.nil?
        self.new(key => lookup_key, value => redis_record)
      else
        return nil
      end
    end
  end

  def save
    if self.valid?
      Redis.current.set(lookup_key, hash_value)
      return self
    else
      return false
    end
  end

  def lookup_key
    "#{hash_prefix}:#{hash_key}"
  end

  private

    def hash_prefix
      self.class.to_s.downcase
    end

    def hash_key
      public_send(self.class.key)
    end

    def hash_value
      public_send(self.class.value)
    end
end