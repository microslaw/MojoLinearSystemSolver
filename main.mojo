from memory.unsafe import DTypePointer



alias Vect = Vector[DType.int8]


struct Vector[DataType: DType]:
   var size : Int
   var data : DTypePointer[DataType]

   fn __init__(inout self : Vector[DataType], size : Int):
      self.size = size
      self.data = DTypePointer[DataType].alloc(size)
      memset_zero(self.data, size)

   fn __setitem__(inout self : Vector[DataType], index : Int, value : DType):
      self.data[index] = DataType(value)

   fn __getitem__(borrowed self : Vector[DataType], index : Int) -> DataType:
      return self.data[index]



