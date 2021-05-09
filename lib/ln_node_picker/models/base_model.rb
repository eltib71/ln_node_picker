module LnNodePicker
  class BaseModel < Dry::Struct

    transform_keys(&:to_sym)

  end
end
