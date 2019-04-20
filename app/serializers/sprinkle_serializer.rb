class SprinkleSerializer
  include FastJsonapi::ObjectSerializer
  
  attributes :id, :color, :shape
end
