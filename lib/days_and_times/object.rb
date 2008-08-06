class Object
  def bind_class_object_method(other, self_method_name, other_method_name, args=[[],[]])
    # Since I can't pass the 'other' object into eval as a string, I have to
    #   set a class instance variable and copy the contents to a class variable
    #   so that the generated method will play nicely with subclasses.
    self.instance_variable_set("@#{self_method_name.to_s}_OBJ", other)
    self.send :eval, "@@#{self_method_name.to_s}_OBJ = @#{self_method_name.to_s}_OBJ
    def #{self_method_name.to_s}(#{args[0].join(', ')})
      @@#{self_method_name.to_s}_OBJ.#{other_method_name.to_s}(#{args[1].join(', ')})
    end"
    self
  end
  def bind_object_method(other, self_method_name, other_method_name, args=[[],[]])
    self.instance_variable_set("@#{self_method_name}_OBJ", other)
    eval "def self.#{self_method_name}(#{args[0].join(', ')})
      @#{self_method_name}_OBJ.#{other_method_name}(#{args[1].join(', ')})
    end"
  end
end
