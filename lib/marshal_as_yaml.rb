module MarshalAsYaml
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def marshal_as_yaml(*attrs)
      attrs = [attrs] unless attrs.is_a?(Array)
      attrs.each do |attr|
        define_method attr do
          return nil if read_attribute(attr).nil?
          YAML.load read_attribute(attr)
        end
        
        define_method "#{attr}_without_marshaling" do
          read_attribute attr
        end
      
        define_method "#{attr}=" do |val|
          write_attribute attr, (val && val.to_yaml)
        end

        define_method "#{attr}_without_marshaling=" do |val|
          write_attribute attr, val
        end
      end
    end
  end
end