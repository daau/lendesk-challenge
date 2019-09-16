  # Custom uniqueness validator
  # Checks Redis to see if the key is unique
  class UniqueKeyValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if Redis.current.get(record.lookup_key)
        record.errors[attribute] << (options[:message] || 'has already been taken')
      end
    end
  end